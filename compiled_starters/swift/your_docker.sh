#!/bin/bash
set -e
set -o pipefail

# Swift build writes errors to stdout instead of stderr. Let's collect all output in a file and only print if the exit code is zero.
buildOutputFile=$(mktemp)
swift build -c release > "$buildOutputFile" || (cat "$buildOutputFile" && exit 1)
exec swift run -c release --skip-build swift-docker-challenge "$@"
