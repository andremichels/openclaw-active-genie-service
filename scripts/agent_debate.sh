#!/bin/bash
# agent_debate.sh - Script for multi-agent debate
# Usage: ./scripts/agent_debate.sh "topic" "agent:position:reasoning" "agent:position:reasoning" ...
# Example: ./scripts/agent_debate.sh "Redis vs Memcached" "woz:Redis:mature ecosystem" "hal:Memcached:simpler"

BASE_URL="${ACTIVEGENIE_URL:-http://localhost:4567}"

TOPIC="$1"
shift

if [ -z "$TOPIC" ] || [ $# -lt 2 ]; then
  echo "Usage: $0 <topic> <agent:position:reasoning> [<agent:position:reasoning>...]"
  exit 1
fi

# Build arguments JSON
ARGUMENTS="["
FIRST=true
for arg in "$@"; do
  IFS=':' read -r agent position reasoning <<< "$arg"
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    ARGUMENTS="$ARGUMENTS,"
  fi
  ARGUMENTS="$ARGUMENTS{\"agent\":\"$agent\",\"position\":\"$position\",\"reasoning\":\"$reasoning\"}"
done
ARGUMENTS="$ARGUMENTS]"

curl -X POST "$BASE_URL/api/v1/debate" \
  -H 'Content-Type: application/json' \
  -d "{\"topic\":\"$TOPIC\",\"arguments\":$ARGUMENTS,\"criteria\":\"quality, feasibility, impact\"}"
