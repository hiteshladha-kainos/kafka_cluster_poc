## Local Rabbitmq and kafka connect repository
This repository consists of basic docker infrastrtucture consisting
of rabbitmq, kafka, kafka connect and optional to use kafka schema registry.

Make sure you have enough memory in docker (4 GB should be enough, however if available increase to 6 GB if using registryschema too).

To install confluent connectors it's best if you are connected to the Kainos VPN due to some zscaler issues with installing
them from confluent hub (inside dockerfile)
Without the VPN, when running `docker compose build`, the following error is displayed: javax.net.ssl.SSLHandshakeException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target 


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


## Kafka Control center
You can access the kafka control center after the infrastructure is setup.  http://localhost:9021

## Generate data on RabbitMQ Queue
Run an example producer under producers folder, which will produce 10 messagers with example payload to 'us.customer.subscription.created' RabbitMQ queue. 

## Connectors
After the messages are in queue run either confluent or ibm connector scripts to generate the tasks which are located under connect_scripts folder.
After the script is launched it should move messages from rabbitmq to a kafka topic, or sink to S3

If you want to restart a connector I found that it's best to delete it and recreate.

Delete connectors:
`curl -X DELETE http://localhost:8083/connectors/connector_name`

List connectors:
`curl -X GET http://localhost:8083/connectors/`

# If running on Kainos laptop, access may not be possible via localhost on port 8083, or docker container port 5005, therefore runt he nonnector scripts on the container:
`docker exec connect curl -X GET http://localhost:8083/connectors`
`docker exec connect curl -X DELETE http://localhost:8083/connectors/<connector-name>`

docker exec connect curl -X GET http://localhost:8083/connectors
docker exec connect curl -X DELETE http://localhost:8083/connectors/<connector-name>

docker exec connect \
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -d '{ "name": "json_converter",
    "config":
    {
      "connector.class":"io.confluent.connect.s3.S3SinkConnector",
      "aws.access.key.id":"xxxx", 
      "aws.secret.access.key":"xxxx",
      "s3.region":"us-east-1",
      "flush.size":10,
      "schema.compatibility":"NONE",
      "tasks.max":10,
      "topics":"subscriptions_ibm",
      "format.class":"io.confluent.connect.s3.format.json.JsonFormat",
      "storage.class":"io.confluent.connect.s3.storage.S3Storage",
      "s3.bucket.name":"kafka-cluster-testing2",
      "topics.dir":"confluent_parquet",
      "key.converter":"org.apache.kafka.connect.storage.StringConverter",
      "value.converter":"org.apache.kafka.connect.json.JsonConverter",
      "value.converter.schemas.enable": "false",
	   "value.converter.schema.registry.url":"http://localhost:8081"
    }
}
'

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
rabbit: localhost:15672 , username:guest, password:guest
control center: localhost:9021

rabbitmq comes with some preconfigured queues and exchanges.
