///
/// FizzBuzz の結果を保持するファーストクラスコレクション。
///
enum FizzBuzzList(List[FizzBuzzValue])

mod FizzBuzzList {
    ///
    /// 1 から `count` までの値オブジェクトを生成してコレクションを作る。
    ///
    pub def create(count: Int32, fbType: FizzBuzzType): FizzBuzzList =
        List.range(1, count + 1)
            |> List.map(n -> FizzBuzzValue.create(fbType, n))
            |> FizzBuzzList.FizzBuzzList

    ///
    /// 要素数を返す。
    ///
    pub def count(list: FizzBuzzList): Int32 =
        let FizzBuzzList.FizzBuzzList(xs) = list;
        List.length(xs)

    ///
    /// 内部のリストを取り出す。
    ///
    pub def values(list: FizzBuzzList): List[FizzBuzzValue] =
        let FizzBuzzList.FizzBuzzList(xs) = list;
        xs
}
