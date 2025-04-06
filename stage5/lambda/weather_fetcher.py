import os
import requests
import boto3
import json
from datetime import datetime
from botocore.exceptions import ClientError

def get_api_key(secret_name):
    client = boto3.client('secretsmanager')
    try:
        response = client.get_secret_value(SecretId=secret_name)
        secret = json.loads(response['SecretString'])
        return secret['api_key']
    except ClientError as e:
        raise Exception(f"Unable to retrieve secret: {e}")

def lambda_handler(event, context):
    city = os.environ['CITY']
    s3_bucket = os.environ['S3_BUCKET']
    secret_name = os.environ['SECRET_NAME']

    try:
        api_key = get_api_key(secret_name)

        url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()

        filename = f"{city}_{datetime.utcnow().isoformat()}.json"
        s3 = boto3.client('s3')
        s3.put_object(Bucket=s3_bucket, Key=filename, Body=json.dumps(data))

        return {"status": "success", "file": filename}
    except Exception as e:
        return {"status": "error", "message": str(e)}
