package tdd.fizzbuzz;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class FizzBuzzTest {

    @Nested
    class タイプ1の場合 {
        private FizzBuzz fizzbuzz;

        @BeforeEach
        void setUp() {
            fizzbuzz = new FizzBuzz(1);
        }

        @Nested
        class 三と五の倍数の場合 {
            @Test
            void test_15を渡したら文字列FizzBuzzを返す() {
                assertEquals("FizzBuzz", fizzbuzz.generate(15));
            }
        }

        @Nested
        class 三の倍数の場合 {
            @Test
            void test_3を渡したら文字列Fizzを返す() {
                assertEquals("Fizz", fizzbuzz.generate(3));
            }
        }

        @Nested
        class 五の倍数の場合 {
            @Test
            void test_5を渡したら文字列Buzzを返す() {
                assertEquals("Buzz", fizzbuzz.generate(5));
            }
        }

        @Nested
        class その他の場合 {
            @Test
            void test_1を渡したら文字列1を返す() {
                assertEquals("1", fizzbuzz.generate(1));
            }

            @Test
            void test_2を渡したら文字列2を返す() {
                assertEquals("2", fizzbuzz.generate(2));
            }
        }

        @Test
        void test_1から100までのFizzBuzzを生成する() {
            List<String> result = fizzbuzz.generateList(100);

            assertEquals(100, result.size());
            assertEquals("1", result.get(0));
            assertEquals("2", result.get(1));
            assertEquals("Fizz", result.get(2));
            assertEquals("4", result.get(3));
            assertEquals("Buzz", result.get(4));
            assertEquals("Fizz", result.get(5));
            assertEquals("FizzBuzz", result.get(14));
            assertEquals("Buzz", result.get(99));
        }

        @Test
        void test_プリントする() {
            PrintStream originalOut = System.out;
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            System.setOut(new PrintStream(buffer, true, StandardCharsets.UTF_8));

            try {
                fizzbuzz.printFizzBuzz(5);
            } finally {
                System.setOut(originalOut);
            }

            assertEquals("1" + System.lineSeparator()
                    + "2" + System.lineSeparator()
                    + "Fizz" + System.lineSeparator()
                    + "4" + System.lineSeparator()
                    + "Buzz" + System.lineSeparator(), buffer.toString(StandardCharsets.UTF_8));
        }
    }

    @Nested
    class タイプ2の場合 {
        private FizzBuzz fizzbuzz;

        @BeforeEach
        void setUp() {
            fizzbuzz = new FizzBuzz(2);
        }

        @Test
        void test_3を渡したら文字列3を返す() {
            assertEquals("3", fizzbuzz.generate(3));
        }

        @Test
        void test_5を渡したら文字列5を返す() {
            assertEquals("5", fizzbuzz.generate(5));
        }

        @Test
        void test_15を渡したら文字列15を返す() {
            assertEquals("15", fizzbuzz.generate(15));
        }

        @Test
        void test_1を渡したら文字列1を返す() {
            assertEquals("1", fizzbuzz.generate(1));
        }
    }

    @Nested
    class タイプ3の場合 {
        private FizzBuzz fizzbuzz;

        @BeforeEach
        void setUp() {
            fizzbuzz = new FizzBuzz(3);
        }

        @Test
        void test_3を渡したら文字列3を返す() {
            assertEquals("3", fizzbuzz.generate(3));
        }

        @Test
        void test_5を渡したら文字列5を返す() {
            assertEquals("5", fizzbuzz.generate(5));
        }

        @Test
        void test_15を渡したら文字列FizzBuzzを返す() {
            assertEquals("FizzBuzz", fizzbuzz.generate(15));
        }

        @Test
        void test_1を渡したら文字列1を返す() {
            assertEquals("1", fizzbuzz.generate(1));
        }
    }

    @Nested
    class それ以外のタイプの場合 {
        @Test
        void test_存在しないタイプを指定したら例外が発生する() {
            assertThrows(IllegalArgumentException.class, () -> new FizzBuzz(4));
        }
    }
}
