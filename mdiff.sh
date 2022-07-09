#!/bin/bash

repository=$1
cd $repository

mergesString=`git log --merges --pretty=format:'%h'` #-n 5`
merges=($mergesString)

cd -

for merge in "${merges[@]}"
do
   bash mdiff_commit.sh "$repository" "$merge"
done

exit 0