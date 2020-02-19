#!/usr/bin/env bash

echo -n "Creating temp directory... "
home=$PWD
echo $home
dir=$(mktemp --directory)
echo $dir

echo "Building..."
docker build -t picolisp-aws-lambda ./build && \
	docker run --rm -it -v $dir/build:/build picolisp-aws-lambda && \
	cp -a src/bootstrap $dir && \
	sudo mv $dir/build/pil $dir/ && \
	cd $dir && \
        git clone --depth 1 https://github.com/aw/picolisp-json && \
        git clone --depth 1 https://github.com/aw/picolisp-awscurl && \
        sudo cp picolisp-json/json.l picolisp-awscurl/libawscurl.l pil/ && \
	zip -r picolisp.zip pil bootstrap && \
	cd - && \
	mv $dir/picolisp.zip .

echo "Cleaning up..."
sudo rm -rf $dir

echo "Done!"
