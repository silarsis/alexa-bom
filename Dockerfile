FROM alpine:latest
RUN apk add --update curl
RUN curl https://raw.githubusercontent.com/apex/apex/master/install.sh | sh

ADD app /app
WORKDIR /app
ENTRYPOINT apex