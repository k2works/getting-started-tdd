import { FizzBuzzList } from "../model/fizz-buzz-list.js";
import { FizzBuzzValue } from "../model/fizz-buzz-value.js";

export const compose =
  <T>(...fns: ((arg: T) => T)[]): ((arg: T) => T) =>
  (arg: T) =>
    fns.reduceRight((acc, fn) => fn(acc), arg);

export const pipe =
  <T>(...fns: ((arg: T) => T)[]): ((arg: T) => T) =>
  (arg: T) =>
    fns.reduce((acc, fn) => fn(acc), arg);

export const isFizz = (v: FizzBuzzValue): boolean => v.value === "Fizz";
export const isBuzz = (v: FizzBuzzValue): boolean => v.value === "Buzz";
export const isFizzBuzz = (v: FizzBuzzValue): boolean => v.value === "FizzBuzz";
export const isNumber = (v: FizzBuzzValue): boolean => !isNaN(Number(v.value));

export function isFizzBuzzValue(value: unknown): value is FizzBuzzValue {
  return value instanceof FizzBuzzValue;
}

export function isFizzBuzzList(value: unknown): value is FizzBuzzList {
  return value instanceof FizzBuzzList;
}
