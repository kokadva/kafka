FROM arm64v8/openjdk:22-ea-22-jdk-bullseye


ARG kafkaversion=3.3.1
ARG scalaversion=2.13
ARG kafkaurl=https://archive.apache.org/dist/kafka/$kafkaversion/kafka_${scalaversion}-${kafkaversion}.tgz
WORKDIR /app

RUN apt-get update 
RUN apt-get install -y --no-install-recommends wget 
RUN wget ${kafkaurl} -O kafka.tgz 
RUN tar xvzf kafka.tgz 
RUN mv kafka_${scalaversion}-${kafkaversion} kafka 
RUN apt-get remove -y wget 
RUN apt-get autoremove -y 
RUN rm -rf /var/lib/apt/lists/* 
RUN rm kafka.tgz


WORKDIR /app/kafka

COPY server.properties .
COPY ./**.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
