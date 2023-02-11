FROM node:16.13.1-alpine
WORKDIR /src
COPY . .
RUN ls /src
