import { して } from "./語順";
import { FizzBuzz変換 } from "./変換";

export function 装飾(文字列: string): string {
  return `[${文字列}]`;
}

// なでしこ3: 「NをFizzBuzz変換して装飾して戻す」
export const FizzBuzz装飾 = して(FizzBuzz変換, 装飾);

export function パイプライン処理(N: number): string[] {
  return Array.from({ length: N }, (_, 添字) => 添字 + 1).map(FizzBuzz装飾);
}
