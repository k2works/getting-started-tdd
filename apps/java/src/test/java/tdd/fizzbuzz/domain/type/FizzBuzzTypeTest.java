package tdd.fizzbuzz.domain.type;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class FizzBuzzTypeTest {

    @Nested
    class Type1Case {
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
            assertEquals("2", type.generate(2).getValue());
        }
    }

    @Nested
    class Type2Case {
        private final FizzBuzzType type = FizzBuzzType.create(2);

        @Test
        void 常に数値を返す() {
            assertEquals("3", type.generate(3).getValue());
            assertEquals("5", type.generate(5).getValue());
            assertEquals("15", type.generate(15).getValue());
            assertEquals("1", type.generate(1).getValue());
        }
    }

    @Nested
    class Type3Case {
        private final FizzBuzzType type = FizzBuzzType.create(3);

        @Test
        void 十五の倍数のみFizzBuzzを返す() {
            assertEquals("FizzBuzz", type.generate(15).getValue());
            assertEquals("3", type.generate(3).getValue());
            assertEquals("5", type.generate(5).getValue());
            assertEquals("1", type.generate(1).getValue());
        }
    }

    @Nested
    class InvalidTypeCase {
        @Test
        void 例外をスローする() {
            assertThrows(IllegalArgumentException.class, () -> FizzBuzzType.create(4));
        }
    }
}
