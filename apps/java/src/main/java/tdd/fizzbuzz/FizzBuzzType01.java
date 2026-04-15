package tdd.fizzbuzz;

public class FizzBuzzType01 extends FizzBuzzType {

    @Override
    public String generate(int number) {
        if (isFizzBuzz(number)) {
            return "FizzBuzz";
        }
        if (isFizz(number)) {
            return "Fizz";
        }
        if (isBuzz(number)) {
            return "Buzz";
        }
        return Integer.toString(number);
    }
}
