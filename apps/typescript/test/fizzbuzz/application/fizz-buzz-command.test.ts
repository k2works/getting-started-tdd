import { describe, expect, test } from "vitest";
import {
  FizzBuzzListCommand,
  FizzBuzzType,
  FizzBuzzValueCommand,
} from "../../../src/fizzbuzz/index.js";

describe("FizzBuzzCommand", () => {
  test("FizzBuzzValueCommand は単一の値を生成する", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const command = new FizzBuzzValueCommand(type, 3);
    const result = command.execute();

    expect(result.toString()).toBe("Fizz");
  });

  test("FizzBuzzListCommand はリストを生成する", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const command = new FizzBuzzListCommand(type, 100);
    const result = command.execute();
    const values = result.toStringArray();

    expect(result.size).toBe(100);
    expect(values[2]).toBe("Fizz");
    expect(values[4]).toBe("Buzz");
    expect(values[14]).toBe("FizzBuzz");
  });
});
