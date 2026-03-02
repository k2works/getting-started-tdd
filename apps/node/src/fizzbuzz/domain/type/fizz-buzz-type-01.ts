import { FizzBuzzValue } from "../model/fizz-buzz-value.js";
import type { FizzBuzzType } from "./fizz-buzz-type.js";

export class FizzBuzzType01 implements FizzBuzzType {
  generate(number: number): FizzBuzzValue {
    if (number % 15 === 0) {
      return new FizzBuzzValue("FizzBuzz", number);
    }
    if (number % 3 === 0) {
      return new FizzBuzzValue("Fizz", number);
    }
    if (number % 5 === 0) {
      return new FizzBuzzValue("Buzz", number);
    }

    return new FizzBuzzValue(number.toString(), number);
  }
}
