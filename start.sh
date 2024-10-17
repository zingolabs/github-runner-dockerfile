#!/bin/bash


# Fail-proof check for missing variables
if [ -z "$REPO" ]; then
  echo "Error: REPO environment variable is not set."
  exit 1
fi

# Get GH_TOKEN from Docker secrets
ACCESS_TOKEN=$(cat /run/secrets/GH_TOKEN)
if [ -z "$ACCESS_TOKEN" ]; then
  echo "Error: GH_TOKEN secret is not accessible."
  exit 1
fi

REPOSITORY=$REPO

echo "REPO ${REPOSITORY}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

./config.sh --url https://github.com/${REPOSITORY} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
