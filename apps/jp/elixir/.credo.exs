# Credo の FunctionNames チェックは日本語の関数名（fizzbuzz_変換・タイプ生成 など）を
# snake_case でないと判定するため、このチェックだけを無効にする（FINDINGS.md 参照）
%{
  configs: [
    %{
      name: "default",
      checks: %{
        disabled: [
          {Credo.Check.Readability.FunctionNames, []}
        ]
      }
    }
  ]
}
