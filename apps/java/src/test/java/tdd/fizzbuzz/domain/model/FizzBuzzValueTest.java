package tdd.fizzbuzz.domain.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class FizzBuzzValueTest {

    @Test
    void 値を保持する() {
        FizzBuzzValue value = new FizzBuzzValue(3, "Fizz");
        assertEquals(3, value.getNumber());
        assertEquals("Fizz", value.getValue());
    }

    @Test
    void 等価性を比較できる() {
        FizzBuzzValue value1 = new FizzBuzzValue(3, "Fizz");
        FizzBuzzValue value2 = new FizzBuzzValue(3, "Fizz");
        assertEquals(value1, value2);
        assertEquals(value1.hashCode(), value2.hashCode());
    }

    @Test
    void 文字列表現を返す() {
        FizzBuzzValue value = new FizzBuzzValue(3, "Fizz");
        assertEquals("3:Fizz", value.toString());
    }
}
