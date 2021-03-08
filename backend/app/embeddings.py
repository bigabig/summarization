import torch

# init bert model
from transformers import BertModel, BertTokenizer

print("Loading bert model...")
modelname = 'bert-base-uncased'
tokenizer = BertTokenizer.from_pretrained(modelname)
model = BertModel.from_pretrained(modelname)


def embed_sentence(sentence):
    global tokenizer, model

    # tokenize sentence
    input_tokens = tokenizer.encode(sentence, max_length=tokenizer.model_max_length, return_tensors='pt')

    # embed sentence
    with torch.no_grad():
        outputs = model(input_tokens)
    last_hidden_states = outputs[0]  # The last hidden-state is the first element of the output

    # return the sentence embedding (mean of the word embeddings)
    return torch.mean(last_hidden_states, 1).squeeze()


def embed_document(document):
    # tokenize sentence
    sentences = [sent['text'] for sent in document['sentences']]
    input_tokens = tokenizer(sentences, max_length=tokenizer.model_max_length, return_tensors='pt', padding=True)

    # embed sentence
    with torch.no_grad():
        outputs = model(**input_tokens)
    last_hidden_states = outputs[0]  # The last hidden-state is the first element of the output

    # calculate sentence embeddings by averaging the token embeddings
    sentence_embeddings = last_hidden_states.mean(dim=1)

    # save the result
    for idx, sent in enumerate(document['sentences']):
        sent['embedding'] = sentence_embeddings[idx]


def embed_sentences(sentences):
    # tokenize sentence
    sentences = [sentence for sentence in sentences]
    input_tokens = tokenizer(sentences, max_length=tokenizer.model_max_length, return_tensors='pt', padding=True)

    # embed sentence
    with torch.no_grad():
        outputs = model(**input_tokens)
    last_hidden_states = outputs[0]  # The last hidden-state is the first element of the output

    # calculate sentence embeddings by averaging the token embeddings
    sentence_embeddings = last_hidden_states.mean(dim=1)

    # save the result
    return sentence_embeddings