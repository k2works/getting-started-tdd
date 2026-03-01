import { FizzBuzzList } from "../domain/model/fizz-buzz-list.js";
import { FizzBuzzType } from "../domain/type/fizz-buzz-type.js";
import { FizzBuzzCommand } from "./fizz-buzz-command.js";

export class FizzBuzzListCommand implements FizzBuzzCommand {
  private readonly _type: FizzBuzzType;
  private readonly _count: number;

  constructor(type: FizzBuzzType, count: number) {
    this._type = type;
    this._count = count;
  }

  execute(): FizzBuzzList {
    let list = new FizzBuzzList();
    for (let i = 1; i <= this._count; i++) {
      list = list.add(this._type.generate(i));
    }

    return list;
  }
}
