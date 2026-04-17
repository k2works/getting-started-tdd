import { FizzBuzzList } from "../domain/model/fizz-buzz-list.js";
import { FizzBuzzType } from "../domain/type/fizz-buzz-type.js";
import type { FizzBuzzCommand } from "./fizz-buzz-command.js";

export class FizzBuzzListCommand implements FizzBuzzCommand {
  private readonly _type: FizzBuzzType;
  private readonly _count: number;

  constructor(type: FizzBuzzType, count: number) {
    this._type = type;
    this._count = count;
  }

  execute(): FizzBuzzList {
    return Array.from({ length: this._count }, (_, index) => index + 1).reduce(
      (list, number) => list.add(this._type.generate(number)),
      new FizzBuzzList(),
    );
  }
}
