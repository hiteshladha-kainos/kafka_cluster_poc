#!/bin/bash
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -d '{ "name": "ibm_string_converter",
    "config":
    {
        "connector.class": "com.ibm.eventstreams.connect.rabbitmqsource.RabbitMQSourceConnector",
        "rabbitmq.host": "my-rabbit",
        "tasks.max": "10",
        "kafka.topic" : "subscriptions_ibm",
        "rabbitmq.queue" : "us.customer.subscription.created",
        "rabbitmq.prefetch.count": "500",
        "rabbitmq.automatic.recovery.enabled": "true",
        "rabbitmq.network.recovery.interval.ms": "10000",
        "rabbitmq.topology.recovery.enabled": "true",
        "key.converter":"org.apache.kafka.connect.storage.StringConverter",
        "value.converter":"org.apache.kafka.connect.storage.StringConverter",
        "value.converter.schemas.enable": "false"
    }
}
'