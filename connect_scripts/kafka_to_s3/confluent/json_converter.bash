#!/bin/bash
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
      "topics.dir":"confluent",
      "key.converter":"org.apache.kafka.connect.storage.StringConverter",
      "value.converter":"org.apache.kafka.connect.json.JsonConverter",
      "value.converter.schemas.enable": "false"
    }
}
'