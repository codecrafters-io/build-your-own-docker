#!/bin/sh
#
set -e
tmpFile=$(mktemp)
go build -o "$tmpFile" app/*.go
exec "$tmpFile" "$@"
