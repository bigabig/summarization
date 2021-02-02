from transformers import BartForConditionalGeneration, AutoTokenizer

print("Loading backend model...")
method = "sshleifer/distilbart-cnn-12-6"
tokenizer = AutoTokenizer.from_pretrained("sshleifer/distilbart-cnn-12-6")
model = BartForConditionalGeneration.from_pretrained("sshleifer/distilbart-cnn-12-6")
ARTICLE = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. " \
          "Its base is square, measuring 125 metres (410 ft) on each side. " \
          "During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, " \
          "a title it held for 41 years until the Chrysler Building in New York City was finished in 1930. It was the first structure to reach a height of 300 metres. " \
          "Due to the addition of a broadcasting aerial at the top of the tower in 1957, it is now taller than the Chrysle Building by 5.2 metres (17 ft). " \
          "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France after the Millau Viaduct."
LENGTH = 150


def switch_method(new_method):
    global tokenizer, model, method
    if method != new_method:
        print(f"Switching method from {method} to {new_method}.")
        method = new_method
        tokenizer = AutoTokenizer.from_pretrained(new_method)
        model = BartForConditionalGeneration.from_pretrained(new_method)


def summarize(text, length):
    inputs = tokenizer.encode(text, return_tensors="pt", truncation=True, max_length=512)
    outputs = model.generate(inputs, max_length=length, min_length=40, length_penalty=2.0, num_beams=4, early_stopping=True, )
    summary = tokenizer.decode(outputs[0], skip_special_tokens=True)
    summary = summary.replace("<s>", "").replace("</s>", "").replace("<unk>", "").strip()
    return summary
