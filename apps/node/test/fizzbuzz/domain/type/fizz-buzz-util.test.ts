import { describe, expect, test } from "vitest";
import {
  compose,
  FizzBuzzValue,
  isBuzz,
  isFizz,
  isFizzBuzz,
  isFizzBuzzValue,
  isNumber,
  pipe,
} from "../../../../src/fizzbuzz/index";

describe("fizz-buzz-util", () => {
  describe("関数合成", () => {
    test("compose は右から左に適用する", () => {
      const double = (n: number): number => n * 2;
      const increment = (n: number): number => n + 1;
      const fn = compose(double, increment);

      expect(fn(3)).toBe(8);
    });

    test("pipe は左から右に適用する", () => {
      const double = (n: number): number => n * 2;
      const increment = (n: number): number => n + 1;
      const fn = pipe(double, increment);

      expect(fn(3)).toBe(7);
    });
  });

  describe("フィルタ関数", () => {
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
      expect(isNumber(new FizzBuzzValue("7", 7))).toBe(true);
      expect(isNumber(new FizzBuzzValue("Fizz", 3))).toBe(false);
    });
  });

  describe("型ガード", () => {
    test("isFizzBuzzValue は FizzBuzzValue インスタンスで true を返す", () => {
      expect(isFizzBuzzValue(new FizzBuzzValue("Fizz", 3))).toBe(true);
    });

    test("isFizzBuzzValue は非インスタンスで false を返す", () => {
      expect(isFizzBuzzValue("Fizz")).toBe(false);
      expect(isFizzBuzzValue(null)).toBe(false);
    });
  });
});
