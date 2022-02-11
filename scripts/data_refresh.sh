#!/usr/bin/env bash

Rscript -e "source('./data_raw/data_refresh.R')" $2


if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name 'myominnoo'
    git config --global user.email 'dr.myominnoo@gmail.com'
    git add -A
    git commit -m "Auto update of the $1 data"
    git push origin $1
else
    echo "Nothing to commit..."
fi