import { FizzBuzz変換 } from "./変換";

export type 変換関数 = (N: number) => string;

export interface タイプ {
  readonly 名前: string;
  readonly 変換: 変換関数;
}

export enum タイプ番号 {
  通常 = 1,
  数字限定 = 2,
  FizzBuzz限定 = 3,
}

export class 該当タイプなしエラー extends Error {
  constructor(番号: number) {
    super(`該当するタイプは存在しません: ${番号}`);
    this.name = "該当タイプなしエラー";
  }
}

const 数字限定変換: 変換関数 = (N) => String(N);

const FizzBuzz限定変換: 変換関数 = (N) =>
  N % 15 === 0 ? "FizzBuzz" : String(N);

const タイプ一覧: Record<タイプ番号, タイプ> = {
  [タイプ番号.通常]: { 名前: "通常", 変換: FizzBuzz変換 },
  [タイプ番号.数字限定]: { 名前: "数字限定", 変換: 数字限定変換 },
  [タイプ番号.FizzBuzz限定]: { 名前: "FizzBuzz限定", 変換: FizzBuzz限定変換 },
};

export function タイプ生成(番号: number): タイプ {
  const 見つかったタイプ = タイプ一覧[番号 as タイプ番号];
  if (見つかったタイプ === undefined) throw new 該当タイプなしエラー(番号);
  return 見つかったタイプ;
}

export function タイプ変換(対象: タイプ, N: number): string {
  return 対象.変換(N);
}
