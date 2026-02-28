package tdd.fizzbuzz.domain.model;

import org.junit.jupiter.api.Test;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import static org.junit.jupiter.api.Assertions.*;

class FizzBuzzListTest {

    @Test
    void リストのサイズを返す() {
        List<FizzBuzzValue> values = Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(2, "2")
        );
        FizzBuzzList list = new FizzBuzzList(values);
        assertEquals(2, list.size());
    }

    @Test
    void インデックスで要素を取得できる() {
        List<FizzBuzzValue> values = Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz")
        );
        FizzBuzzList list = new FizzBuzzList(values);
        assertEquals(new FizzBuzzValue(3, "Fizz"), list.get(1));
    }

    @Test
    void リストを結合して新しいリストを返す() {
        List<FizzBuzzValue> values1 = Arrays.asList(new FizzBuzzValue(1, "1"));
        List<FizzBuzzValue> values2 = Arrays.asList(new FizzBuzzValue(2, "2"));
        FizzBuzzList list = new FizzBuzzList(values1);
        FizzBuzzList combined = list.add(values2);
        assertEquals(2, combined.size());
        assertEquals(1, list.size());
    }

    @Test
    void filterでFizzだけ抽出できる() {
        FizzBuzzList list = new FizzBuzzList(Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(5, "Buzz"),
            new FizzBuzzValue(6, "Fizz")
        ));

        FizzBuzzList filtered = list.filter(value -> "Fizz".equals(value.getValue()));

        assertEquals(2, filtered.size());
        assertEquals(new FizzBuzzValue(3, "Fizz"), filtered.get(0));
        assertEquals(new FizzBuzzValue(6, "Fizz"), filtered.get(1));
    }

    @Test
    void 文字列リストを取得できる() {
        FizzBuzzList list = new FizzBuzzList(Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(5, "Buzz")
        ));

        List<String> values = list.toStringValues();

        assertEquals(Arrays.asList("1", "Fizz", "Buzz"), values);
    }

    @Test
    void 値ごとのカウントを取得できる() {
        FizzBuzzList list = new FizzBuzzList(Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(6, "Fizz"),
            new FizzBuzzValue(5, "Buzz")
        ));

        Map<String, Long> counted = list.countByValue();

        assertEquals(1L, counted.get("1"));
        assertEquals(2L, counted.get("Fizz"));
        assertEquals(1L, counted.get("Buzz"));
    }

    @Test
    void findFirstで最初の一致をOptionalで返す() {
        FizzBuzzList list = new FizzBuzzList(Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(6, "Fizz")
        ));

        assertEquals(
            new FizzBuzzValue(3, "Fizz"),
            list.findFirst(value -> "Fizz".equals(value.getValue())).orElseThrow()
        );
    }

    @Test
    void findFirstで一致がない場合はemptyを返す() {
        FizzBuzzList list = new FizzBuzzList(Arrays.asList(
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(2, "2")
        ));

        assertTrue(list.findFirst(value -> "Fizz".equals(value.getValue())).isEmpty());
    }
}
