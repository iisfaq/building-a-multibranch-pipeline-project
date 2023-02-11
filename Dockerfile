FROM node:lts-alpine
EXPOSE 3000
EXPOSE 5000
WORKDIR /src
COPY . .
RUN apk add --no-cache bash
run /bin/bash

