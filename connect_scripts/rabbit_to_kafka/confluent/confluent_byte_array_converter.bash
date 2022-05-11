#!/bin/bash
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -d '{ "name": "confluent_byte_array_converter",
    "config":
    {
        "connector.class" : "io.confluent.connect.rabbitmq.RabbitMQSourceConnector",
        "kafka.topic" : "subscriptions_confluent",
        "rabbitmq.queue" : "us.customer.subscription.created",
        "rabbitmq.username": "guest",
        "rabbitmq.password": "guest",
        "rabbitmq.host": "my-rabbit",
        "rabbitmq.port": "5672",
        "rabbitmq.virtual.host": "/",
        "confluent.license":"",
        "confluent.topic.bootstrap.servers":"broker:29092",
        "confluent.topic.replication.factor":1,
        "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
        "value.converter.schemas.enable": "false",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter"
    }
}
'