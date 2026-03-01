import { describe, expect, test } from "vitest";
import {
  FizzBuzzType,
  FizzBuzzType01,
  FizzBuzzType02,
  FizzBuzzType03,
} from "../../../../src/fizzbuzz/index";

describe("FizzBuzzType", () => {
  describe("タイプ1の場合", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);

    test("1を渡したら文字列1を返す", () => {
      expect(type.generate(1).toString()).toBe("1");
    });

    test("2を渡したら文字列2を返す", () => {
      expect(type.generate(2).toString()).toBe("2");
    });

    test("3を渡したらFizzを返す", () => {
      expect(type.generate(3).toString()).toBe("Fizz");
    });

    test("5を渡したらBuzzを返す", () => {
      expect(type.generate(5).toString()).toBe("Buzz");
    });

    test("15を渡したらFizzBuzzを返す", () => {
      expect(type.generate(15).toString()).toBe("FizzBuzz");
    });
  });

  describe("タイプ2の場合", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_02);

    test("3を渡したら文字列3を返す", () => {
      expect(type.generate(3).toString()).toBe("3");
    });

    test("5を渡したら文字列5を返す", () => {
      expect(type.generate(5).toString()).toBe("5");
    });

    test("15を渡したら文字列15を返す", () => {
      expect(type.generate(15).toString()).toBe("15");
    });
  });

  describe("タイプ3の場合", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_03);

    test("3を渡したら文字列3を返す", () => {
      expect(type.generate(3).toString()).toBe("3");
    });

    test("5を渡したら文字列5を返す", () => {
      expect(type.generate(5).toString()).toBe("5");
    });

    test("15を渡したらFizzBuzzを返す", () => {
      expect(type.generate(15).toString()).toBe("FizzBuzz");
    });
  });

  describe("ファクトリメソッド", () => {
    test("TYPE_01 を指定すると FizzBuzzType01 が返る", () => {
      const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
      expect(type).toBeInstanceOf(FizzBuzzType01);
    });

    test("TYPE_02 を指定すると FizzBuzzType02 が返る", () => {
      const type = FizzBuzzType.create(FizzBuzzType.TYPE_02);
      expect(type).toBeInstanceOf(FizzBuzzType02);
    });

    test("TYPE_03 を指定すると FizzBuzzType03 が返る", () => {
      const type = FizzBuzzType.create(FizzBuzzType.TYPE_03);
      expect(type).toBeInstanceOf(FizzBuzzType03);
    });

    test("未定義のタイプを指定するとエラーが発生する", () => {
      expect(() => FizzBuzzType.create(99)).toThrow("未定義のタイプ: 99");
    });
  });

  describe("デフォルトファクトリ", () => {
    test("引数なしの場合は TYPE_01 を返す", () => {
      const type = FizzBuzzType.create();
      expect(type).toBeInstanceOf(FizzBuzzType01);
      expect(type.generate(3).toString()).toBe("Fizz");
      expect(type.generate(5).toString()).toBe("Buzz");
      expect(type.generate(15).toString()).toBe("FizzBuzz");
    });
  });
});
