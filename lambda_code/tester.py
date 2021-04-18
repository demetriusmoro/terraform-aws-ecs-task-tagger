import json

import start

event_text = """
{
  "detail": {
    "clusterArn": "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster-name",
    "lastStatus": "RUNNING",
    "taskArn": "arn:aws:ecs:us-east-1:123456789012:task/my-cluster-name/a8cc6a9c50ac4d92acf5ce35c12758a3",
    "taskDefinitionArn": "arn:aws:ecs:us-east-1:123456789012:task-definition/taskdef-name:1"
  }
}
"""

def run():
    start.lambda_handler(
        json.loads(event_text),
        None)


if __name__ == '__main__':
    run()
