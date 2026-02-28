package tdd.fizzbuzz.domain.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class FizzBuzzList {
    private final List<FizzBuzzValue> values;

    public FizzBuzzList(List<FizzBuzzValue> values) {
        this.values = new ArrayList<>(values);
    }

    public List<FizzBuzzValue> getValues() {
        return new ArrayList<>(values);
    }

    public FizzBuzzValue get(int index) {
        return values.get(index);
    }

    public int size() {
        return values.size();
    }

    public FizzBuzzList add(List<FizzBuzzValue> newValues) {
        List<FizzBuzzValue> combined = new ArrayList<>(values);
        combined.addAll(newValues);
        return new FizzBuzzList(combined);
    }

    @Override
    public String toString() {
        return values.toString();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        FizzBuzzList that = (FizzBuzzList) obj;
        return Objects.equals(values, that.values);
    }

    @Override
    public int hashCode() {
        return Objects.hash(values);
    }
}
