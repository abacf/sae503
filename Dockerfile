FROM alpine:edge

RUN apk update && apk upgrade && \
    apk add py3-fastapi py3-redis uvicorn git --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    mkdir /app && cd /app && \
    git clone https://github.com/guilloss/iut-stmalo-sae503 .

EXPOSE 8000
CMD cd /app &&  python app.py