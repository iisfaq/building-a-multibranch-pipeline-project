FROM node:lts-alpine
EXPOSE 3000
EXPOSE 5000
WORKDIR /src
COPY . .

ENTRYPOINT ["tail", "-f", "/dev/null"]