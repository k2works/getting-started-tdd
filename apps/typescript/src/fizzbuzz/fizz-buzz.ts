import { FizzBuzzListCommand } from "./application/fizz-buzz-list-command.js";
import { FizzBuzzValueCommand } from "./application/fizz-buzz-value-command.js";
import { FizzBuzzList } from "./domain/model/fizz-buzz-list.js";
import { FizzBuzzValue } from "./domain/model/fizz-buzz-value.js";
import { FizzBuzzType } from "./domain/type/fizz-buzz-type.js";
import { FizzBuzzType01 } from "./domain/type/fizz-buzz-type-01.js";

export class FizzBuzz {
  private readonly _type: FizzBuzzType;

  constructor(type?: FizzBuzzType) {
    this._type = type ?? new FizzBuzzType01();
  }

  get type(): FizzBuzzType {
    return this._type;
  }

  generate(number: number): FizzBuzzValue {
    return new FizzBuzzValueCommand(this._type, number).execute();
  }

  generateList(count: number): FizzBuzzList {
    return new FizzBuzzListCommand(this._type, count).execute();
  }

  printFizzBuzz(count: number): void {
    for (const value of this.generateList(count)) {
      console.log(value.toString());
    }
  }
}
