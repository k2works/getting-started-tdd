///
/// 題材 B: タイプ生成（なでしこ3 の `●(番号から)タイプ生成`）。
///
/// 型名・列挙子も ASCII のみ。なでしこ3 の「タイプ」「通常」などはローマ字にする。
///
enum Taipu {
    case Tsuujou         // 通常
    case SuujiGentei     // 数字限定
    case FizzBuzzGentei  // FizzBuzz限定
}

mod Taipu {
    ///
    /// タイプ生成: 番号からタイプを作る。該当しなければエラーメッセージを返す。
    ///
    pub def taipuSeisei(bangou: Int32): Result[String, Taipu] = match bangou {
        case 1 => Ok(Taipu.Tsuujou)
        case 2 => Ok(Taipu.SuujiGentei)
        case 3 => Ok(Taipu.FizzBuzzGentei)
        case _ => Err("該当するタイプは存在しません: ${bangou}")
    }

    ///
    /// 名前: タイプの日本語名（文字列の中は日本語を書ける）。
    ///
    pub def namae(t: Taipu): String = match t {
        case Taipu.Tsuujou        => "通常"
        case Taipu.SuujiGentei    => "数字限定"
        case Taipu.FizzBuzzGentei => "FizzBuzz限定"
    }

    ///
    /// タイプ変換: タイプに応じた変換を `n` に適用する。
    ///
    pub def taipuHenkan(t: Taipu, n: Int32): String = match t {
        case Taipu.Tsuujou        => FizzBuzz.fizzBuzzHenkan(n)
        case Taipu.SuujiGentei    => Int32.toString(n)
        case Taipu.FizzBuzzGentei =>
            if (Int32.remainder(n, 15) == 0) "FizzBuzz" else Int32.toString(n)
    }
}
