import { describe, expect, test } from "vitest";
import {
  FizzBuzzList,
  FizzBuzzType,
  FizzBuzzValue,
  isFizz,
} from "../../../../src/fizzbuzz/index.js";

describe("FizzBuzzList", () => {
  test("空リストを生成できる", () => {
    const list = new FizzBuzzList();

    expect(list.size).toBe(0);
  });

  test("add で新しいリストを返す", () => {
    const list = new FizzBuzzList();
    const newList = list.add(new FizzBuzzValue("1", 1));

    expect(list.size).toBe(0);
    expect(newList.size).toBe(1);
  });

  test("toStringArray で文字列配列を返す", () => {
    let list = new FizzBuzzList();
    list = list.add(new FizzBuzzValue("1", 1));
    list = list.add(new FizzBuzzValue("2", 2));
    list = list.add(new FizzBuzzValue("Fizz", 3));

    expect(list.toStringArray()).toEqual(["1", "2", "Fizz"]);
  });

  test("イテレータで反復できる", () => {
    let list = new FizzBuzzList();
    list = list.add(new FizzBuzzValue("Fizz", 3));
    list = list.add(new FizzBuzzValue("Buzz", 5));

    const values: string[] = [];
    for (const value of list) {
      values.push(value.toString());
    }

    expect(values).toEqual(["Fizz", "Buzz"]);
  });

  describe("関数型メソッド", () => {
    const baseList = new FizzBuzzList([
      new FizzBuzzValue("1", 1),
      new FizzBuzzValue("Fizz", 3),
      new FizzBuzzValue("Buzz", 5),
      new FizzBuzzValue("FizzBuzz", 15),
    ]);

    test("map で値を変換する", () => {
      const mapped = baseList.map(
        (value) =>
          new FizzBuzzValue(value.toString().toUpperCase(), value.number),
      );

      expect(mapped.toStringArray()).toEqual(["1", "FIZZ", "BUZZ", "FIZZBUZZ"]);
      expect(baseList.toStringArray()).toEqual([
        "1",
        "Fizz",
        "Buzz",
        "FizzBuzz",
      ]);
    });

    test("filter で Fizz のみ抽出できる", () => {
      const filtered = baseList.filter(isFizz);

      expect(filtered.toStringArray()).toEqual(["Fizz"]);
    });

    test("reduce で文字列結合できる", () => {
      const reduced = baseList.reduce(
        (acc, value) => `${acc}${acc.length > 0 ? "," : ""}${value.toString()}`,
        "",
      );

      expect(reduced).toBe("1,Fizz,Buzz,FizzBuzz");
    });
  });

  describe("パイプライン処理", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const list = FizzBuzzList.generate(type, 15);

    test("groupBy で値の種類ごとにグループ化する", () => {
      const groups = list.groupBy((value) => {
        if (value.value === "FizzBuzz") return "FizzBuzz";
        if (value.value === "Fizz") return "Fizz";
        if (value.value === "Buzz") return "Buzz";
        return "number";
      });

      expect(groups.get("Fizz")?.size).toBe(4);
      expect(groups.get("Buzz")?.size).toBe(2);
      expect(groups.get("FizzBuzz")?.size).toBe(1);
      expect(groups.get("number")?.size).toBe(8);
    });

    test("countBy で種類ごとの出現回数をカウントする", () => {
      const counts = list.countBy((value) => {
        if (value.value === "FizzBuzz") return "FizzBuzz";
        if (value.value === "Fizz") return "Fizz";
        if (value.value === "Buzz") return "Buzz";
        return "number";
      });

      expect(counts.get("Fizz")).toBe(4);
      expect(counts.get("Buzz")).toBe(2);
      expect(counts.get("FizzBuzz")).toBe(1);
      expect(counts.get("number")).toBe(8);
    });

    test("take で先頭 N 件を取得する", () => {
      expect(list.take(3).toStringArray()).toEqual(["1", "2", "Fizz"]);
    });

    test("first で最初の要素を取得する", () => {
      expect(list.first()?.toString()).toBe("1");
    });

    test("join で文字列結合する", () => {
      expect(list.take(5).join(", ")).toBe("1, 2, Fizz, 4, Buzz");
    });

    test("メソッドチェーンでパイプライン処理する", () => {
      const result = list.filter(isFizz).take(2).join(", ");

      expect(result).toBe("Fizz, Fizz");
    });
  });

  describe("静的生成メソッド", () => {
    test("generate でリストを生成する", () => {
      const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
      const list = FizzBuzzList.generate(type, 15);

      expect(list.size).toBe(15);
      expect(list.first()?.toString()).toBe("1");
    });
  });

  describe("検索メソッド", () => {
    const list = FizzBuzzList.generate(
      FizzBuzzType.create(FizzBuzzType.TYPE_01),
      15,
    );

    test("find で条件に合う最初の要素を見つける", () => {
      const result = list.find((value) => value.value === "Fizz");

      expect(result?.toString()).toBe("Fizz");
    });

    test("find で見つからない場合 undefined を返す", () => {
      const result = list.find((value) => value.value === "NotExist");

      expect(result).toBeUndefined();
    });

    test("some で条件に合う要素があるか判定する", () => {
      expect(list.some((value) => value.value === "Buzz")).toBe(true);
      expect(list.some((value) => value.value === "NotExist")).toBe(false);
    });

    test("every で全要素が条件を満たすか判定する", () => {
      const numberList = FizzBuzzList.generate(
        FizzBuzzType.create(FizzBuzzType.TYPE_02),
        5,
      );

      expect(
        numberList.every((value) => !Number.isNaN(Number(value.value))),
      ).toBe(true);
      expect(list.every((value) => !Number.isNaN(Number(value.value)))).toBe(
        false,
      );
    });
  });
});
