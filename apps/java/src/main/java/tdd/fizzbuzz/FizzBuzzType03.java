package tdd.fizzbuzz;

public class FizzBuzzType03 extends FizzBuzzType {

    @Override
    public String generate(int number) {
        if (isFizzBuzz(number)) {
            return "FizzBuzz";
        }
        return Integer.toString(number);
    }
}
