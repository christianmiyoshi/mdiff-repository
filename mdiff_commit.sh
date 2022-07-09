#!/bin/bash

repository=$1
commit=$2

cd $repository

branchName=delete/test-${RANDOM}
echo "BranchName=$branchName"
`git checkout -b $branchName`

clean_up() {
    echo "Clean up"
    git reset --hard master
    echo "Reset to master"
    git checkout master
    echo "Checkout master"
    git branch --delete $branchName
    echo "End"
}
trap clean_up EXIT

echo "CurrentCommit=$commit"

parentsString=`git log --pretty=format:'%P' -n 1 $commit`

parents=($parentsString)
echo "Parent 0=${parents[0]}"
echo "Parent 1=${parents[1]}"

`git reset --hard ${parents[0]}`
`git merge ${parents[1]} --no-ff --no-commit`
git mergetool
git commit -m "temp" --no-gpg-sign

currentCommit=`git log --pretty=format:'%h' -n 1`
echo "TemporaryCommit=$parentsString"

echo "Calculate diff"
`git difftool ${currentCommit} ${commit}`
echo "Diff ended"
