#!/bin/sh

set -ex

REPO="github.com/drone/drone"
CGO_ENABLED=0

# compile the server using the cgo
export GOARCH=amd64
export CC=gcc
export CXX=g++
go build -ldflags "-extldflags \"-s -w -static\"" -o release/linux/${GOARCH}/drone-server ${REPO}/cmd/drone-server

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++
go build -ldflags "-extldflags \"-s -w -static\"" -o release/linux/${GOARCH}/drone-server ${REPO}/cmd/drone-server

export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
export CXX=powerpc64le-linux-gnu-g++
go build -ldflags "-extldflags \"-s -w -static\"" -o release/linux/${GOARCH}/drone-server ${REPO}/cmd/drone-server

export GOARCH=mips64le
export CC=mips64el-linux-gnuabi64-gcc
export CXX=mips64el-linux-gnuabi64-g++
go build -ldflags "-extldflags \"-s -w -static\"" -o release/linux/${GOARCH}/drone-server ${REPO}/cmd/drone-server