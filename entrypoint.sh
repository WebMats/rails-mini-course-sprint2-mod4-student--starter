#!/bin/bash
set -e

rm -f /usr/app/tmp/pids/server.pid

exec "$@"