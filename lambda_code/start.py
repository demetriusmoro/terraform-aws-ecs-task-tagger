import json
import sys
import traceback
from datetime import datetime

import boto3
from botocore.config import Config


def lambda_handler(event, context):
    http_code = 200
    message = "Success"

    # noinspection PyBroadException
    try:
        writelog("*** BEGIN")
        run(event)
    except Exception as err:
        writelog("*** ERROR")
        print(f"Message: {str(err)}")
        traceback.print_exception(*sys.exc_info())

        http_code = 500
        message = "Internal error"
    finally:
        writelog("*** END")
        json_response(http_code, message)


def run(event):
    # gather required info
    cluster_name = get_cluster_name(event["detail"]["clusterArn"])
    task_arn = event["detail"]["taskArn"]
    taskdef_arn = event["detail"]["taskDefinitionArn"]

    # log info gathered
    writelog(f"cluster_name: {cluster_name}")
    writelog(f"task_arn: {task_arn}")
    writelog(f"taskdef_arn: {taskdef_arn}")

    # update tags only if there are new ones
    result = update_tags(cluster_name, task_arn, taskdef_arn)
    writelog(f"result: {result}")


def get_cluster_name(cluster_arn):
    client = get_client("ecs")
    return client.describe_clusters(
        clusters=[cluster_arn],
        include=[]
    )["clusters"][0]["clusterName"]


def update_tags(cluster_name, task_arn, taskdef_arn):
    task_tags = get_task_tags(cluster_name, task_arn)
    taskdef_tags = get_taskdef_tags(taskdef_arn)
    tags_final = [
        {
            "key": k,
            "value": taskdef_tags[k]
        }
        for k in taskdef_tags
        if (
            (k not in task_tags) and
            (not k.startswith("aws"))
        )]

    if len(tags_final) == 0:
        return "[SUCCESS] Task already tagged, nothing to do."

    client = get_client("ecs")
    client.tag_resource(
        resourceArn=task_arn,
        tags=tags_final)

    return "[SUCCESS] Task tags updated."


def get_task_tags(cluster_name, task_arn):
    client = get_client("ecs")
    query = client.describe_tasks(
        cluster=cluster_name,
        tasks=[task_arn],
        include=["TAGS"])["tasks"]

    result = {}
    if (
            (query is None) or
            (len(query) != 1) or
            ("tags" not in query[0]) or
            (query[0]["tags"] is None)
    ):
        return result

    for tag in query[0]["tags"]:
        result[tag["key"]] = tag["value"]

    return result


def get_taskdef_tags(taskdef_arn):
    client = get_client("ecs")
    query = client.describe_task_definition(
        taskDefinition=taskdef_arn,
        include=["TAGS"])["tags"]

    result = {}
    if query is None:
        return result

    for tag in query:
        result[tag["key"]] = tag["value"]

    return result


def get_client(service, region="us-east-1"):
    config = Config(retries={
        "max_attempts": 10,
        "mode": "standard",
    })

    return boto3.client(
        service_name=service,
        region_name=region,
        config=config)


def writelog(text):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {text}")


def success(result):
    return json_response(200, result)


def json_response(code, result):
    return {
        "statusCode": code,
        "isBase64Encoded": False,
        "headers": {"Content-Type": "text/json"},
        "body": json.dumps({"result": result})
    }
