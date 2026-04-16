package tdd.fizzbuzz.domain.type;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public final class FizzBuzzType02 extends FizzBuzzType {

    @Override
    public FizzBuzzValue generate(int number) {
        return new FizzBuzzValue(number, Integer.toString(number));
    }
}
