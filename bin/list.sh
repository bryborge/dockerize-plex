#!/bin/bash

set -euo pipefail

printf "\n"
echo "plex:"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' plex
printf "\n"
