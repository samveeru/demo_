#!/bin/bash

if [ -d $1/$7 ]
then
  user_score=0
  user_score=`expr $user_score + 1`
  [ -f $1/$2 ] && user_score=`expr $user_score + 1`
  [ -f $1/$3 ] && user_score=`expr $user_score + 1`
  if [ $user_score -eq 3 ]
  then
    echo 'Preliminary local directory checks in local repository... Pass'
  else
    echo 'Preliminary local directory checks in local repository... Fail'
  fi
  cd $1
  [ `eval git branch -r | wc -l` -eq 2 ] && echo 'Branch check... Pass' || echo 'Branch check... Fail'
  git checkout master > /dev/null 2>&1
  [ `eval git log --pretty="oneline" | wc -l` -eq 1 ] && echo 'Commits check on master... Pass' || echo 'Commits check on master... Fail'
  git checkout new_branch > /dev/null 2>&1
  [ `eval git log --pretty="oneline" | wc -l` -eq 2 ] && echo 'Commits check on new_branch... Pass' || echo 'Commits check on new_branch... Fail'
  new_branch_commit_hash=`eval git rev-parse HEAD`
  git checkout print_stack > /dev/null 2>&1
  [ `eval git log --pretty="oneline" | wc -l` -eq 2 ] && echo 'Commits check on print_stack... Pass' || echo 'Commits check on print_stack... Fail'
  print_stack_commit_hash=`eval git rev-parse HEAD`
  [ `eval cat .git/logs/HEAD | grep 'cherry-pick' | wc -l` -ge 1 ] && echo 'Cherrypick command usage check... Pass' || echo 'Cherrypick command usage check... Fail'
  [ $new_branch_commit_hash != $print_stack_commit_hash ] && echo 'Branch commit check... Pass' || echo 'Branch commit check... Fail'
  git checkout master > /dev/null 2>&1
  cd ..

  if [ -d $4/$5 ]
  then
    user_score=0
    user_score=`expr $user_score + 1`
    cd $4
    git clone remote $6 > /dev/null 2>&1
    [ -f $6/$2 ] && user_score=`expr $user_score + 1`
    [ -f $6/$3 ] && user_score=`expr $user_score + 1`
    if [ $user_score -eq 3 ]
    then
      echo 'Preliminary remote directory checks in local repository... Pass'
    else
      echo 'Preliminary remote directory checks in local repository... Fail'
    fi
    cd $6
    [ `eval git branch -r | wc -l` -eq 3 ] && echo 'Branch check... Pass' || echo 'Branch check... Fail'
    git checkout master > /dev/null 2>&1
    [ `eval git log --pretty="oneline" | wc -l` -eq 1 ] && echo 'Commits check on master... Pass' || echo 'Commits check on master... Fail'
    git checkout new_branch > /dev/null 2>&1
    [ `eval git log --pretty="oneline" | wc -l` -eq 2 ] && echo 'Commits check on new_branch... Pass' || echo 'Commits check on new_branch... Fail'
    [ `eval git branch -r | grep 'print_stack' | wc -l` -eq 0 ] && echo 'print_stack branch check... Pass' || echo 'print_stack branch check... Fail'
    cd ../..
    rm -rf $4/$6
  else
    echo 'No remote directory found...'
  fi
else
  echo 'No git found in the local directory'
fi
