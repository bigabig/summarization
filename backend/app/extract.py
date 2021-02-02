# pip install PyPDF2
# pip install textract
# pip install trafilatura
# https://textract.readthedocs.io/en/latest/installation.html
# https://medium.com/@thibaultmonsel_4024/extract-text-from-pdf-with-python-python-pdf-processing-part-1-be875d76234b
# https://github.com/adbar/trafilatura

import textract
import re
import trafilatura


def pdf_to_text(filepath):
    # Extract text
    text = textract.process(filepath, method='tesseract', language='eng', encoding="UTF-8")

    # Cleaning
    text = text.decode("utf-8")
    text = re.sub(r"\s+\n\s+", "\n\n", text)
    text = re.sub(r"(.)(-\n+)(.)", r"\1\3", text)
    text = re.sub(r"(.)(\n)(.)", r"\1 \3", text)
    text = text.strip()

    # Construct result
    result = text.splitlines()

    return result

    # # Output
    # with open('output.txt', 'w', encoding="UTF-8") as file:
    #     file.write(text)


    # # Output 2
    # with open('output2.txt', 'w') as outfile:
    #     json.dump(result, outfile)


def txt_to_text(filepath):
    with open(filepath, 'r', encoding="UTF-8") as file:
        result = [line for line in file.readlines() if len(line.strip()) > 0]
    return result


def url_to_text(url):
    downloaded = trafilatura.fetch_url(url)
    text = trafilatura.extract(downloaded, include_images=False, include_tables=False, include_comments=False)
    return text
