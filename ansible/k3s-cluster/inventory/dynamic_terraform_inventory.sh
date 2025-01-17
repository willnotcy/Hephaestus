#!/bin/bash

# Ensure the state file path is provided as an argument, or use a default path
STATE_FILE="/root/Hephaestus/terraform/terraform.tfstate"

# Run Terraform output -json with the specified state file to get the Terraform output
INPUT_JSON=$(terraform output -json -state=$STATE_FILE)

# Extract VM details using jq
masters=$(echo "$INPUT_JSON" | jq -r '.vm_info.value[] | select(.vm_name | contains("master")) | .ip_address')
workers=$(echo "$INPUT_JSON" | jq -r '.vm_info.value[] | select(.vm_name | contains("worker")) | .ip_address')

# Check if masters and workers are empty and handle accordingly
if [ -z "$masters" ] || [ -z "$workers" ]; then
  echo "Error: Failed to retrieve IP addresses for masters or workers."
  exit 1
fi

# Function to create a properly formatted JSON array for hosts
generate_hosts() {
  local host_list=$1
  local formatted_hosts=()

  # Loop through each IP and add it to the array
  for ip in $host_list; do
    formatted_hosts+=("\"$ip\"")
  done

  # Join array into a comma-separated string and return
  echo "${formatted_hosts[@]}" | tr ' ' ','
}

# Create JSON output for Ansible dynamic inventory
cat <<EOF
{
  "all": {
    "hosts": [
      $(generate_hosts "$masters"),
      $(generate_hosts "$workers")
    ],
    "vars": {
      "ansible_user": "ubuntu"
    }
  },
  "master": {
    "hosts": [
      $(generate_hosts "$masters")
    ],
    "vars": {
      "ip_pool_first": "192.168.0.241",
      "ip_pool_last": "192.168.0.255"
    }
  },
  "worker": {
    "hosts": [
      $(generate_hosts "$workers")
    ]
  },
  "k3s_cluster": {
    "children": [
      "master",
      "worker"
    ]
  }
}
EOF
