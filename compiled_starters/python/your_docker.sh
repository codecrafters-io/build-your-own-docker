#!/bin/sh
PYTHONPATH=$(dirname $0) exec python3 -m app.main "$@"
