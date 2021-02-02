import torch

# init bert model
from transformers import BertModel, BertTokenizer

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
