from transformers.models.roberta import RobertaModel, RobertaTokenizer
import torch

# Language Model
print("Loading roberta language model...")
tokenizer = RobertaTokenizer.from_pretrained("roberta-large-mnli")
model = RobertaModel.from_pretrained("roberta-large-mnli")


def calculate_word_to_token_mapping(words, offset):
    word_to_index = []
    counter = offset
    for i in range(len(words)):
        token_ids = tokenizer(words[i], add_special_tokens=False, add_prefix_space=True)['input_ids']
        mapping = [j + counter for j in range(len(token_ids))]
        word_to_index.append((words[i], mapping))
        counter += len(token_ids)
    return word_to_index, counter - offset


def calculate_word_embeddings(document):
    """
    :param document: a dict which has to contain the 'sentences' key
    :return: Array of tuples [(word, word_embedding tensor), ...]
    """

    # append 3 sentences at once as input to the model
    # calculate mappings from words to tokens (word pieces)
    inputs = []
    word_to_token_mappings = []
    mapping_lengths = []
    for i in range(len(document['sentences'])):
        if i == 0 and len(document['sentences']) == 1:
            text = document['sentences'][i]['text']
            mapping, mapping_length = calculate_word_to_token_mapping(document['sentences'][i]['text'].split(), offset=0)
        elif i == 0:
            text = " ".join([document['sentences'][i]['text'], document['sentences'][i + 1]['text']])
            mapping, mapping_length = calculate_word_to_token_mapping(document['sentences'][i]['text'].split(), offset=0)
        elif i == len(document['sentences']) - 1:
            text = " ".join([document['sentences'][i - 1]['text'], document['sentences'][i]['text']])
            mapping, mapping_length = calculate_word_to_token_mapping(document['sentences'][i]['text'].split(), offset=mapping_lengths[i - 1])
        else:
            text = " ".join([document['sentences'][i - 1]['text'], document['sentences'][i]['text'], document['sentences'][i + 1]['text']])
            mapping, mapping_length = calculate_word_to_token_mapping(document['sentences'][i]['text'].split(), offset=mapping_lengths[i - 1])
        inputs.append(text)
        word_to_token_mappings.append(mapping)
        mapping_lengths.append(mapping_length)

    # embed all sentences as batch
    model_inputs = tokenizer(inputs, return_tensors="pt", padding=True)  # this also adds the special tokens necessary for the model
    outputs = model(**model_inputs, output_hidden_states=True)
    intermediate_hidden_state = outputs.hidden_states[8]  # shape [#sentences, #tokens, #embedding_size]

    # compute word embeddings (from token to word embeddings)
    word_embeddings = []
    token_embeddings = []
    # we have one mapping per sentence
    for sentence_id, mapping in enumerate(word_to_token_mappings):
        # one word may map to multiple tokens
        # here, if a word maps to multiple tokens, we stack the embeddings and calculate the average
        # (we add +1 to the token_id as the model always adds the begin of sentence token <s>)
        # finally, we create a (word, word_embedding) pair
        word_embeddings.extend([(token_tuple[0], torch.stack([intermediate_hidden_state[sentence_id][token_id + 1] for token_id in token_tuple[1]]).mean(0).detach()) for token_tuple in mapping])

        # also get the token embeddings
        important_tokens = [token_id for token_tuple in mapping for token_id in token_tuple[1]]
        token_embeddings.extend([intermediate_hidden_state[sentence_id][token_id + 1].detach() for token_id in important_tokens])

    words = [t[0] for t in word_embeddings]
    word_embeddings = torch.stack([t[1] / t[1].norm() for t in word_embeddings])
    token_embeddings = torch.stack([t / t.norm() for t in word_embeddings])
    return words, word_embeddings, token_embeddings


def calculate_bertscore(summary_document, source_document):
    summary_words, summary_word_embeddings, summary_token_embeddings = calculate_word_embeddings(summary_document)
    source_words, source_word_embeddings, source_token_embeddings = calculate_word_embeddings(source_document)

    # calculate similarity matrix with dot product of normalized vectors
    # [summary_word_id, source_word_id]
    similarities12 = summary_word_embeddings.mm(source_word_embeddings.T)
    # [source_word_id, summary_word_id]
    similarities21 = source_word_embeddings.mm(summary_word_embeddings.T)

    # calculate most similar words (from summary -> source)
    # [(summary_word, summary_word_id, source_word, source_word_id, similarity_score), ...]
    values, indices = similarities12.max(dim=1)
    most_similar_words = [(summary_words[summary_word_index], summary_word_index, source_words[source_word_index], source_word_index, value) for summary_word_index, (value, source_word_index) in enumerate(zip(values.tolist(), indices.tolist()))]

    # calculate most similar words (from source -> summary)
    # [(source_word, source_word_id, summary_word, summary_word_id, similarity_score), ...]
    values, indices = similarities21.max(dim=1)
    most_similar_words_2 = [(source_words[source_word_index], source_word_index, summary_words[summary_word_index], summary_word_index, value) for source_word_index, (value, summary_word_index) in enumerate(zip(values.tolist(), indices.tolist()))]

    # calculate real bertscore based on tokens for the whole summary
    similarities = summary_token_embeddings.mm(source_token_embeddings.T)
    p_bert = similarities.max(dim=1).values.mean()
    r_bert = similarities.max(dim=0).values.mean()
    f_bert = 2 * ((p_bert * r_bert) / (p_bert + r_bert))

    return {
        'summary_bertscores': most_similar_words,
        'source_bertscores': most_similar_words_2,
        'pbert': p_bert.item(),
        'rbert': r_bert.item(),
        'fbert': f_bert.item(),
    }

