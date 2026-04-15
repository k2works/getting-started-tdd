package tdd.fizzbuzz;

import java.util.ArrayList;
import java.util.List;

public final class FizzBuzz {

    public static final int MAX_NUMBER = 100;
    private static final int TYPE_1 = 1;
    private static final int TYPE_2 = 2;
    private static final int TYPE_3 = 3;

    private final FizzBuzzType type;

    public FizzBuzz() {
        this(TYPE_1);
    }

    public FizzBuzz(int type) {
        this.type = createType(type);
    }

    public FizzBuzz(FizzBuzzType type) {
        this.type = type;
    }

    public String generate(int number) {
        return type.generate(number);
    }

    public List<String> generateList(int count) {
        List<String> result = new ArrayList<>();
        for (int i = 1; i <= count; i++) {
            result.add(generate(i));
        }
        return result;
    }

    public void printFizzBuzz(int count) {
        List<String> result = generateList(count);
        for (String value : result) {
            System.out.println(value);
        }
    }

    private static FizzBuzzType createType(int typeCode) {
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
}
