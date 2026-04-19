#!/bin/sh
orb -m experiment sudo podman exec elk-stack-kafka sh -lc "echo '{\"message\":\"hello from demo\",\"source\":\"vhs-demo\"}' | /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic logs"
