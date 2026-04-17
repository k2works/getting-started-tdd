import { FizzBuzzValue } from "../model/fizz-buzz-value.js";
import type { FizzBuzzType } from "./fizz-buzz-type.js";

export class FizzBuzzType03 implements FizzBuzzType {
  generate(number: number): FizzBuzzValue {
    if (number % 15 === 0) {
      return new FizzBuzzValue("FizzBuzz", number);
    }
    return new FizzBuzzValue(number.toString(), number);
  }
}
