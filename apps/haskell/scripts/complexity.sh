#!/usr/bin/env bash
# Haskell 用の循環複雑度チェッカー
# ガード式やcase式の分岐数をカウントして複雑度を近似する

set -euo pipefail

THRESHOLD=10
TARGET_DIR="src"
VIOLATIONS=0
TOTAL_FUNCTIONS=0

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

check_complexity() {
  local file="$1"
  local in_function=""
  local complexity=0
  local line_num=0

  while IFS= read -r line; do
    line_num=$((line_num + 1))

    # トップレベル関数定義の検出（型シグネチャではなく、実装行）
    if echo "$line" | grep -qE '^[a-z][a-zA-Z0-9_]*\s' && ! echo "$line" | grep -qE '^\s' && ! echo "$line" | grep -qE '^(module|import|where|type|data|class|instance|newtype|deriving)'; then
      # 前の関数の結果を出力
      if [[ -n "$in_function" && $complexity -gt 0 ]]; then
        TOTAL_FUNCTIONS=$((TOTAL_FUNCTIONS + 1))
        if [[ $complexity -gt $THRESHOLD ]]; then
          echo "  VIOLATION: $file: $in_function (complexity: $complexity, threshold: $THRESHOLD)"
          VIOLATIONS=$((VIOLATIONS + 1))
        fi
      fi

      # 新しい関数を開始
      in_function=$(echo "$line" | sed 's/\s.*//')
      complexity=1
    fi

    # 分岐の検出
    if echo "$line" | grep -qE '^[[:space:]]*\|[^|]'; then
      complexity=$((complexity + 1))
    fi
    if echo "$line" | grep -qE '\bif\b'; then
      complexity=$((complexity + 1))
    fi
    if echo "$line" | grep -qE '\bcase\b.*\bof\b'; then
      complexity=$((complexity + 1))
    fi
    if echo "$line" | grep -qE '^\s+[A-Z][a-zA-Z0-9_]*\s.*->'; then
      complexity=$((complexity + 1))
    fi

  done < "$file"

  # 最後の関数
  if [[ -n "$in_function" && $complexity -gt 0 ]]; then
    TOTAL_FUNCTIONS=$((TOTAL_FUNCTIONS + 1))
    if [[ $complexity -gt $THRESHOLD ]]; then
      echo "  VIOLATION: $file: $in_function (complexity: $complexity, threshold: $THRESHOLD)"
      VIOLATIONS=$((VIOLATIONS + 1))
    fi
  fi
}

echo "Checking Haskell complexity (threshold: $THRESHOLD)..."
echo ""

while IFS= read -r -d '' file; do
  check_complexity "$file"
done < <(find "$TARGET_DIR" -name "*.hs" -print0)

echo "Total functions checked: $TOTAL_FUNCTIONS"
echo "Violations: $VIOLATIONS"

if [[ $VIOLATIONS -gt 0 ]]; then
  echo ""
  echo "FAILED: $VIOLATIONS function(s) exceed complexity threshold of $THRESHOLD"
  exit 1
else
  echo "PASSED: All functions within complexity threshold"
  exit 0
fi
