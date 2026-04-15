package tdd.fizzbuzz;

public abstract class FizzBuzzType {

    protected static final int FIZZ_NUMBER = 3;
    protected static final int BUZZ_NUMBER = 5;

    public abstract String generate(int number);

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
            case 1:
                return new FizzBuzzType01();
            case 2:
                return new FizzBuzzType02();
            case 3:
                return new FizzBuzzType03();
            default:
                throw new IllegalArgumentException("該当するタイプは存在しません");
        }
    }
}
