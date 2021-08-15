# Based on alpine-python latest 
FROM python:alpine
# 버퍼없이 슬림하게 유지하기 위해
ENV PYTHONUNBUFFERED=1
# dependencies to make postgres work on alpine python
# RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

# 크롬드라이버설치 /usr/lib/chromium 에 설치된다.
RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver

# 파이썬 패키지설치환경
RUN apk add --update --no-cache python3-dev \
                        gcc \
                        libc-dev \
                        libffi-dev
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN apk add --update --no-cache g++ gcc libxslt-dev

# git 설치
RUN apk add --update --no-cache git

# 컨테이너의 작업디렉토리 /code/를 만든다.
WORKDIR /code
COPY requirements-dev.txt requirements-dev.txt
RUN python -m pip install --upgrade pip
RUN pip3 install --upgrade pip setuptools wheel

# jupyterlab작동을 위한 pyzmq 설치에 필요한 것들
RUN apk update && apk add build-base libzmq musl-dev python3 python3-dev zeromq-dev
# scrapy 설치를 위한 crytography 설치환경
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo

# 주요 python packages
RUN pip install --upgrade pip
RUN pip3 install -r requirements-dev.txt

# 토치 cpu버전
RUN pip3 install torch==1.9.0+cpu torchvision==0.10.0+cpu torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

# 설치에 필요했던 파일 지워 슬림하게 유지.
RUN apk del .tmp-build-deps

# 현재 디렉토리를 컨테이너 copy/디렉토리에 복사
COPY . /code/