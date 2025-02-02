#!/bin/bash
set -e

# 正しいリモート URL を設定（適宜変更してください）
CORRECT_REMOTE_URL="git@github.com:Aid-On/reporting-page-by-working-days.git"

# 現在のリモート URL を取得
CURRENT_REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

echo "現在の origin の URL: $CURRENT_REMOTE_URL"

if [ "$CURRENT_REMOTE_URL" != "$CORRECT_REMOTE_URL" ]; then
  echo "リモート URL を修正します..."
  # origin がすでに存在する場合は削除
  if [ -n "$CURRENT_REMOTE_URL" ]; then
    git remote remove origin
  fi
  git remote add origin "$CORRECT_REMOTE_URL"
  echo "新しい origin の URL: $(git remote get-url origin)"
else
  echo "origin の URL は正しいので変更不要です。"
fi

# なお、リモートにアクセスできるかテストする
echo "リモートリポジトリにアクセステスト中..."
git ls-remote origin || {
  echo "エラー: リモートリポジトリにアクセスできません。正しいアクセス権とリポジトリが存在するか確認してください。"
  exit 1
}

echo "リモートリポジトリに正しくアクセスできました。"
