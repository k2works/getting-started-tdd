package tdd.fizzbuzz.domain.type;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public class FizzBuzzType02 extends FizzBuzzType {
    @Override
    public FizzBuzzValue generate(int number) {
        return new FizzBuzzValue(number, String.valueOf(number));
    }
}
