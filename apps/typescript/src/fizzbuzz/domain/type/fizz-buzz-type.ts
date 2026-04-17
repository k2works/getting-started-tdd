import { FizzBuzzValue } from "../model/fizz-buzz-value.js";
import { FizzBuzzType01 } from "./fizz-buzz-type-01.js";
import { FizzBuzzType02 } from "./fizz-buzz-type-02.js";
import { FizzBuzzType03 } from "./fizz-buzz-type-03.js";

export interface FizzBuzzType {
  generate(number: number): FizzBuzzValue;
}

export enum FizzBuzzTypeName {
  TYPE_01 = "TYPE_01",
  TYPE_02 = "TYPE_02",
  TYPE_03 = "TYPE_03",
}

export const FizzBuzzType = {
  TYPE_01: 1,
  TYPE_02: 2,
  TYPE_03: 3,
  create(type: number): FizzBuzzType {
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
  },
  tryCreate(typeName: FizzBuzzTypeName): FizzBuzzType | undefined {
    const typeMap: Record<FizzBuzzTypeName, () => FizzBuzzType> = {
      [FizzBuzzTypeName.TYPE_01]: () => new FizzBuzzType01(),
      [FizzBuzzTypeName.TYPE_02]: () => new FizzBuzzType02(),
      [FizzBuzzTypeName.TYPE_03]: () => new FizzBuzzType03(),
    };

    return typeMap[typeName]?.();
  },
} as const;
