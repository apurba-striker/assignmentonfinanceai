#!/bin/bash

set -e

rm -rf package lambda.zip
mkdir -p package

pip install -r requirements.txt -t package

cp weather_fetcher.py package/

cd package
zip -r ../lambda.zip .
cd ..

echo " Lambda package built: lambda.zip"
