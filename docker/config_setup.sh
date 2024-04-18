#!/bin/bash

# Setup configuration properties
KAFKA_DIR="/app/kafka"
SERVER_PROPERTIES_DIR=$KAFKA_DIR/server.properties
KAFKA_BIN_DIR="${KAFKA_DIR}/bin"
DEFAULT_MIN_INSYNC_REPLICAS="${DEFAULT_MIN_INSYNC_REPLICAS:-2}"
PROCESS_ROLES="${PROCESS_ROLES:-broker,controller}"
NUM_NETWORK_THREADS="${NUM_NETWORK_THREADS:-2}"
NUM_IO_THREADS="${NUM_IO_THREADS:-4}"
SOCKET_SEND_BUFFER_BYTES="${SOCKET_SEND_BUFFER_BYTES:-102400}"
SOCKET_RECEIVE_BUFFER_BYTES="${SOCKET_RECEIVE_BUFFER_BYTES:-102400}"
SOCKET_REQUEST_MAX_BYTES="${SOCKET_REQUEST_MAX_BYTES:-104857600}"
NUM_PARTITIONS="${NUM_PARTITIONS:-1}"
NUM_RECOVERY_THREADS_PER_DATA_DIR="${NUM_RECOVERY_THREADS_PER_DATA_DIR:-1}"
OFFSETS_TOPIC_REPLICATION_FACTOR="${OFFSETS_TOPIC_REPLICATION_FACTOR:-3}"
TRANSACTION_STATE_LOG_REPLICATION_FACTOR="${TRANSACTION_STATE_LOG_REPLICATION_FACTOR:-3}"
TRANSACTION_STATE_LOG_MIN_ISR="${TRANSACTION_STATE_LOG_MIN_ISR:-3}"
DEFAULT_REPLICATION_FACTOR="${DEFAULT_REPLICATION_FACTOR:-3}"
LOG_RETENTION_HOURS="${LOG_RETENTION_HOURS:-24}"
LOG_RETENTION_BYTES="${LOG_RETENTION_BYTES:-4294967296}"
LOG_SEGMENT_BYTES="${LOG_SEGMENT_BYTES:-1073741824}"
LOG_RETENTION_CHECK_INTERVAL_MS="${LOG_RETENTION_CHECK_INTERVAL_MS:-60000}"
STORAGE_DIR="${STORAGE_DIR:-/mtn}"
NODE_ID=${NODE_ID:-${HOSTNAME:6}}
LOG_DIRS=$STORAGE_DIR/$NODE_ID
CLUSTER_ID="${CLUSTER_ID:-oh-sxaDRTcyAr6pFRbXyzA}"
REPLICAS="${REPLICAS:-1}"
NODE_HOSTNAME_PREFIX="${NODE_HOSTNAME_PREFIX:-broker-}"
NODE_HOSTNAME_SUFFIX="${NODE_HOSTNAME_SUFFIX:-}"
NODE_CONTROLLER_PORT="${NODE_PORT:-19092}"
INTER_BROKER_LISTENER_NAME="${INTER_BROKER_LISTENER_NAME:-BROKER_LISTENER}"
CONTROLLER_LISTENER_NAMES="${CONTROLLER_LISTENER_NAMES:-CONTROLLER}"
LISTENERS="${LISTENERS:-CONTROLLER://:$NODE_CONTROLLER_PORT,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093}"
ADVERTISED_LISTENERS="${ADVERTISED_LISTENERS:-BROKER_LISTENER://$NODE_HOSTNAME_PREFIX$NODE_ID$NODE_HOSTNAME_SUFFIX:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093}"
LISTENER_SECURITY_PROTOCOL_MAP="${LISTENER_SECURITY_PROTOCOL_MAP:-CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT}"

CONTROLLER_QUORUM_VOTERS=""
for i in $(seq 0 $((REPLICAS - 1))); do
    CONTROLLER_QUORUM_VOTERS+="$i@$NODE_HOSTNAME_PREFIX$i$NODE_HOSTNAME_SUFFIX:$NODE_CONTROLLER_PORT,"
done
CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}

# Function to update Kafka configuration
update_kafka_configuration() {
    sed -i \
    -e "s+^controller.quorum.voters=.*+controller.quorum.voters=$CONTROLLER_QUORUM_VOTERS+" \
    -e "s+^process.roles=.*+process.roles=$PROCESS_ROLES+" \
    -e "s+^num.network.threads=.*+num.network.threads=$NUM_NETWORK_THREADS+" \
    -e "s+^num.io.threads=.*+num.io.threads=$NUM_IO_THREADS+" \
    -e "s+^socket.send.buffer.bytes=.*+socket.send.buffer.bytes=$SOCKET_SEND_BUFFER_BYTES+" \
    -e "s+^socket.receive.buffer.bytes=.*+socket.receive.buffer.bytes=$SOCKET_RECEIVE_BUFFER_BYTES+" \
    -e "s+^socket.request.max.bytes=.*+socket.request.max.bytes=$SOCKET_REQUEST_MAX_BYTES+" \
    -e "s+^log.retention.hours=.*+log.retention.hours=$LOG_RETENTION_HOURS+" \
    -e "s+^log.retention.bytes=.*+log.retention.bytes=$LOG_RETENTION_BYTES+" \
    -e "s+^log.segment.bytes=.*+log.segment.bytes=$LOG_SEGMENT_BYTES+" \
    -e "s+^log.retention.check.interval.ms=.*+log.retention.check.interval.ms=$LOG_RETENTION_CHECK_INTERVAL_MS+" \
    -e "s+^node.id=.*+node.id=$NODE_ID+" \
    -e "s+^log.dirs=.*+log.dirs=$LOG_DIRS+" \
    -e "s+^listeners=.*+listeners=$LISTENERS+" \
    -e "s+^min.insync.replicas=.*+min.insync.replicas=$DEFAULT_MIN_INSYNC_REPLICAS+" \
    -e "s+^advertised.listeners=.*+advertised.listeners=$ADVERTISED_LISTENERS+" \
    -e "s+^listener.security.protocol.map=.*+listener.security.protocol.map=$LISTENER_SECURITY_PROTOCOL_MAP+" \
    -e "s+^inter.broker.listener.name=.*+inter.broker.listener.name=$INTER_BROKER_LISTENER_NAME+" \
    -e "s+^controller.listener.names=.*+controller.listener.names=$CONTROLLER_LISTENER_NAMES+" \
    -e "s+^default.replication.factor=.*+$DEFAULT_REPLICATION_FACTOR+" \
    $SERVER_PROPERTIES_DIR
}
