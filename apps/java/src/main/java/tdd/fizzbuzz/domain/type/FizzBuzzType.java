package tdd.fizzbuzz.domain.type;

import java.util.Optional;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public abstract class FizzBuzzType {

    private static final int TYPE_1 = 1;
    private static final int TYPE_2 = 2;
    private static final int TYPE_3 = 3;
    protected static final int FIZZ_NUMBER = 3;
    protected static final int BUZZ_NUMBER = 5;

    public abstract FizzBuzzValue generate(int number);

    protected boolean isFizz(int number) {
        return number % FIZZ_NUMBER == 0;
    }

    protected boolean isBuzz(int number) {
        return number % BUZZ_NUMBER == 0;
    }

    protected boolean isFizzBuzz(int number) {
        return isFizz(number) && isBuzz(number);
    }

    public static FizzBuzzType create(int typeCode) {
        switch (typeCode) {
            case TYPE_1:
                return new FizzBuzzType01();
            case TYPE_2:
                return new FizzBuzzType02();
            case TYPE_3:
                return new FizzBuzzType03();
            default:
                throw new IllegalArgumentException("該当するタイプは存在しません");
        }
    }

    public static Optional<FizzBuzzType> createOptional(int typeCode) {
        switch (typeCode) {
            case TYPE_1:
                return Optional.of(new FizzBuzzType01());
            case TYPE_2:
                return Optional.of(new FizzBuzzType02());
            case TYPE_3:
                return Optional.of(new FizzBuzzType03());
            default:
                return Optional.empty();
        }
    }

    public static FizzBuzzType create(FizzBuzzTypeName name) {
        return create(name.getCode());
    }
}
