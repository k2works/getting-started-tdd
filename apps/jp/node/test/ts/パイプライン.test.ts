import { describe, expect, it } from "vitest";
import { パイプライン処理, 装飾 } from "../../src/ts/パイプライン";

describe("パイプライン", () => {
  it("装飾すると角括弧で囲む", () => {
    expect(装飾("Fizz")).toBe("[Fizz]");
  });

  it("5までのパイプライン処理", () => {
    expect(パイプライン処理(5)).toEqual([
      "[1]",
      "[2]",
      "[Fizz]",
      "[4]",
      "[Buzz]",
    ]);
  });
});
