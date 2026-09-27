import { FizzBuzz変換 } from "./変換.js";

const 成功結果 = (値) => ({ 成功: true, 値 });
const 失敗結果 = (エラー) => ({ 成功: false, エラー });

export function 安全変換(N) {
  if (typeof N !== "number") return 失敗結果(`数値を指定してください: ${N}`);
  if (N <= 0) return 失敗結果(`正の数を指定してください: ${N}`);
  return 成功結果(FizzBuzz変換(N));
}
