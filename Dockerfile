FROM python:alpine
ENV PYTHONUNBUFFERED=1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories


RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver


RUN apk add --update --no-cache python3-dev \
                        gcc \
                        libc-dev \
                        libffi-dev
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN apk add --update --no-cache g++ gcc libxslt-dev

RUN apk add --update --no-cache git

WORKDIR /code
COPY requirements-dev.txt requirements-dev.txt
RUN python -m pip install --upgrade pip
RUN pip3 install --upgrade pip setuptools wheel

RUN apk update && apk add build-base libzmq musl-dev python3 python3-dev zeromq-dev
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo
RUN pip3 install -r requirements-dev.txt
RUN apk upgrade musl
RUN pip3 install torch==1.9.0+cpu torchvision==0.10.0+cpu torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN apk del .tmp-build-deps
COPY . /code/