package tdd.fizzbuzz;

import java.util.ArrayList;
import java.util.List;

public class FizzBuzz {

    private static final int FIZZ_NUMBER = 3;
    private static final int BUZZ_NUMBER = 5;

    public String generate(int number) {
        if (number % FIZZ_NUMBER == 0 && number % BUZZ_NUMBER == 0) {
            return "FizzBuzz";
        } else if (number % FIZZ_NUMBER == 0) {
            return "Fizz";
        } else if (number % BUZZ_NUMBER == 0) {
            return "Buzz";
        }
        return String.valueOf(number);
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
