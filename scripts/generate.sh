#!/bin/sh
set -eu
exec gosh "$(dirname "$0")/generate.scm" "$@"
