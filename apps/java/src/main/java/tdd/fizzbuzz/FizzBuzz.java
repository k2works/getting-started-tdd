package tdd.fizzbuzz;

import java.util.ArrayList;
import java.util.List;

public class FizzBuzz {

    private static final int FIZZ_NUMBER = 3;
    private static final int BUZZ_NUMBER = 5;
    private static final int FIZZ_BUZZ_NUMBER = FIZZ_NUMBER * BUZZ_NUMBER;

    public String generate(int number) {
        if (number % FIZZ_BUZZ_NUMBER == 0) {
            return "FizzBuzz";
        }
        if (number % FIZZ_NUMBER == 0) {
            return "Fizz";
        }
        if (number % BUZZ_NUMBER == 0) {
            return "Buzz";
        }
        return Integer.toString(number);
    }

    public List<String> generateList(int count) {
        List<String> result = new ArrayList<>();
        for (int i = 1; i <= count; i++) {
            result.add(generate(i));
        }
        return result;
    }

    public void printFizzBuzz(int count) {
        List<String> result = generateList(count);
        for (String value : result) {
            System.out.println(value);
        }
    }
}
