import { FizzBuzzValue } from "./fizz-buzz-value.js";

export class FizzBuzzList {
  private readonly _list: readonly FizzBuzzValue[];

  constructor(list: FizzBuzzValue[] = []) {
    this._list = Object.freeze([...list]);
  }

  add(value: FizzBuzzValue): FizzBuzzList {
    return new FizzBuzzList([...this._list, value]);
  }

  get value(): readonly FizzBuzzValue[] {
    return this._list;
  }

  get size(): number {
    return this._list.length;
  }

  toStringArray(): string[] {
    return this._list.map((v) => v.toString());
  }

  *[Symbol.iterator](): Iterator<FizzBuzzValue> {
    for (const value of this._list) {
      yield value;
    }
  }
}
