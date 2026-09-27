import { FizzBuzz変換 } from "./変換.js";

export const タイプ番号 = Object.freeze({
  通常: 1,
  数字限定: 2,
  FizzBuzz限定: 3,
});

export class 該当タイプなしエラー extends Error {
  constructor(番号) {
    super(`該当するタイプは存在しません: ${番号}`);
    this.name = "該当タイプなしエラー";
  }
}

class タイプ {
  constructor(名前, 変換) {
    this.名前 = 名前;
    this.変換 = 変換;
    Object.freeze(this);
  }
}

const 数字限定変換 = (N) => String(N);
const FizzBuzz限定変換 = (N) => (N % 15 === 0 ? "FizzBuzz" : String(N));

const タイプ一覧 = new Map([
  [タイプ番号.通常, new タイプ("通常", FizzBuzz変換)],
  [タイプ番号.数字限定, new タイプ("数字限定", 数字限定変換)],
  [タイプ番号.FizzBuzz限定, new タイプ("FizzBuzz限定", FizzBuzz限定変換)],
]);

export function タイプ生成(番号) {
  const 見つかったタイプ = タイプ一覧.get(番号);
  if (見つかったタイプ === undefined) throw new 該当タイプなしエラー(番号);
  return 見つかったタイプ;
}

export function タイプ変換(対象, N) {
  return 対象.変換(N);
}
