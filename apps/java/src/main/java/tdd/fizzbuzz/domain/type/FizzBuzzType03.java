package tdd.fizzbuzz.domain.type;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public class FizzBuzzType03 extends FizzBuzzType {
    @Override
    public FizzBuzzValue generate(int number) {
        if (isFizzBuzz(number)) {
            return new FizzBuzzValue(number, "FizzBuzz");
        }
        return new FizzBuzzValue(number, String.valueOf(number));
    }
}
