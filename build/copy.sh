#!/usr/bin/env bash

mkdir -p /build/pil/bin /build/pil/lib
cp -Ra /picoLisp/bin/* /build/pil/bin
cp -Ra /picoLisp/lib/* /build/pil/lib
cp -Ra /picoLisp/*.l /build/pil
