# docker build -t bigabig/factcc:latest .

FROM python:3.8

RUN mkdir models

# We copy just the requirements.txt first to leverage Docker cache
COPY app/requirements.txt /app/requirements.txt

WORKDIR /app

ENV PYTORCH_TRANSFORMERS_CACHE=/models

ENV CHECKPOINT_DIR=/checkpoint

RUN pip install -r requirements.txt

COPY app /app

EXPOSE 4444

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]