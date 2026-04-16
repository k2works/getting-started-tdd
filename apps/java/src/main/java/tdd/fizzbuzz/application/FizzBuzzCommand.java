package tdd.fizzbuzz.application;

import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public interface FizzBuzzCommand {

    FizzBuzzValue execute(int number);

    FizzBuzzList executeList(int count);
}
