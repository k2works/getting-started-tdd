package tdd.fizzbuzz.domain.model;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.function.Function;
import java.util.stream.Collectors;

public final class FizzBuzzList {

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

    public FizzBuzzList filter(Predicate<FizzBuzzValue> predicate) {
        List<FizzBuzzValue> filtered = values.stream()
                .filter(predicate)
                .collect(Collectors.toList());
        return new FizzBuzzList(filtered);
    }

    public Optional<FizzBuzzValue> findFirst(Predicate<FizzBuzzValue> predicate) {
        return values.stream()
                .filter(predicate)
                .findFirst();
    }

    public <R> List<R> map(Function<FizzBuzzValue, R> mapper) {
        return values.stream()
                .map(mapper)
                .collect(Collectors.toList());
    }

    public List<String> toStringValues() {
        return values.stream()
                .map(FizzBuzzValue::getValue)
                .collect(Collectors.toList());
    }

    public Map<String, List<FizzBuzzValue>> groupByValue() {
        return values.stream()
                .collect(Collectors.groupingBy(
                        FizzBuzzValue::getValue,
                        LinkedHashMap::new,
                        Collectors.toList()));
    }

    public Map<String, Long> countByValue() {
        return values.stream()
                .collect(Collectors.groupingBy(
                        FizzBuzzValue::getValue,
                        LinkedHashMap::new,
                        Collectors.counting()));
    }

    public String joining(String delimiter) {
        return values.stream()
                .map(FizzBuzzValue::getValue)
                .collect(Collectors.joining(delimiter));
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
