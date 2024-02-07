FROM alpine:edge

WORKDIR /app

RUN apk update && apk upgrade && \
    apk add --no-cache py3-fastapi py3-redis uvicorn git --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    git clone https://github.com/guilloss/iut-stmalo-sae503 . && \
    chmod +x /app/app.py

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 8000
CMD ["/docker-entrypoint.sh"]