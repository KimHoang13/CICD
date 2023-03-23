# syntax=docker/dockerfile:1

FROM python:3.8-slim-buster

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . /python-docker
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /python-docker
USER appuser

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]