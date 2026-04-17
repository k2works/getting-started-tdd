export class FizzBuzzValue {
  private readonly _value: string;
  private readonly _number: number;

  constructor(value: string, number: number) {
    this._value = value;
    this._number = number;
  }

  get value(): string {
    return this._value;
  }

  get number(): number {
    return this._number;
  }

  equals(other: FizzBuzzValue): boolean {
    if (!(other instanceof FizzBuzzValue)) {
      return false;
    }
    return this._value === other._value && this._number === other._number;
  }

  toString(): string {
    return this._value;
  }
}
