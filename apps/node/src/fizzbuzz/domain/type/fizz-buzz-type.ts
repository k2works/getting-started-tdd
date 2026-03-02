import { FizzBuzzValue } from "../model/fizz-buzz-value.js";
import { FizzBuzzType01 } from "./fizz-buzz-type-01.js";
import { FizzBuzzType02 } from "./fizz-buzz-type-02.js";
import { FizzBuzzType03 } from "./fizz-buzz-type-03.js";
import { FizzBuzzTypeName } from "./fizz-buzz-type-name.js";

export abstract class FizzBuzzType {
  static readonly TYPE_01 = 1;
  static readonly TYPE_02 = 2;
  static readonly TYPE_03 = 3;

  abstract generate(number: number): FizzBuzzValue;

  static create(type: number = FizzBuzzType.TYPE_01): FizzBuzzType {
    switch (type) {
      case FizzBuzzType.TYPE_01:
        return new FizzBuzzType01();
      case FizzBuzzType.TYPE_02:
        return new FizzBuzzType02();
      case FizzBuzzType.TYPE_03:
        return new FizzBuzzType03();
      default:
        throw new Error(`未定義のタイプ: ${type}`);
    }
  }

  static tryCreate(typeName: FizzBuzzTypeName): FizzBuzzType | undefined {
    const typeMap: Record<FizzBuzzTypeName, () => FizzBuzzType> = {
      [FizzBuzzTypeName.TYPE_01]: () => new FizzBuzzType01(),
      [FizzBuzzTypeName.TYPE_02]: () => new FizzBuzzType02(),
      [FizzBuzzTypeName.TYPE_03]: () => new FizzBuzzType03(),
    };

    return typeMap[typeName]?.();
  }
}
