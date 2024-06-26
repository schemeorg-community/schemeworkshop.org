#!/bin/sh
set -eu
cd "$(dirname "$0")"
cd ..
set -x
# Do not use --delete because papers are uploaded from another repository.
rsync -vcr --exclude="*~" www/ tuonela.scheme.org:/production/workshop/www/
