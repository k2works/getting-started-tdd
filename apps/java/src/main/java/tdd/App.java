package tdd;

import tdd.fizzbuzz.application.FizzBuzzListCommand;
import tdd.fizzbuzz.application.FizzBuzzValueCommand;
import tdd.fizzbuzz.domain.model.FizzBuzzList;
import tdd.fizzbuzz.domain.model.FizzBuzzValue;
import tdd.fizzbuzz.domain.type.FizzBuzzType;

public class App {
    private static final int MAX_NUMBER = 100;
    private static final int SAMPLE_NUMBER = 15;

    // コマンドラインの入口として標準出力へ結果を表示する
    @SuppressWarnings("PMD.SystemPrintln")
    public static void main(String[] args) {
        FizzBuzzType type = FizzBuzzType.create(1);

        FizzBuzzValueCommand valueCommand = new FizzBuzzValueCommand(type);
        FizzBuzzValue value = valueCommand.execute(SAMPLE_NUMBER);
        System.out.println(value);

        FizzBuzzListCommand listCommand = new FizzBuzzListCommand(type);
        FizzBuzzList list = listCommand.executeList(MAX_NUMBER);
        for (FizzBuzzValue item : list.getValues()) {
            System.out.println(item.getValue());
        }
    }
}
