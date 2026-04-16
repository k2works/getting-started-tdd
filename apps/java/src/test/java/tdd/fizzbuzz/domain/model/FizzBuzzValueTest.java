package tdd.fizzbuzz.domain.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class FizzBuzzValueTest {

    @Test
    void 値と数値を保持する() {
        FizzBuzzValue value = new FizzBuzzValue(15, "FizzBuzz");

        assertEquals(15, value.getNumber());
        assertEquals("FizzBuzz", value.getValue());
    }

    @Test
    void 等価性を持つ() {
        FizzBuzzValue value1 = new FizzBuzzValue(15, "FizzBuzz");
        FizzBuzzValue value2 = new FizzBuzzValue(15, "FizzBuzz");

        assertEquals(value1, value2);
        assertEquals(value1.hashCode(), value2.hashCode());
    }

    @Test
    void 文字列表現を持つ() {
        FizzBuzzValue value = new FizzBuzzValue(15, "FizzBuzz");

        assertEquals("15:FizzBuzz", value.toString());
    }
}
