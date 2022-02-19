#!/bin/bash

git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git diff
git add -A
git commit -m "exe: code executed" -a
