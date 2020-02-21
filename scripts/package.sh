#!/usr/bin/env bash

echo -n "Creating temp directory... "
dir=$(mktemp -d)
echo $dir

echo "Building..."
docker build -t picolisp-aws-lambda . && \
	docker run --rm -v $dir:/build picolisp-aws-lambda && \
	cp $dir/picolisp.zip .

echo "Cleaning up..."
rm -rf $dir

echo "Done!"
