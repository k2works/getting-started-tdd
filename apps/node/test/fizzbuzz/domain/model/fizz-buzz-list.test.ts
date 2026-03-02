import { describe, expect, test } from "vitest";
import {
  FizzBuzzList,
  FizzBuzzType,
  FizzBuzzValue,
  isFizz,
} from "../../../../src/fizzbuzz/index";

describe("FizzBuzzList", () => {
  test("空リストを生成できる", () => {
    const list = new FizzBuzzList();
    expect(list.size).toBe(0);
  });

  test("add で新しいリストを返す（不変）", () => {
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
    for (const v of list) {
      values.push(v.toString());
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
        (v) => new FizzBuzzValue(v.toString().toUpperCase(), v.number),
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
      const filtered = baseList.filter((v) => v.value === "Fizz");
      expect(filtered.toStringArray()).toEqual(["Fizz"]);
    });

    test("filter で数値のみ抽出できる", () => {
      const filtered = baseList.filter((v) => !isNaN(Number(v.value)));
      expect(filtered.toStringArray()).toEqual(["1"]);
    });

    test("reduce で文字列結合できる", () => {
      const reduced = baseList.reduce(
        (acc, v) => `${acc}${acc.length > 0 ? "," : ""}${v.toString()}`,
        "",
      );
      expect(reduced).toBe("1,Fizz,Buzz,FizzBuzz");
    });
  });

  describe("パイプライン処理", () => {
    const type = FizzBuzzType.create(FizzBuzzType.TYPE_01);
    const list = FizzBuzzList.generate(type, 15);

    test("groupBy で値の種類ごとにグループ化する", () => {
      const grouped = list.groupBy((v) => {
        if (v.value === "Fizz") return "Fizz";
        if (v.value === "Buzz") return "Buzz";
        if (v.value === "FizzBuzz") return "FizzBuzz";
        return "number";
      });

      expect(grouped.get("Fizz")?.toStringArray()).toEqual([
        "Fizz",
        "Fizz",
        "Fizz",
        "Fizz",
      ]);
      expect(grouped.get("Buzz")?.toStringArray()).toEqual(["Buzz", "Buzz"]);
      expect(grouped.get("FizzBuzz")?.toStringArray()).toEqual(["FizzBuzz"]);
      expect(grouped.get("number")?.toStringArray()).toEqual([
        "1",
        "2",
        "4",
        "7",
        "8",
        "11",
        "13",
        "14",
      ]);
    });

    test("countBy で種類ごとの出現回数をカウントする", () => {
      const counted = list.countBy((v) => {
        if (v.value === "Fizz") return "Fizz";
        if (v.value === "Buzz") return "Buzz";
        if (v.value === "FizzBuzz") return "FizzBuzz";
        return "number";
      });

      expect(counted.get("Fizz")).toBe(4);
      expect(counted.get("Buzz")).toBe(2);
      expect(counted.get("FizzBuzz")).toBe(1);
      expect(counted.get("number")).toBe(8);
    });

    test("take で先頭 N 件を取得する", () => {
      const taken = list.take(3);
      expect(taken.toStringArray()).toEqual(["1", "2", "Fizz"]);
    });

    test("first で最初の要素を取得する", () => {
      expect(list.first()?.equals(new FizzBuzzValue("1", 1))).toBe(true);
    });

    test("join で文字列結合する", () => {
      expect(list.take(5).join(", ")).toBe("1, 2, Fizz, 4, Buzz");
    });

    test("メソッドチェーンでパイプライン処理する", () => {
      expect(list.filter(isFizz).take(2).join(", ")).toBe("Fizz, Fizz");
    });

    describe("検索メソッド", () => {
      test("find で条件に合う最初の要素を見つける", () => {
        const found = list.find((v) => v.value === "Fizz");
        expect(found?.equals(new FizzBuzzValue("Fizz", 3))).toBe(true);
      });

      test("find で見つからない場合 undefined を返す", () => {
        const found = list.find((v) => v.value === "NotFound");
        expect(found).toBeUndefined();
      });

      test("some で条件に合う要素があるか判定する", () => {
        expect(list.some((v) => v.value === "Buzz")).toBe(true);
      });

      test("every で全要素が条件を満たすか判定する", () => {
        expect(list.every((v) => !isNaN(Number(v.value)))).toBe(false);
      });
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
});
