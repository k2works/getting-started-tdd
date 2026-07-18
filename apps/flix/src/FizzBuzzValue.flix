///
/// 数値と変換結果をまとめた値オブジェクト。
///
enum FizzBuzzValue({ number = Int32, value = String })

mod FizzBuzzValue {
    ///
    /// タイプに従って数 `n` の値オブジェクトを生成する。
    ///
    pub def create(fbType: FizzBuzzType, n: Int32): FizzBuzzValue =
        FizzBuzzValue.FizzBuzzValue({ number = n, value = Generatable.generate(fbType, n) })

    ///
    /// 保持している数値を取り出す。
    ///
    pub def number(v: FizzBuzzValue): Int32 =
        let FizzBuzzValue.FizzBuzzValue(r) = v;
        r#number

    ///
    /// 保持している変換結果を取り出す。
    ///
    pub def value(v: FizzBuzzValue): String =
        let FizzBuzzValue.FizzBuzzValue(r) = v;
        r#value
}
