#!/bin/sh
orb -m experiment sudo podman exec elk-stack-elasticsearch sh -lc "curl -sS 'http://localhost:9200/logs-*/_search?q=source:vhs-demo&pretty'"
