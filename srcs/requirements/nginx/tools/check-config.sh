#!/bin/bash

echo "Checking NGINX configuration.."

nginx -t

if [ $? -ne 0 ]; then
    echo "NGINX configuration check failed."
    exit 1
fi

echo "NGINX configuration is valid."