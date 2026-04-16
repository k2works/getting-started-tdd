package tdd.fizzbuzz.domain.type;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class FizzBuzzTypeTest {

    @Nested
    class タイプ1の場合 {
        private final FizzBuzzType type = FizzBuzzType.create(1);

        @Test
        void 三と五の倍数でFizzBuzzを返す() {
            assertEquals("FizzBuzz", type.generate(15).getValue());
        }

        @Test
        void 三の倍数でFizzを返す() {
            assertEquals("Fizz", type.generate(3).getValue());
        }

        @Test
        void 五の倍数でBuzzを返す() {
            assertEquals("Buzz", type.generate(5).getValue());
        }

        @Test
        void その他は数値を返す() {
            assertEquals("1", type.generate(1).getValue());
        }
    }

    @Nested
    class タイプ2の場合 {
        private final FizzBuzzType type = FizzBuzzType.create(2);

        @Test
        void 常に数値を返す() {
            assertEquals("3", type.generate(3).getValue());
            assertEquals("5", type.generate(5).getValue());
            assertEquals("15", type.generate(15).getValue());
        }
    }

    @Nested
    class タイプ3の場合 {
        private final FizzBuzzType type = FizzBuzzType.create(3);

        @Test
        void 十五の倍数のみFizzBuzzを返す() {
            assertEquals("FizzBuzz", type.generate(15).getValue());
            assertEquals("3", type.generate(3).getValue());
            assertEquals("5", type.generate(5).getValue());
        }
    }

    @Nested
    class 不正なタイプの場合 {
        @Test
        void 例外をスローする() {
            assertThrows(IllegalArgumentException.class,
                    () -> FizzBuzzType.create(4));
        }
    }

    @Nested
    class Optionalファクトリの場合 {
        @Test
        void 不正なタイプは空を返す() {
            assertEquals(Optional.empty(), FizzBuzzType.createOptional(4));
        }

        @Test
        void 正常なタイプは値を返す() {
            Optional<FizzBuzzType> type = FizzBuzzType.createOptional(1);

            assertTrue(type.isPresent());
            assertEquals("FizzBuzz", type.orElseThrow().generate(15).getValue());
        }
    }

    @Nested
    class enumファクトリの場合 {
        @Test
        void 列挙型から生成できる() {
            assertEquals("FizzBuzz",
                    FizzBuzzType.create(FizzBuzzTypeName.STANDARD).generate(15).getValue());
        }
    }
}
