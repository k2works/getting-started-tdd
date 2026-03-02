package tdd.fizzbuzz.domain.type;

import java.util.Optional;

import tdd.fizzbuzz.domain.model.FizzBuzzValue;

public abstract class FizzBuzzType {

    private static final int TYPE_CODE_01 = 1;
    private static final int TYPE_CODE_02 = 2;
    private static final int TYPE_CODE_03 = 3;
    protected static final int FIZZ_NUMBER = 3;
    protected static final int BUZZ_NUMBER = 5;

    public abstract FizzBuzzValue generate(int number);

    public static FizzBuzzType create(int type) {
        switch (type) {
            case TYPE_CODE_01:
                return new FizzBuzzType01();
            case TYPE_CODE_02:
                return new FizzBuzzType02();
            case TYPE_CODE_03:
                return new FizzBuzzType03();
            default:
                throw new IllegalArgumentException("該当するタイプは存在しません");
        }
    }

    public static Optional<FizzBuzzType> createOptional(int type) {
        switch (type) {
            case TYPE_CODE_01:
                return Optional.of(new FizzBuzzType01());
            case TYPE_CODE_02:
                return Optional.of(new FizzBuzzType02());
            case TYPE_CODE_03:
                return Optional.of(new FizzBuzzType03());
            default:
                return Optional.empty();
        }
    }

    public static FizzBuzzType create(FizzBuzzTypeName name) {
        return create(name.getCode());
    }

    protected boolean isFizz(int number) {
        return number % FIZZ_NUMBER == 0;
    }

    protected boolean isBuzz(int number) {
        return number % BUZZ_NUMBER == 0;
    }

    protected boolean isFizzBuzz(int number) {
        return isFizz(number) && isBuzz(number);
    }
}
