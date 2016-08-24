#!/bin/bash
set -e

echo "# This file is a template, and might need editing before it works on your project.\n# Full project: https://gitlab.com/pages/plain-html\npages:\n  stage: deploy\n  script:\n  - mkdir .public\n  - cp -r * .public\n  - mv .public public\n  artifacts:\n    paths:\n    - public\n  only:\n  - master" > ~/peterychuang.github.io/public/.gitlab-ci.yml
echo "# [Peter Y. Chuang - Novelist](https://novelist.xyz)\n\nThis is the repository for the compiled HTML and static files of my website.\n\nFor the source of the website, please visit the [source branch](https://github.com/peterychuang/peterychuang.github.io/tree/source)." > ~/peterychuang.github.io/public/readme.md
REV=$(git rev-parse HEAD)
mkdir ~/tmp
eval `ssh-agent -s`
ssh-add ~/.ssh/id_gitlab.com
git config --global user.email "peteryuchuang@gmail.com"
git config --global user.name "Peter Y. Chuang"
git clone --branch master git@gitlab.com:peterychuang/peterychuang.gitlab.io.git ~/tmp/public
rsync -rt --delete --exclude=".git" ~/peterychuang.github.io/public ~/tmp
cd ~/tmp/public
git add .
git commit --allow-empty -m "Built from commit $REV"
git push
