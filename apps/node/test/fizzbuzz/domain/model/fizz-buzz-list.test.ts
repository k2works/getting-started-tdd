import { describe, expect, test } from "vitest";
import { FizzBuzzList, FizzBuzzValue } from "../../../../src/fizzbuzz/index";

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
});
