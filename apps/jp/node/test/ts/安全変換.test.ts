import { describe, expect, it } from "vitest";
import { 安全変換 } from "../../src/ts/安全変換";

describe("安全変換", () => {
  it("正の数は成功になる", () => {
    expect(安全変換(3)).toEqual({ 成功: true, 値: "Fizz" });
  });

  it("0は失敗になる", () => {
    expect(安全変換(0)).toEqual({
      成功: false,
      エラー: "正の数を指定してください: 0",
    });
  });

  it("数値でなければ失敗になる", () => {
    expect(安全変換("a")).toEqual({
      成功: false,
      エラー: "数値を指定してください: a",
    });
  });
});
