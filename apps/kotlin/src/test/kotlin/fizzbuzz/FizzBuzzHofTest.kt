package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzHofTest {
    @Test fun `generateWith は渡したルールで変換する`() =
        assertEquals("Fizz", FizzBuzzHof.generateWith(FizzBuzzHof::defaultRule, 3))

    @Test fun `generateWith にカスタムルールを渡せる`() {
        val rule = { n: Int -> if (n % 2 == 0) "Even" else "Odd" }
        assertEquals("Even", FizzBuzzHof.generateWith(rule, 4))
    }

    @Test fun `transform は範囲をルールで変換する`() =
        assertEquals("Fizz", FizzBuzzHof.transform(FizzBuzzHof::defaultRule, 5)[2])

    @Test fun `filterList は述語で絞り込む`() {
        val xs = FizzBuzzHof.transform(FizzBuzzHof::defaultRule, 15)
        assertEquals(4, FizzBuzzHof.filterList({ it == "Fizz" }, xs).size)
    }
}
