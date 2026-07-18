///
/// エントリーポイント。1 から 100 までの FizzBuzz を出力する。
///
def main(): Unit \ IO =
    FizzBuzz.generateList(100) |> List.forEach(println)
