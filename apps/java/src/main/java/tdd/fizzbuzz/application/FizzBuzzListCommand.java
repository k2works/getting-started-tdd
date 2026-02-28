package tdd.fizzbuzz.application;

import java.util.ArrayList;
import java.util.List;

import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;
import tdd.fizzbuzz.domain.type.FizzBuzzType;

public class FizzBuzzListCommand implements FizzBuzzCommand {
    private final FizzBuzzType type;

    public FizzBuzzListCommand(FizzBuzzType type) {
        this.type = type;
    }

    @Override
    public FizzBuzzValue execute(int number) {
        throw new UnsupportedOperationException();
    }

    @Override
    public FizzBuzzList executeList(int count) {
        List<FizzBuzzValue> values = new ArrayList<>();
        for (int i = 1; i <= count; i++) {
            values.add(type.generate(i));
        }
        return new FizzBuzzList(values);
    }
}
