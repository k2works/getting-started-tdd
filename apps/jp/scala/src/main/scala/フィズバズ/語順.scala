package フィズバズ

extension [T](目的語: T)
  /** 「〜を（動詞）」: `3 を FizzBuzz変換` のように目的語を先に置いて関数を適用する。 */
  infix def を[R](動詞: T => R): R = 動詞(目的語)

  /** 「〜して（動詞）」: `数 を FizzBuzz変換 して 装飾` のように続けて適用する。 */
  infix def して[R](動詞: T => R): R = 動詞(目的語)
