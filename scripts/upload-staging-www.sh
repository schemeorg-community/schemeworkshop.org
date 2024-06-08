#!/bin/sh
set -eu
cd "$(dirname "$0")"
cd ..
set -x
rsync -vcr --exclude="*~" www/ tuonela.scheme.org:/staging/workshop/www/
