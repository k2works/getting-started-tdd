import { FizzBuzzList } from "../domain/model/fizz-buzz-list.js";
import { FizzBuzzValue } from "../domain/model/fizz-buzz-value.js";

export interface FizzBuzzCommand {
  execute(): FizzBuzzValue | FizzBuzzList;
}
