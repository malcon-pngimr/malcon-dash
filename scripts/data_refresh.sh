#!/usr/bin/env bash

# Rscript -e "source('./scripts/data_refresh.R')"
# rm -r docs
if [[ ! -e docs ]]; then
    mkdir docs
elif [[ ! -d docs ]]; then
    echo "docs already exists but is not a directory" 1>&2
fi

# Rscript -e "rmarkdown::render_site()"


if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name 'myominnoo'
    git config --global user.email 'dr.myominnoo@gmail.com'
    git add -A
    git commit -m "Auto pull of the HFS data on $(date)"
    git push origin 
else
    echo "Nothing to commit..."
fi