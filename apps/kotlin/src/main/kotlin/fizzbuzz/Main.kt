package fizzbuzz

/**
 * エントリーポイント。1 から 100 までの FizzBuzz を出力する。
 */
fun main() {
    FizzBuzz.generateList(100).forEach(::println)
}
