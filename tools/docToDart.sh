#!/bin/bash

sed -i -e 's/^/"/g' $1
sed -i -e 's/$/\\n"/g' $1
sed -i -e '$ s/\\n//g' $1

cat $1
