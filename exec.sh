#!/bin/bash

set -e


# just a secure touch if those files doesn't exist
touch ./langVersion ./code ./stdin

lv="$(cat ./langVersion)"
langVersion=(${lv//=/ })
lang=${langVersion[0]}
version=${langVersion[1]}

code=$(awk -v ORS='\\n' '1' ./code | rev | cut -c3- | rev)
stdin=$(awk -v ORS='\\n' '1' ./stdin | rev | cut -c3- | rev)

curl -s -L -X POST "http://147.182.205.116:4321/api/v1/execute" \
-H "Content-Type: application/json" -d '{
    "name": "test",
    "lang": "'$lang'",
    "version": "'$version'",
    "code": "'$(echo $code)'",
    "stdin": "'$(echo $stdin)'"
}' | jq '. | {out: .run.stdout, err: .run.stderr}' | \
jq -r '[.out, .err] | @tsv' | \
while IFS=$'\t' read -r out err; do
    echo "-----------"
    echo $out > ./out
    echo $err > ./err
    echo "-----------"
done

