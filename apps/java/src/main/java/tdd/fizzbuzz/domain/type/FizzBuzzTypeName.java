package tdd.fizzbuzz.domain.type;

public enum FizzBuzzTypeName {
    STANDARD(1),
    NUMBER_ONLY(2),
    FIZZBUZZ_ONLY(3);

    private final int code;

    FizzBuzzTypeName(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
