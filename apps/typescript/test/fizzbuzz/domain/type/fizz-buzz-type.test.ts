import { beforeEach, describe, expect, test, vi } from "vitest";
import {
  FizzBuzz,
  FizzBuzzType,
  FizzBuzzTypeName,
  FizzBuzzType01,
  FizzBuzzType02,
  FizzBuzzType03,
} from "../../../../src/fizzbuzz/index.js";

describe("FizzBuzzType", () => {
  describe("タイプ1の場合", () => {
    let fizzbuzz: FizzBuzz;

    beforeEach(() => {
      fizzbuzz = new FizzBuzz(FizzBuzzType.create(FizzBuzzType.TYPE_01));
    });

    test("1を渡したら文字列1を返す", () => {
      expect(fizzbuzz.generate(1).toString()).toBe("1");
    });

    test("3を渡したらFizzを返す", () => {
      expect(fizzbuzz.generate(3).toString()).toBe("Fizz");
    });

    test("5を渡したらBuzzを返す", () => {
      expect(fizzbuzz.generate(5).toString()).toBe("Buzz");
    });

    test("15を渡したらFizzBuzzを返す", () => {
      expect(fizzbuzz.generate(15).toString()).toBe("FizzBuzz");
    });

    test("1から100までのFizzBuzzを生成する", () => {
      const result = fizzbuzz.generateList(100);
      const values = result.toStringArray();

      expect(result.size).toBe(100);
      expect(values[0]).toBe("1");
      expect(values[1]).toBe("2");
      expect(values[2]).toBe("Fizz");
      expect(values[3]).toBe("4");
      expect(values[4]).toBe("Buzz");
      expect(values[14]).toBe("FizzBuzz");
      expect(values[99]).toBe("Buzz");
    });

    test("プリントする", () => {
      const logSpy = vi.spyOn(console, "log").mockImplementation(() => {});

      fizzbuzz.printFizzBuzz(15);

      expect(logSpy).toHaveBeenCalledTimes(15);
      expect(logSpy).toHaveBeenNthCalledWith(1, "1");
      expect(logSpy).toHaveBeenNthCalledWith(3, "Fizz");
      expect(logSpy).toHaveBeenNthCalledWith(5, "Buzz");
      expect(logSpy).toHaveBeenNthCalledWith(15, "FizzBuzz");

      logSpy.mockRestore();
    });
  });

  describe("タイプ2の場合", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_02);

    test("3を渡したら文字列3を返す", () => {
      expect(type.generate(3).toString()).toBe("3");
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

    test("15を渡したらFizzBuzzを返す", () => {
      expect(type.generate(15).toString()).toBe("FizzBuzz");
    });
  });

  describe("ファクトリメソッド", () => {
    test("TYPE_01 を指定すると FizzBuzzType01 が返る", () => {
      expect(FizzBuzzType.create(FizzBuzzType.TYPE_01)).toBeInstanceOf(
        FizzBuzzType01,
      );
    });

    test("TYPE_02 を指定すると FizzBuzzType02 が返る", () => {
      expect(FizzBuzzType.create(FizzBuzzType.TYPE_02)).toBeInstanceOf(
        FizzBuzzType02,
      );
    });

    test("TYPE_03 を指定すると FizzBuzzType03 が返る", () => {
      expect(FizzBuzzType.create(FizzBuzzType.TYPE_03)).toBeInstanceOf(
        FizzBuzzType03,
      );
    });

    test("未定義のタイプを指定するとエラーが発生する", () => {
      expect(() => FizzBuzzType.create(99)).toThrow("未定義のタイプ: 99");
    });
  });

  describe("型安全なファクトリメソッド", () => {
    test("FizzBuzzTypeName.TYPE_01 を指定すると FizzBuzzType01 が返る", () => {
      const type = FizzBuzzType.tryCreate(FizzBuzzTypeName.TYPE_01);

      expect(type).toBeInstanceOf(FizzBuzzType01);
    });

    test("FizzBuzzTypeName.TYPE_02 を指定すると FizzBuzzType02 が返る", () => {
      const type = FizzBuzzType.tryCreate(FizzBuzzTypeName.TYPE_02);

      expect(type).toBeInstanceOf(FizzBuzzType02);
    });

    test("FizzBuzzTypeName.TYPE_03 を指定すると FizzBuzzType03 が返る", () => {
      const type = FizzBuzzType.tryCreate(FizzBuzzTypeName.TYPE_03);

      expect(type).toBeInstanceOf(FizzBuzzType03);
    });
  });

  describe("デフォルトコンストラクタ", () => {
    test("引数なしで生成するとタイプ1として動作する", () => {
      const fizzbuzz = new FizzBuzz();

      expect(fizzbuzz.generate(3).toString()).toBe("Fizz");
      expect(fizzbuzz.generate(15).toString()).toBe("FizzBuzz");
    });
  });
});
