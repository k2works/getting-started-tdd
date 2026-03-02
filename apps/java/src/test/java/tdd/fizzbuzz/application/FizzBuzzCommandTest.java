package tdd.fizzbuzz.application;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;
import tdd.fizzbuzz.domain.type.FizzBuzzType;

import static org.junit.jupiter.api.Assertions.*;

class FizzBuzzCommandTest {

    @Nested
    class FizzBuzzValueCommandCase {
        @Test
        void 単一値を取得できる() {
            FizzBuzzType type = FizzBuzzType.create(1);
            FizzBuzzValueCommand command = new FizzBuzzValueCommand(type);
            FizzBuzzValue result = command.execute(15);
            assertEquals("FizzBuzz", result.getValue());
            assertEquals(15, result.getNumber());
        }
    }

    @Nested
    class FizzBuzzListCommandCase {
        @Test
        void リストを生成できる() {
            FizzBuzzType type = FizzBuzzType.create(1);
            FizzBuzzListCommand command = new FizzBuzzListCommand(type);
            FizzBuzzList result = command.executeList(100);
            assertEquals(100, result.size());
            assertEquals("1", result.get(0).getValue());
            assertEquals("Fizz", result.get(2).getValue());
            assertEquals("Buzz", result.get(4).getValue());
            assertEquals("FizzBuzz", result.get(14).getValue());
        }
    }
}
