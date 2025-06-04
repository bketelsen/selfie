#!/bin/bash

export TF_STATE_NAME=default
tofu init \
  -backend-config="address=https://git.ketelsen.cloud/api/v4/projects/1/terraform/state/$TF_STATE_NAME" \
  -backend-config="lock_address=https://git.ketelsen.cloud/api/v4/projects/1/terraform/state/$TF_STATE_NAME/lock" \
  -backend-config="unlock_address=https://git.ketelsen.cloud/api/v4/projects/1/terraform/state/$TF_STATE_NAME/lock" \
  -backend-config="username=bjk" \
  -backend-config="password=$GITLAB_ACCESS_TOKEN" \
  -backend-config="lock_method=POST" \
  -backend-config="unlock_method=DELETE" \
  -backend-config="retry_wait_min=5"
