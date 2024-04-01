FROM node:14

RUN mkdir -p /app
WORKDIR /app
#/usr/src/app
COPY package.json /app
RUN npm install

COPY . /app

EXPOSE 5000
EXPOSE 8080

ENTRYPOINT ["node"]

CMD ["app.js"]
