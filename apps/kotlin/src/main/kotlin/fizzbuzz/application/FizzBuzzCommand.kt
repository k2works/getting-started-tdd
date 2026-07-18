package fizzbuzz.application

import fizzbuzz.domain.model.FizzBuzzList
import fizzbuzz.domain.model.FizzBuzzValue
import fizzbuzz.domain.type.FizzBuzzType

/**
 * FizzBuzz の実行要求を表すコマンド。
 */
sealed class FizzBuzzCommand {
    /** 単一の値を生成する。 */
    data class ValueCommand(val type: FizzBuzzType) : FizzBuzzCommand()

    /** 1 から n までのリストを生成する。 */
    data class ListCommand(val type: FizzBuzzType) : FizzBuzzCommand()

    /** コマンドを数 [n] に対して実行し、結果コレクションを返す。 */
    fun execute(n: Int): FizzBuzzList = when (this) {
        is ValueCommand -> FizzBuzzList(listOf(FizzBuzzValue.create(type, n)))
        is ListCommand -> FizzBuzzList.create(n, type)
    }
}
