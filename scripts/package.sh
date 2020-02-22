#!/usr/bin/env bash

echo -n "Creating temp directory... "
dir=$(mktemp -d)
echo $dir

echo "Building..."
docker build --build-arg uid=$UID -t picolisp-aws-lambda . && \
    docker run --rm -v $dir:/build picolisp-aws-lambda && \
    cp ./bootstrap $dir/ && \
    cp ./runtime.l $dir/picoLisp && \
    cd $dir && \
    zip -r picolisp.zip picoLisp/bin picoLisp/lib picoLisp/json picoLisp/awscurl picoLisp/*.l picoLisp/COPYING picoLisp/runtime.l bootstrap && \
    cd - && \
    cp $dir/picolisp.zip .

echo "Cleaning up..."
rm -rf $dir

echo "Done!"
