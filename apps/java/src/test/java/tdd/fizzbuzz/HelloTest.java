package tdd.fizzbuzz;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class HelloTest {
    @Test
    void test_greeting() {
        assertEquals("hello world", greeting());
    }

    private String greeting() {
        return "hello world";
    }
}
