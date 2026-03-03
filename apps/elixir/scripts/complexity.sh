#!/usr/bin/env bash
# complexity.sh — Elixir ソースの循環複雑度を簡易計測するスクリプト
#
# 使い方: bash scripts/complexity.sh [--threshold N] [path ...]
#
# 循環複雑度の計算ルール:
#   基本複雑度 = 1（関数ごと）
#   +1: if, unless, cond の各分岐
#   +1: case/with の各 -> 分岐
#   +1: &&, ||, and, or（短絡評価）
#   +1: for, Enum.each 等のループ
#   +1: try, rescue

set -euo pipefail

THRESHOLD=7
PATHS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --threshold)
      THRESHOLD="$2"
      shift 2
      ;;
    *)
      PATHS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#PATHS[@]} -eq 0 ]]; then
  PATHS=("lib")
fi

echo "=== Elixir 循環複雑度チェック (閾値: ${THRESHOLD}) ==="
echo

TOTAL_FUNCTIONS=0
TOTAL_VIOLATIONS=0
VIOLATIONS_LIST=""

count_pattern() {
  local body="$1"
  local pattern="$2"
  local count
  count=$(echo -e "$body" | grep -c "$pattern" 2>/dev/null) || true
  echo "${count:-0}"
}

process_method() {
  local method_name="$1"
  local method_body="$2"
  local file="$3"
  local complexity=1

  local c
  c=$(count_pattern "$method_body" '\bif\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\bunless\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\bcond\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\bfor\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\btry\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\brescue\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\band\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '\bor\b'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '&&'); complexity=$((complexity + c))
  c=$(count_pattern "$method_body" '||'); complexity=$((complexity + c))

  # case/with の -> 分岐をカウント
  local arrow_count
  arrow_count=$(count_pattern "$method_body" '->')
  complexity=$((complexity + arrow_count))

  TOTAL_FUNCTIONS=$((TOTAL_FUNCTIONS + 1))
  local filename
  filename=$(basename "$file")

  local status="OK"
  if [[ $complexity -gt $THRESHOLD ]]; then
    status="NG"
    TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
    VIOLATIONS_LIST="${VIOLATIONS_LIST}  - ${method_name} (${file}): 複雑度 ${complexity} > ${THRESHOLD}\n"
  fi
  printf "  %-2s %-40s (%-20s) 複雑度: %d\n" "$status" "$method_name" "$filename" "$complexity"
}

for src_path in "${PATHS[@]}"; do
  while IFS= read -r -d '' file; do
    current_method=""
    method_body=""

    while IFS= read -r line; do
      trimmed="${line#"${line%%[![:space:]]*}"}"

      # コメント行はスキップ
      [[ "$trimmed" == \#* ]] && continue

      # def/defp 関数定義の検出
      if [[ "$trimmed" =~ ^(def|defp)[[:space:]]+([a-zA-Z_][a-zA-Z0-9_?!]*) ]]; then
        if [[ -n "$current_method" ]]; then
          process_method "$current_method" "$method_body" "$file"
        fi
        current_method="${BASH_REMATCH[2]}"
        method_body=""
      fi

      if [[ -n "$current_method" ]]; then
        method_body="${method_body}${line}\n"
      fi

      # end でメソッド終了（トップレベルの end のみ）
      if [[ "$trimmed" == "end" && -n "$current_method" ]]; then
        process_method "$current_method" "$method_body" "$file"
        current_method=""
        method_body=""
      fi
    done < "$file"

    # 最後のメソッド
    if [[ -n "$current_method" ]]; then
      process_method "$current_method" "$method_body" "$file"
    fi
  done < <(find "$src_path" -name "*.ex" -not -path "*/test/*" -print0)
done

echo
echo "関数数: ${TOTAL_FUNCTIONS}, 違反: ${TOTAL_VIOLATIONS}"

if [[ $TOTAL_VIOLATIONS -gt 0 ]]; then
  echo
  echo "以下の関数が閾値を超えています:"
  echo -e "$VIOLATIONS_LIST"
  exit 1
else
  echo
  echo "OK すべての関数が複雑度閾値以内です。"
fi
