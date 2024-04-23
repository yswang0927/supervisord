#!/bin/bash

if [ x$1 = x"-h" -o x$1 = x"--help" ]; then
    echo "Usage: $0 [ all | win | arm | amd64 ]"
    exit 0
fi

#FLAGS='-tags=release -ldflags="-s -w"' # not work
FLAGS="-tags=release -ldflags -w -ldflags -s"

case $1 in
amd64) go build $FLAGS;;
arm)  CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o supervisord.arm $FLAGS;;
win)  CGO_ENABLED=1 GOARCH= GOOS=windows go build $FLAGS;;
all)
    go build $FLAGS
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o supervisord.arm $FLAGS
    CGO_ENABLED=1 GOARCH= GOOS=windows go build $FLAGS
    ;;
*) go build $FLAGS;;
esac

[ -f supervisord ] && tools/upx supervisord
[ -f supervisord.arm ] && tools/upx supervisord.arm
[ -f supervisord.exe ] && tools/upx supervisord.exe
