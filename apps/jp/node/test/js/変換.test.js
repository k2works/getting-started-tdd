import { describe, expect, it } from "vitest";
import { FizzBuzz変換, FizzBuzz配列作成 } from "../../src/js/変換.js";

describe("FizzBuzz変換", () => {
  it("3を渡したらFizzを返す", () => {
    expect(FizzBuzz変換(3)).toBe("Fizz");
  });

  it("5を渡したらBuzzを返す", () => {
    expect(FizzBuzz変換(5)).toBe("Buzz");
  });

  it("15を渡したらFizzBuzzを返す", () => {
    expect(FizzBuzz変換(15)).toBe("FizzBuzz");
  });

  it("1を渡したら文字列1を返す", () => {
    expect(FizzBuzz変換(1)).toBe("1");
  });

  it("2を渡したら文字列2を返す", () => {
    expect(FizzBuzz変換(2)).toBe("2");
  });
});

describe("FizzBuzz配列作成", () => {
  it("15まで作ると15件になる", () => {
    expect(FizzBuzz配列作成(15)).toHaveLength(15);
  });

  it("15まで作った配列の並び", () => {
    expect(FizzBuzz配列作成(15).join(",")).toBe(
      "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz",
    );
  });
});
