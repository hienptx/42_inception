#!/bin/bash

set -e

echo "Checking NGINX configuration.."
/usr/local/bin/check-config.sh

echo "Starting NGINX"
exec nginx -g "daemon off;"