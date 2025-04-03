FROM bellsoft/liberica-openjdk-alpine

#install curl and jq to check the health of the hub, and jq to parse the json response,
RUN apk add curl jq

#create work dir
WORKDIR /home/selenium-docker

#add required file to run the test
ADD target/docker-resources ./
ADD runner.sh runner.sh 
 # Environment varibales

ENTRYPOINT sh runner.sh
