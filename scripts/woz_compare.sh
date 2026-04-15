#!/bin/bash
# woz_compare.sh - Wrapper script for Woz to compare code implementations
# Usage: ./scripts/woz_compare.sh "code_a" "code_b" "criteria"

BASE_URL="${ACTIVEGENIE_URL:-http://localhost:4567}"

CODE_A="$1"
CODE_B="$2"
CRITERIA="${3:-readability, performance, maintainability}"

curl -X POST "$BASE_URL/api/v1/compare" \
  -H 'Content-Type: application/json' \
  -d "{
    \"player_a\": \"$CODE_A\",
    \"player_b\": \"$CODE_B\",
    \"criteria\": \"$CRITERIA\"
  }"
