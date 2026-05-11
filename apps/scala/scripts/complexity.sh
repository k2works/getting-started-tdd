#!/usr/bin/env bash

set -euo pipefail

threshold=7
target_path=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --threshold)
      threshold="$2"
      shift 2
      ;;
    *)
      target_path="$1"
      shift
      ;;
  esac
done

if [[ -z "${target_path}" ]]; then
  echo "Usage: bash scripts/complexity.sh [--threshold N] <path>" >&2
  exit 1
fi

if [[ ! -d "${target_path}" ]]; then
  echo "Path not found: ${target_path}" >&2
  exit 1
fi

tmp_output="$(mktemp)"
trap 'rm -f "${tmp_output}"' EXIT

find "${target_path}" -type f -name '*.scala' | sort | while read -r file; do
  env TMP_OUTPUT="${tmp_output}" awk -v threshold="${threshold}" -v file="${file}" '
    function flush_function() {
      if (in_function == 0) {
        return
      }

      printf "%s\t%s\t%d\n", function_name, file, complexity >> output_file
      in_function = 0
      function_name = ""
      complexity = 1
    }

    BEGIN {
      output_file = ENVIRON["TMP_OUTPUT"]
      in_function = 0
      complexity = 1
    }

    /^[[:space:]]*\/\// {
      next
    }

    /^[[:space:]]*def[[:space:]]+/ {
      flush_function()
      in_function = 1
      complexity = 1
      line = $0
      sub(/^[[:space:]]*def[[:space:]]+/, "", line)
      match(line, /^[[:alnum:]_]+/)
      function_name = substr(line, RSTART, RLENGTH)
    }

    {
      if (in_function == 0) {
        next
      }

      line = $0

      if (line ~ /(^|[^[:alnum:]_])if([^[:alnum:]_]|$)/) complexity += gsub(/(^|[^[:alnum:]_])if([^[:alnum:]_]|$)/, "&", line)
      if (line ~ /(^|[^[:alnum:]_])case([^[:alnum:]_]|$)/) complexity += gsub(/(^|[^[:alnum:]_])case([^[:alnum:]_]|$)/, "&", line)
      if (line ~ /(^|[^[:alnum:]_])while([^[:alnum:]_]|$)/) complexity += gsub(/(^|[^[:alnum:]_])while([^[:alnum:]_]|$)/, "&", line)
      if (line ~ /(^|[^[:alnum:]_])for([^[:alnum:]_]|$)/) complexity += gsub(/(^|[^[:alnum:]_])for([^[:alnum:]_]|$)/, "&", line)
      if (line ~ /&&/) complexity += gsub(/&&/, "&", line)
      if (line ~ /\|\|/) complexity += gsub(/\|\|/, "&", line)
      if (line ~ /(^|[^[:alnum:]_])catch([^[:alnum:]_]|$)/) complexity += gsub(/(^|[^[:alnum:]_])catch([^[:alnum:]_]|$)/, "&", line)
    }

    END {
      flush_function()
    }
  ' "${file}"
done

echo "=== Scala 循環複雑度チェック (閾値: ${threshold}) ==="
echo

violations=0
function_count=0

while IFS=$'\t' read -r function_name file complexity; do
  [[ -z "${function_name}" ]] && continue
  function_count=$((function_count + 1))
  short_file="${file#${target_path}/}"

  if (( complexity > threshold )); then
    printf '  NG %-26s (%s) 複雑度: %s\n' "${function_name}" "${short_file}" "${complexity}"
    violations=$((violations + 1))
  else
    printf '  OK %-26s (%s) 複雑度: %s\n' "${function_name}" "${short_file}" "${complexity}"
  fi
done < "${tmp_output}"

echo
echo "関数数: ${function_count}, 違反: ${violations}"
echo

if (( violations > 0 )); then
  echo "NG 複雑度閾値を超える関数があります。"
  exit 1
fi

echo "OK すべての関数が複雑度閾値以内です。"
