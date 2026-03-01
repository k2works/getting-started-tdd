import { FizzBuzz } from "../src/fizzbuzz";

describe("FizzBuzz", () => {
  let fizzbuzz: FizzBuzz;

  beforeEach(() => {
    fizzbuzz = new FizzBuzz();
  });

  test("1を渡したら文字列1を返す", () => {
    expect(fizzbuzz.generate(1)).toBe("1");
  });

  test("2を渡したら文字列2を返す", () => {
    expect(fizzbuzz.generate(2)).toBe("2");
  });

  test("3を渡したらFizzを返す", () => {
    expect(fizzbuzz.generate(3)).toBe("Fizz");
  });

  test("5を渡したらBuzzを返す", () => {
    expect(fizzbuzz.generate(5)).toBe("Buzz");
  });

  test("15を渡したらFizzBuzzを返す", () => {
    expect(fizzbuzz.generate(15)).toBe("FizzBuzz");
  });

  test("generateList(100) は FizzBuzz の配列を返す", () => {
    const result = fizzbuzz.generateList(100);

    expect(result).toHaveLength(100);
    expect(result[0]).toBe("1");
    expect(result[1]).toBe("2");
    expect(result[2]).toBe("Fizz");
    expect(result[3]).toBe("4");
    expect(result[4]).toBe("Buzz");
    expect(result[14]).toBe("FizzBuzz");
    expect(result[99]).toBe("Buzz");
  });
});
