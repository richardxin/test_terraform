#!/bin/bash

LATEST_RELEASE=$(curl https://api.github.com/repos/hashicorp/terraform/releases/latest | jq --raw-output '.tag_name' | cut -c 2-)
if [[ ! -e ${LATEST_RELEASE} ]]; then
   echo "Installing Terraform ${LATEST_RELEASE}..."
   # rm terraform-*
   # rm terraform
   wget https://releases.hashicorp.com/terraform/${LATEST_RELEASE}/terraform_${LATEST_RELEASE}_linux_amd64.zip
   unzip terraform_${LATEST_RELEASE}_linux_amd64.zip
   rm terraform_${LATEST_RELEASE}_linux_amd64.zip
   touch ${LATEST_RELEASE}
else
   echo "Latest Terraform already installed."
fi
