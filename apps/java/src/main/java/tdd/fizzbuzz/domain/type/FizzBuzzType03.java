package tdd.fizzbuzz.domain.type;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public final class FizzBuzzType03 extends FizzBuzzType {

    @Override
    public FizzBuzzValue generate(int number) {
        if (isFizzBuzz(number)) {
            return new FizzBuzzValue(number, "FizzBuzz");
        }
        return new FizzBuzzValue(number, Integer.toString(number));
    }
}
