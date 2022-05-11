FROM confluentinc/cp-kafka-connect:7.0.0
# java debugging
ENV JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,address=*:5005,server=y,suspend=n
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-rabbitmq:latest && confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.0.3


