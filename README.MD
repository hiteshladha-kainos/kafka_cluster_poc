## Local Rabbitmq and kafka connect repository
This repository consists of basic docker infrastrtucture consisting
of rabbitmq, kafka, kafka connect and optional to use kafka schema registry.

Make sure you have enough memory in docker (4 GB should be enough).

To install confluent connectors it's best if you are connected to the Kainos VPN due to some zscaler issues with installing
them from confluent hub (inside dockerfile)

To install ibm connector clone this repo [ibm connector github](https://github.com/ibm-messaging/kafka-connect-rabbitmq-source) and 
change directory to `kafka-connect-mq-source` and run `mvn clean package` inside it. After the file is built mount or copy the compiled jar file
(target/kafka-connect-rabbitmq-source-1.0-SNAPSHOT-jar-with-dependencies.jar)into 
the /usr/local/share/java/ directory.

** prebuilt ibm connector jar file included: ./jar_files/ibm/kafka-connect-rabbitmq-source-1.0-SNAPSHOT-jar-with-dependencies.jar
** also in ./jar-files the conlunetc protobuf files, although they are installed during connector build using confluent hub

In docker compose file there is a commented example on how to mount it as an external volume to connect instance.

## Run
To run the infrastructure run command `docker-compose up -d`
Check all services up `docker ps`, if not rerun `docker-compose up -d`
Check logs 'docker logs `<container name>`

## Producers and Consumer
run python scripts to add/remove messages from rabbitmq queue

periodically generate messages:
while :
do
	echo generating data to rmq
             python3 producer.py
	echo "Press CTRL+C to exit"
	sleep 10
done


## This does not seem to work in docker, but should if docker hosted not using Kainos laptop
You can access the kafka control center in 
after the infrastructure is setup,run an example producer under producers folder, which will produce 10 messagers with 
example payload to 'us.customer.subscription.created' queue. 


After the messages are in queue run either confluent or ibm connector job which are located under connect_scripts folder.
After the script is launched it should move messages from rabbitmq to a kafka topic.

If you want to restart a connector I found that it's best to delete it
and recreate.
`curl -X DELETE http://localhost:8083/connectors/connector_name`

List connectors:
`curl -X GET http://localhost:8083/connectors/`

## Checking messages on Kafka Topics:

Read messages from topic:
`docker exec --interactive --tty broker kafka-console-consumer --bootstrap-server broker:9092 --topic <topic name> --from-beginning`

List topics:
`docker exec --interactive --tty broker kafka-topics --bootstrap-server broker:9092 --list`

## Additional link to information:
Kafka Connect Concepts: https://docs.confluent.io/platform/current/connect/concepts.html#connect-converters
Protobuf Schema Serializer and Deserializer: https://docs.confluent.io/platform/current/schema-registry/serdes-develop/serdes-protobuf.html#multiple-event-types-same-topic-protobuf
Using Kafka Connect with Schema Registry: https://docs.confluent.io/platform/current/schema-registry/connect.html#schemaregistry-kafka-connect

RabbitMQ data generator in Python: https://docs.confluent.io/kafka-connect-rabbitmq-source/current/overview.html#rabbitmq-data-generator-in-python


## Access rabbit and kafka control center
rabbit: localhost:15672 , username:guest, password:guest </br>
control center: localhost:9021

rabbitmq comes with some preconfigured queues and exchanges.
