#!/bin/bash
# https://www.terraform.io/docs/providers/external/data_source.html

# Exit if any of the intermediate steps fail
set -e

# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "NAME=\(.name)"')"


# Placeholder for whatever data-fetching logic your script implements
POD_NAME=$(kubectl --namespace drone describe po ${NAME} | grep -e '^Name:' | cut -d':' -f2 | sed -e 's/ //g')

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg pod_name "$POD_NAME" '{"pod_name":$pod_name}'
