///
/// FizzBuzz のタイプ（出力の切り替え）を表す列挙型。
///
enum FizzBuzzType with Eq, ToString {
    case Type01  // 通常の FizzBuzz
    case Type02  // 数字のみ
    case Type03  // FizzBuzz の場合のみ
}

///
/// タイプに応じて数を文字列へ変換できることを表すトレイト。
///
trait Generatable[a] {
    pub def generate(x: a, n: Int32): String
}

///
/// FizzBuzzType に対する Generatable の実装。
///
instance Generatable[FizzBuzzType] {
    pub def generate(x: FizzBuzzType, n: Int32): String = match x {
        case FizzBuzzType.Type01 =>
            if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
            else if (Int32.remainder(n, 3) == 0) "Fizz"
            else if (Int32.remainder(n, 5) == 0) "Buzz"
            else                                 Int32.toString(n)
        case FizzBuzzType.Type02 =>
            Int32.toString(n)
        case FizzBuzzType.Type03 =>
            if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
            else if (Int32.remainder(n, 3) == 0) "Fizz"
            else                                 Int32.toString(n)
    }
}

mod FizzBuzzType {
    ///
    /// タイプ番号から FizzBuzzType を生成する。
    /// 未定義の番号は Err を返す。
    ///
    pub def create(no: Int32): Result[String, FizzBuzzType] = match no {
        case 1 => Ok(FizzBuzzType.Type01)
        case 2 => Ok(FizzBuzzType.Type02)
        case 3 => Ok(FizzBuzzType.Type03)
        case _ => Err("該当するタイプは存在しません: ${no}")
    }
}
