#!/bin/bash
# check_git_user.sh
# Git のグローバルおよびローカルのユーザー情報を確認するスクリプト

echo "----- Git Global User Information -----"
echo "User Name : $(git config --global user.name)"
echo "User Email: $(git config --global user.email)"
echo ""

# ローカルリポジトリ内にいる場合のみ表示
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "----- Git Local User Information -----"
  # ローカル設定がない場合は空文字が返るので注意
  echo "User Name : $(git config --local user.name)"
  echo "User Email: $(git config --local user.email)"
  echo ""
else
  echo "※ このディレクトリは Git リポジトリではありません。"
fi

echo "----- All User-Related Git Settings -----"
git config --list | grep -i "^user\."
