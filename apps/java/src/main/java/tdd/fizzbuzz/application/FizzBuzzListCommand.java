package tdd.fizzbuzz.application;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;
import tdd.fizzbuzz.domain.type.FizzBuzzType;

public final class FizzBuzzListCommand implements FizzBuzzCommand {

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
        List<FizzBuzzValue> values = IntStream.rangeClosed(1, count)
                .mapToObj(type::generate)
                .collect(Collectors.toList());
        return new FizzBuzzList(values);
    }
}
