import { FizzBuzzValue } from "./fizz-buzz-value.js";

type FizzBuzzGenerator = {
  generate(number: number): FizzBuzzValue;
};

export class FizzBuzzList {
  private readonly _list: readonly FizzBuzzValue[];

  constructor(list: FizzBuzzValue[] = []) {
    this._list = Object.freeze([...list]);
  }

  add(value: FizzBuzzValue): FizzBuzzList {
    return new FizzBuzzList([...this._list, value]);
  }

  map(fn: (value: FizzBuzzValue) => FizzBuzzValue): FizzBuzzList {
    return new FizzBuzzList(this._list.map(fn));
  }

  filter(predicate: (value: FizzBuzzValue) => boolean): FizzBuzzList {
    return new FizzBuzzList(this._list.filter(predicate));
  }

  reduce<T>(fn: (acc: T, value: FizzBuzzValue) => T, initial: T): T {
    return this._list.reduce(fn, initial);
  }

  groupBy(fn: (value: FizzBuzzValue) => string): Map<string, FizzBuzzList> {
    return this._list.reduce((groups, value) => {
      const key = fn(value);
      const group = groups.get(key) ?? new FizzBuzzList();
      groups.set(key, group.add(value));
      return groups;
    }, new Map<string, FizzBuzzList>());
  }

  countBy(fn: (value: FizzBuzzValue) => string): Map<string, number> {
    return this._list.reduce((counts, value) => {
      const key = fn(value);
      counts.set(key, (counts.get(key) ?? 0) + 1);
      return counts;
    }, new Map<string, number>());
  }

  take(n: number): FizzBuzzList {
    return new FizzBuzzList(this._list.slice(0, Math.max(0, n)));
  }

  first(): FizzBuzzValue | undefined {
    return this._list[0];
  }

  join(separator: string): string {
    return this._list.map((value) => value.toString()).join(separator);
  }

  find(
    predicate: (value: FizzBuzzValue) => boolean,
  ): FizzBuzzValue | undefined {
    return this._list.find(predicate);
  }

  some(predicate: (value: FizzBuzzValue) => boolean): boolean {
    return this._list.some(predicate);
  }

  every(predicate: (value: FizzBuzzValue) => boolean): boolean {
    return this._list.every(predicate);
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

  private static *sequence(
    type: FizzBuzzGenerator,
    count: number,
  ): Generator<FizzBuzzValue> {
    for (let number = 1; number <= count; number += 1) {
      yield type.generate(number);
    }
  }

  static generate(type: FizzBuzzGenerator, count: number): FizzBuzzList {
    return new FizzBuzzList([...FizzBuzzList.sequence(type, count)]);
  }
}
