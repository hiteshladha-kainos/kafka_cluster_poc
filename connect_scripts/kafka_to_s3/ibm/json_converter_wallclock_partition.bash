#!/bin/bash
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -d '{ "name": "json_converter_wallclock_partition",
    "config":
    {
      "connector.class":"io.confluent.connect.s3.S3SinkConnector",
      "s3.region":"eu-west-1",
      "schema.compatibility":"NONE",
      "tasks.max":10,
      "topics":"subscriptions_ibm",
      "format.class":"io.confluent.connect.s3.format.json.JsonFormat",
      "storage.class":"io.confluent.connect.s3.storage.S3Storage",
      "s3.bucket.name":"kp-hftestingbucket",
      "topics.dir":"ibm_demo",
      "key.converter":"org.apache.kafka.connect.storage.StringConverter",
      "value.converter":"org.apache.kafka.connect.json.JsonConverter",
      "value.converter.schemas.enable": "false",
      "partitioner.class":"io.confluent.connect.storage.partitioner.TimeBasedPartitioner",
      "partition.duration.ms":3600000,
      "rotate.schedule.interval.ms":900000,
      "flush.size":10,
      "path.format":"'\'year\''=YYYY/'\'month\''=MM/'\'day\''=dd/'\'hour\''=HH",
      "locale": "US",
      "timezone": "UTC",
      "timestamp.extractor": "Wallclock"
    }
}
'