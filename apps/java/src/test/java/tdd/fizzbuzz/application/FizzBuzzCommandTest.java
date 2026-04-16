package tdd.fizzbuzz.application;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;
import tdd.fizzbuzz.domain.type.FizzBuzzType01;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class FizzBuzzCommandTest {

    @Nested
    class 単一値コマンドの場合 {
        private final FizzBuzzCommand command = new FizzBuzzValueCommand(new FizzBuzzType01());

        @Test
        void test_15を渡したらFizzBuzzValueを返す() {
            assertEquals(new FizzBuzzValue(15, "FizzBuzz"), command.execute(15));
        }

        @Test
        void test_リスト実行は未対応である() {
            assertThrows(UnsupportedOperationException.class, () -> command.executeList(1));
        }
    }

    @Nested
    class リスト生成コマンドの場合 {
        private final FizzBuzzCommand command = new FizzBuzzListCommand(new FizzBuzzType01());

        @Test
        void test_5件のFizzBuzzリストを返す() {
            FizzBuzzList result = command.executeList(5);

            assertEquals(5, result.size());
            assertEquals(new FizzBuzzValue(1, "1"), result.get(0));
            assertEquals(new FizzBuzzValue(2, "2"), result.get(1));
            assertEquals(new FizzBuzzValue(3, "Fizz"), result.get(2));
            assertEquals(new FizzBuzzValue(4, "4"), result.get(3));
            assertEquals(new FizzBuzzValue(5, "Buzz"), result.get(4));
        }

        @Test
        void test_単一値実行は未対応である() {
            assertThrows(UnsupportedOperationException.class, () -> command.execute(1));
        }
    }
}
