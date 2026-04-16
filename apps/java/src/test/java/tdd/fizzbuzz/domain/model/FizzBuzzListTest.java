package tdd.fizzbuzz.domain.model;

import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;

class FizzBuzzListTest {

    @Test
    void 値の一覧を保持する() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(2, "2")));

        assertEquals(2, list.size());
        assertEquals(new FizzBuzzValue(1, "1"), list.get(0));
        assertEquals(new FizzBuzzValue(2, "2"), list.get(1));
    }

    @Test
    void 追加すると新しい一覧を返す() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1")));

        FizzBuzzList result = list.add(List.of(
                new FizzBuzzValue(2, "2")));

        assertEquals(1, list.size());
        assertEquals(2, result.size());
        assertEquals(new FizzBuzzValue(1, "1"), result.get(0));
        assertEquals(new FizzBuzzValue(2, "2"), result.get(1));
    }

    @Test
    void 等価性を持つ() {
        FizzBuzzList list1 = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1")));
        FizzBuzzList list2 = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1")));

        assertEquals(list1, list2);
        assertEquals(list1.hashCode(), list2.hashCode());
    }

    @Test
    void 条件で絞り込める() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(3, "Fizz"),
                new FizzBuzzValue(5, "Buzz"),
                new FizzBuzzValue(6, "Fizz")));

        FizzBuzzList fizzOnly = list.filter(value -> "Fizz".equals(value.getValue()));

        assertEquals(2, fizzOnly.size());
        assertEquals(new FizzBuzzValue(3, "Fizz"), fizzOnly.get(0));
        assertEquals(new FizzBuzzValue(6, "Fizz"), fizzOnly.get(1));
    }

    @Test
    void 値を変換できる() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(3, "Fizz")));

        assertEquals(List.of("1", "Fizz"), list.toStringValues());
        assertEquals(List.of(1, 3), list.map(FizzBuzzValue::getNumber));
    }

    @Test
    void 値ごとに分類できる() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(3, "Fizz"),
                new FizzBuzzValue(6, "Fizz"),
                new FizzBuzzValue(5, "Buzz")));

        Map<String, List<FizzBuzzValue>> grouped = list.groupByValue();

        assertEquals(List.of(
                new FizzBuzzValue(1, "1")), grouped.get("1"));
        assertEquals(List.of(
                new FizzBuzzValue(3, "Fizz"),
                new FizzBuzzValue(6, "Fizz")), grouped.get("Fizz"));
        assertEquals(List.of(
                new FizzBuzzValue(5, "Buzz")), grouped.get("Buzz"));
    }

    @Test
    void 値の個数を数えられる() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(3, "Fizz"),
                new FizzBuzzValue(6, "Fizz"),
                new FizzBuzzValue(5, "Buzz")));

        Map<String, Long> counts = list.countByValue();

        assertEquals(1L, counts.get("1"));
        assertEquals(2L, counts.get("Fizz"));
        assertEquals(1L, counts.get("Buzz"));
    }

    @Test
    void 値を区切り文字で結合できる() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(3, "Fizz"),
                new FizzBuzzValue(5, "Buzz")));

        assertEquals("1,Fizz,Buzz", list.joining(","));
    }

    @Test
    void 最初に一致した値を返す() {
        FizzBuzzList list = new FizzBuzzList(List.of(
                new FizzBuzzValue(1, "1"),
                new FizzBuzzValue(3, "Fizz"),
                new FizzBuzzValue(6, "Fizz")));

        assertEquals(Optional.of(new FizzBuzzValue(3, "Fizz")),
                list.findFirst(value -> "Fizz".equals(value.getValue())));
    }
}
