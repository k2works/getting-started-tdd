#!/usr/bin/env bash
# Elixir 向け簡易循環複雑度チェックスクリプト
# 使い方: bash scripts/complexity.sh --threshold <N> <dir>
set -euo pipefail

THRESHOLD=10
TARGET_DIR="lib"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --threshold)
      THRESHOLD="$2"
      shift 2
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

failed=0

while IFS= read -r -d '' file; do
  # 分岐ポイントをカウント: if, unless, case, cond, when, &&, ||, and, or
  branches=$(grep -cE '\bif\b|\bunless\b|\bcase\b|\bcond\b|\bwhen\b|&&|\|\||\ and\ |\ or\ ' "$file" 2>/dev/null || true)
  complexity=$((1 + branches))

  if [[ $complexity -gt $THRESHOLD ]]; then
    echo "FAIL: $file (complexity=$complexity, threshold=$THRESHOLD)"
    failed=1
  else
    echo "OK:   $file (complexity=$complexity)"
  fi
done < <(find "$TARGET_DIR" -name "*.ex" -print0 2>/dev/null)

if [[ $failed -eq 1 ]]; then
  echo ""
  echo "Complexity check failed: some files exceed threshold $THRESHOLD"
  exit 1
else
  echo ""
  echo "Complexity check passed (threshold=$THRESHOLD)"
fi
