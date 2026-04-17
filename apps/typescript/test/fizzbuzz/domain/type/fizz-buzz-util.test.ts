import { describe, expect, test } from "vitest";
import {
  FizzBuzzList,
  FizzBuzzType,
  FizzBuzzValue,
  isBuzz,
  isFizz,
  isFizzBuzz,
  isFizzBuzzList,
  isFizzBuzzValue,
  isNumber,
} from "../../../../src/fizzbuzz/index.js";

describe("型ガード", () => {
  test("isFizzBuzzValue は FizzBuzzValue インスタンスで true を返す", () => {
    expect(isFizzBuzzValue(new FizzBuzzValue("Fizz", 3))).toBe(true);
  });

  test("isFizzBuzzValue は非インスタンスで false を返す", () => {
    expect(isFizzBuzzValue("Fizz")).toBe(false);
    expect(isFizzBuzzValue(null)).toBe(false);
  });

  test("isFizzBuzzList は FizzBuzzList インスタンスで true を返す", () => {
    expect(
      isFizzBuzzList(
        FizzBuzzList.generate(FizzBuzzType.create(FizzBuzzType.TYPE_01), 3),
      ),
    ).toBe(true);
  });

  test("isFizzBuzzList は非インスタンスで false を返す", () => {
    expect(isFizzBuzzList([])).toBe(false);
    expect(isFizzBuzzList(undefined)).toBe(false);
  });
});

describe("述語関数", () => {
  test("isFizz は Fizz のとき true を返す", () => {
    expect(isFizz(new FizzBuzzValue("Fizz", 3))).toBe(true);
    expect(isFizz(new FizzBuzzValue("Buzz", 5))).toBe(false);
  });

  test("isBuzz は Buzz のとき true を返す", () => {
    expect(isBuzz(new FizzBuzzValue("Buzz", 5))).toBe(true);
    expect(isBuzz(new FizzBuzzValue("Fizz", 3))).toBe(false);
  });

  test("isFizzBuzz は FizzBuzz のとき true を返す", () => {
    expect(isFizzBuzz(new FizzBuzzValue("FizzBuzz", 15))).toBe(true);
    expect(isFizzBuzz(new FizzBuzzValue("Fizz", 3))).toBe(false);
  });

  test("isNumber は数値文字列のとき true を返す", () => {
    expect(isNumber(new FizzBuzzValue("1", 1))).toBe(true);
    expect(isNumber(new FizzBuzzValue("Fizz", 3))).toBe(false);
  });
});
