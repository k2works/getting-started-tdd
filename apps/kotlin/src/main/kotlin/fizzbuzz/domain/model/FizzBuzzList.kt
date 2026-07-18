package fizzbuzz.domain.model

import fizzbuzz.domain.type.FizzBuzzType

/**
 * FizzBuzz の結果を保持するファーストクラスコレクション。
 */
class FizzBuzzList(val values: List<FizzBuzzValue>) {
    /** 要素数。 */
    val count: Int get() = values.size

    companion object {
        /** 1 から [count] までの値オブジェクトを生成してコレクションを作る。 */
        fun create(count: Int, type: FizzBuzzType): FizzBuzzList =
            FizzBuzzList((1..count).map { FizzBuzzValue.create(type, it) })
    }
}
