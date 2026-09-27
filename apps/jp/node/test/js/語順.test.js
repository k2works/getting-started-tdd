import { describe, expect, it } from "vitest";
import { 装飾 } from "../../src/js/パイプライン.js";
import { して, それ, 日本語 } from "../../src/js/語順.js";
import { FizzBuzz変換 } from "../../src/js/変換.js";

describe("語順の再現", () => {
  it("3をFizzBuzz変換するとFizzを返す（メソッドチェーン）", () => {
    expect(それ(3).を(FizzBuzz変換).値).toBe("Fizz");
  });

  it("15をFizzBuzz変換して装飾して戻す（メソッドチェーン）", () => {
    expect(それ(15).を(FizzBuzz変換).して(装飾).戻す()).toBe("[FizzBuzz]");
  });

  it("FizzBuzz変換して装飾する関数を合成する", () => {
    expect(して(FizzBuzz変換, 装飾)(3)).toBe("[Fizz]");
  });

  it("助詞を置いてSOV順で書ける（タグ付きテンプレート）", () => {
    expect(日本語`${3}を${FizzBuzz変換}`).toBe("Fizz");
    expect(日本語`${5}を${FizzBuzz変換}して${装飾}`).toBe("[Buzz]");
  });

  it("知らない助詞はエラーになる", () => {
    expect(() => 日本語`${3}が${FizzBuzz変換}`).toThrow(
      "助詞「が」には対応していません",
    );
  });
});
