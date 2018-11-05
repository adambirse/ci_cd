#!/usr/bin/env bash

rm -rf build/ci_cd-0.0.1-SNAPSHOT.jar
cp ../build/libs/ci_cd-0.0.1-SNAPSHOT.jar ./build_context
cd build_context
docker build -t "ci_cd" .
