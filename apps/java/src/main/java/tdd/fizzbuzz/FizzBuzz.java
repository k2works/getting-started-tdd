package tdd.fizzbuzz;

public class FizzBuzz {

    public String generate(int number) {
        if (number == 3) {
            return "Fizz";
        }
        return Integer.toString(number);
    }
}
