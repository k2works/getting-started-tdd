package tdd.fizzbuzz.domain.type;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public final class FizzBuzzType01 extends FizzBuzzType {

    @Override
    public FizzBuzzValue generate(int number) {
        if (isFizzBuzz(number)) {
            return new FizzBuzzValue(number, "FizzBuzz");
        }
        if (isFizz(number)) {
            return new FizzBuzzValue(number, "Fizz");
        }
        if (isBuzz(number)) {
            return new FizzBuzzValue(number, "Buzz");
        }
        return new FizzBuzzValue(number, Integer.toString(number));
    }
}
