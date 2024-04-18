bootstrap_servers = "kafka-0.kafka-svc.kafka.svc.cluster.local:19093,kafka-1.kafka-svc.kafka.svc.cluster.local:19093,kafka-2.kafka-svc.kafka.svc.cluster.local:19093"
topic = "topic_name"
replication_factor = 3
partitions = 1
consumers_group = 'consumer_group_name'

kafka_commands = {
    "Describe topic": f"./kafka-topics.sh --describe --topic {topic} --bootstrap-server {bootstrap_servers}",
    "Create topic": f"./kafka-topics.sh --bootstrap-server {bootstrap_servers} --create --replication-factor {replication_factor} --partitions {partitions} --topic {topic}",
    "List topics": f"./kafka-topics.sh --bootstrap-server {bootstrap_servers} --list",
    "Delete topic": f"./kafka-topics.sh --bootstrap-server {bootstrap_servers} --delete --topic {topic}",
    "Producer": f"./kafka-console-producer.sh --topic {topic} --broker-list {bootstrap_servers}",
    "Consumer": f"./kafka-console-consumer.sh --topic {topic} --bootstrap-server {bootstrap_servers} --group {consumers_group} --from-beginning",
    "Broker API": f"./kafka-broker-api-versions.sh --bootstrap-server {bootstrap_servers}"
}

for c in kafka_commands:
    print(c)
    print(kafka_commands[c])
