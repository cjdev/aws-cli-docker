#!/bin/bash

set -e

: ${CLUSTER_NAME:?}
: ${SERVICE_NAME:?}
: ${TASK_DEFINITION_NAME:?}

TASK_DEFINITION_FILE=$(mktemp)

aws ecs describe-task-definition \
  --task-definition "$TASK_DEFINITION_NAME" \
  --query 'taskDefinition.{containerDefinitions:containerDefinitions,volumes:volumes}' \
  > "$TASK_DEFINITION_FILE"

REVISION=$( \
  aws ecs register-task-definition \
    --family "$TASK_DEFINITION_NAME" \
    --cli-input-json "file://$TASK_DEFINITION_FILE" \
    --query 'taskDefinition.revision')

aws ecs update-service \
  --cluster "$CLUSTER_NAME" \
  --service "$SERVICE_NAME" \
  --task-definition "$TASK_DEFINITION_NAME:$REVISION"
