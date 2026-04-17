import { describe, expect, test } from "vitest";
import { FizzBuzzValue } from "../../../../src/fizzbuzz/index.js";

describe("FizzBuzzValue", () => {
  test("値と数値を保持する", () => {
    const value = new FizzBuzzValue("Fizz", 3);

    expect(value.value).toBe("Fizz");
    expect(value.number).toBe(3);
  });

  test("toString は値を返す", () => {
    const value = new FizzBuzzValue("Buzz", 5);

    expect(value.toString()).toBe("Buzz");
  });

  test("同じ値と数値の場合 equals は true", () => {
    const v1 = new FizzBuzzValue("Fizz", 3);
    const v2 = new FizzBuzzValue("Fizz", 3);

    expect(v1.equals(v2)).toBe(true);
  });

  test("異なる値の場合 equals は false", () => {
    const v1 = new FizzBuzzValue("Fizz", 3);
    const v2 = new FizzBuzzValue("Buzz", 5);

    expect(v1.equals(v2)).toBe(false);
  });
});
