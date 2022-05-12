#!/bin/bash
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -d '{ "name": "json_converter_schema",
    "config":
    {
      "connector.class":"io.confluent.connect.s3.S3SinkConnector",
      "aws.access.key.id":"xxx",
      "aws.secret.access.key":"xxxxx",
      "s3.region":"us-east-1",
      "flush.size":10,
      "schema.compatibility":"NONE",
      "tasks.max":10,
      "topics":"subscriptions_ibm",
      "format.class":"io.confluent.connect.s3.format.parquet.ParquetFormat",
      "storage.class":"io.confluent.connect.s3.storage.S3Storage",
      "s3.bucket.name":"kafka-cluster-testing2",
      "topics.dir":"confluent-schema-p",
      "key.converter":"org.apache.kafka.connect.storage.StringConverter",
      "value.converter":"io.confluent.connect.json.JsonSchemaConverter",
      "value.converter.schemas.enable": "false",
      "value.converter.schema.registry.url":"http://localhost:8081"
    }
}
'