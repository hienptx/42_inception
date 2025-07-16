#!/bin/bash

set -e

echo "Checking NGINX configuration.."
/ursr/local/bin/check-config.sh

echo "Starting NGINX"
exec nginx -g "daemon off;"