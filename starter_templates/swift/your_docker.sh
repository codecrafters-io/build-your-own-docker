#!/bin/sh
#
# DON'T EDIT THIS!
#
# CodeCrafters uses this file to test your code. Don't make any changes here!
#
# DON'T EDIT THIS!
set -e
swift build -c release > /dev/null
exec swift run -c release --skip-build swift-docker-challenge "$@"
