package tdd.fizzbuzz.domain.type;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import java.util.Optional;
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

    @Nested
    class OptionalFactoryCase {
        @Test
        void createOptional1はOptionalofを返す() {
            Optional<FizzBuzzType> type = FizzBuzzType.createOptional(1);
            assertTrue(type.isPresent());
            assertTrue(type.get() instanceof FizzBuzzType01);
        }

        @Test
        void createOptional4はOptionalemptyを返す() {
            assertEquals(Optional.empty(), FizzBuzzType.createOptional(4));
        }
    }

    @Nested
    class EnumFactoryCase {
        @Test
        void STANDARDでcreateできる() {
            FizzBuzzType type = FizzBuzzType.create(FizzBuzzTypeName.STANDARD);
            assertNotNull(type);
            assertTrue(type instanceof FizzBuzzType01);
        }

        @Test
        void enumのコード値が正しい() {
            assertEquals(1, FizzBuzzTypeName.STANDARD.getCode());
            assertEquals(2, FizzBuzzTypeName.NUMBER_ONLY.getCode());
            assertEquals(3, FizzBuzzTypeName.FIZZBUZZ_ONLY.getCode());
        }
    }
}
