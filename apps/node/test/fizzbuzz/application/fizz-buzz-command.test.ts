import { describe, expect, test } from "vitest";
import {
  FizzBuzzListCommand,
  FizzBuzzType,
  FizzBuzzValueCommand,
} from "../../../src/fizzbuzz/index";

describe("FizzBuzzCommand", () => {
  test("FizzBuzzValueCommand は単一の値を生成する", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const command = new FizzBuzzValueCommand(type, 3);
    const result = command.execute();
    expect(result.toString()).toBe("Fizz");
  });

  test("FizzBuzzValueCommand は number を保持した値を生成する", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const command = new FizzBuzzValueCommand(type, 15);
    const result = command.execute();
    expect(result.number).toBe(15);
  });

  test("FizzBuzzListCommand はリストを生成する", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const command = new FizzBuzzListCommand(type, 100);
    const result = command.execute();
    const arr = result.toStringArray();

    expect(result.size).toBe(100);
    expect(arr[0]).toBe("1");
    expect(arr[2]).toBe("Fizz");
    expect(arr[4]).toBe("Buzz");
    expect(arr[14]).toBe("FizzBuzz");
    expect(arr[99]).toBe("Buzz");
  });
});
