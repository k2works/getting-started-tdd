package tdd.fizzbuzz.application;

import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;
import tdd.fizzbuzz.domain.type.FizzBuzzType;

public class FizzBuzzValueCommand implements FizzBuzzCommand {
    private final FizzBuzzType type;

    public FizzBuzzValueCommand(FizzBuzzType type) {
        this.type = type;
    }

    @Override
    public FizzBuzzValue execute(int number) {
        return type.generate(number);
    }

    @Override
    public FizzBuzzList executeList(int count) {
        throw new UnsupportedOperationException();
    }
}
