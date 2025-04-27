#!/bin/bash

HTML_FILE=$1
ENVIRONMENT=$2

if [ -z "$HTML_FILE" ] || [ -z "$ENVIRONMENT" ]; then
  echo "Usage: $0 <html_file> <environment>"
  exit 1
fi

# Replace __ENVIRONMENT__ placeholder with the real environment
sed -i "s|__ENVIRONMENT__|$ENVIRONMENT|g" "$HTML_FILE"
