package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzPipelineTest {
    @Test fun `compose は f のあとに g を適用する`() {
        val f = FizzBuzzPipeline.compose({ x: Int -> x + 1 }, { x: Int -> x * 2 })
        assertEquals(8, f(3))
    }

    @Test fun `合成で変換と装飾を連結する`() =
        assertEquals("[Fizz]", FizzBuzzPipeline.convertAndDecorate(3))

    @Test fun `パイプラインは各要素を変換・装飾する`() =
        assertEquals("[Buzz]", FizzBuzzPipeline.process(5)[4])

    @Test fun `パイプラインは元の範囲と同じ件数`() =
        assertEquals(15, FizzBuzzPipeline.process(15).size)
}
