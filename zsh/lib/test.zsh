#!/bin/zsh

function test_case() {
  echo "===\n$1:"
  if "$1"; then
    echo "PASS"
  else
    echo "FAILURE"
    exit 1
  fi
}

function fail() { echo "Fail: $1" >&2; exit 1 }

echo "Starting test..."
