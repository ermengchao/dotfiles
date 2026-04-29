#!/bin/sh

umask "${UMASK:-022}"

if [ -f /app/config/bangumi.json ]; then
  mv /app/config/bangumi.json /app/data/bangumi.json
fi

exec python main.py
