import { FizzBuzzValue } from "../model/fizz-buzz-value.js";
import type { FizzBuzzType } from "./fizz-buzz-type.js";

export class FizzBuzzType02 implements FizzBuzzType {
  generate(number: number): FizzBuzzValue {
    return new FizzBuzzValue(number.toString(), number);
  }
}
