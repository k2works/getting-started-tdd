import { FizzBuzzType } from "../domain/type/fizz-buzz-type.js";
import { FizzBuzzValue } from "../domain/model/fizz-buzz-value.js";
import { FizzBuzzCommand } from "./fizz-buzz-command.js";

export class FizzBuzzValueCommand implements FizzBuzzCommand {
  private readonly _type: FizzBuzzType;
  private readonly _number: number;

  constructor(type: FizzBuzzType, number: number) {
    this._type = type;
    this._number = number;
  }

  execute(): FizzBuzzValue {
    return this._type.generate(this._number);
  }
}
