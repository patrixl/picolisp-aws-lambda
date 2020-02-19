#!/usr/bin/env bash

mkdir -p /build/pil/bin /build/pil/lib/
cp -a /picoLisp/bin/* /build/pil/bin/
cp -a /picoLisp/lib/* /build/pil/lib/
cp -a /picoLisp/*.l /build/pil/
cp -a /picoLisp/COPYING /build/pil/
