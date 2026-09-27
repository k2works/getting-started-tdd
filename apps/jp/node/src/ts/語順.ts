// 「3を FizzBuzz変換」の SOV 順を、組み込み型を拡張せずに再現する 3 つの方法

/** 1. メソッドチェーンを持つラッパー: それ(3).を(FizzBuzz変換).して(装飾).戻す() */
export class 主題<T> {
  constructor(readonly 値: T) {}

  を<U>(動詞: (目的語: T) => U): 主題<U> {
    return new 主題(動詞(this.値));
  }

  して<U>(動詞: (目的語: T) => U): 主題<U> {
    return this.を(動詞);
  }

  戻す(): T {
    return this.値;
  }
}

export const それ = <T>(値: T): 主題<T> => new 主題(値);

/** 2. 関数合成: して(FizzBuzz変換, 装飾) は「FizzBuzz変換して装飾する」関数 */
export const して =
  <A, B, C>(先: (x: A) => B, 後: (x: B) => C) =>
  (x: A): C =>
    後(先(x));

/** 3. タグ付きテンプレート: 日本語`${3}を${FizzBuzz変換}して${装飾}` */
type 動詞 = (目的語: never) => unknown;
const 対応する助詞 = new Set(["を", "して"]);

export function 日本語(
  部品: TemplateStringsArray,
  主語: unknown,
  ...動詞列: 動詞[]
): unknown {
  return 動詞列.reduce((目的語: unknown, 動詞, 位置) => {
    const 助詞 = 部品[位置 + 1].trim();
    if (!対応する助詞.has(助詞)) {
      throw new Error(`助詞「${助詞}」には対応していません`);
    }
    return (動詞 as (x: unknown) => unknown)(目的語);
  }, 主語);
}
