#!/bin/sh
#
# DON'T EDIT THIS!
#
# CodeCrafters uses this file to test your code. Don't make any changes here!
#
# DON'T EDIT THIS!
set -e

ls -alh

mvn -B --quiet package -Ddir=/tmp/codecrafters-docker-target
exec java -jar /tmp/codecrafters-docker-target/java_docker.jar "$@"