#!/bin/bash
set -e

# --- 1. 現在のディレクトリが git リポジトリか確認 ---
if [ ! -d ".git" ]; then
  echo "エラー: このディレクトリは git リポジトリではありません。"
  exit 1
fi

# --- 2. リモート 'origin' の存在確認 ---
if ! git remote | grep -q '^origin$'; then
  echo "エラー: リモート 'origin' が設定されていません。"
  exit 1
fi

# --- 3. gh-pages ブランチが存在しなければ作成 ---
if ! git show-ref --quiet refs/heads/gh-pages; then
  echo "gh-pages ブランチが存在しないので作成します..."
  # 現在のブランチ（たとえば main）から orphan ブランチ gh-pages を作成
  git checkout --orphan gh-pages
  # すべてのファイルを削除（※新規に gh-pages の内容を作るため）
  git rm -rf .
  # 仮の index.html を作成
  cat <<EOF > index.html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>GitHub Pages 初期設定</title>
</head>
<body>
  <h1>GitHub Pages の初期設定です</h1>
  <p>このページは初回デプロイ時に自動生成されました。</p>
</body>
</html>
EOF
  git add index.html
  git commit -m "Initial gh-pages commit"
  git push origin gh-pages
  # 元のブランチに戻る（ここでは main ブランチと仮定）
  git checkout -
fi

# --- 4. 現在のディレクトリの内容を gh-pages ブランチへデプロイ ---
# ここでは git subtree を使ってルート（"."）の内容を push します。
echo "GitHub Pages へデプロイします..."
git subtree push --prefix . origin gh-pages

echo "GitHub Pages へのデプロイが完了しました。"
