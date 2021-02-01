# pip install PyPDF2
# pip install textract
# https://textract.readthedocs.io/en/latest/installation.html
# https://medium.com/@thibaultmonsel_4024/extract-text-from-pdf-with-python-python-pdf-processing-part-1-be875d76234b

import PyPDF2
import textract
import re
import json
from space import split_sentences


def pdf_to_text(filepath):
    text = textract.process(filepath, method='tesseract', language='eng', encoding="UTF-8")

    # Cleaning
    text = text.decode("utf-8")
    text = re.sub(r"\s+\n\s+", "\n\n", text)
    text = re.sub(r"(.)(-\n+)(.)", r"\1\3", text)
    text = re.sub(r"(.)(\n)(.)", r"\1 \3", text)
    text = text.strip()

    # Output
    with open('output.txt', 'w', encoding="UTF-8") as file:
        file.write(text)

    result = split_sentences(text)

    # Output 2
    with open('output2.txt', 'w') as outfile:
        json.dump(result, outfile)

    return result
