FROM node:16-alpine

WORKDIR /app

ADD ./credentials ~/.aws/credentials
ADD ./queue_url.txt /opt/queue_url.txt

ENV REGION="eu-central-1"
ENV SQS_QUEUE_URL_LOCATION="/opt/queue_url.txt"
ENV AWS_SDK_LOAD_CONFIG=1
ENV AWS_CONFIG_FILE="~/.aws/credentials"

ADD ./producer /app

RUN npm install -g npm@8.13.1 && npm install

CMD ["npm", "run", "produce"]