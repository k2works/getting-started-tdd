package tdd.fizzbuzz.domain.model;

import org.junit.jupiter.api.Test;
import java.util.Arrays;
import java.util.List;
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
}
