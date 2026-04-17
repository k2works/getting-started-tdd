import { FizzBuzzList } from "./fizz-buzz-list.js";
import { FizzBuzzValue } from "./fizz-buzz-value.js";

export const compose =
  <T>(...fns: ((arg: T) => T)[]): ((arg: T) => T) =>
  (arg: T) =>
    fns.reduceRight((acc, fn) => fn(acc), arg);

export const pipe =
  <T>(...fns: ((arg: T) => T)[]): ((arg: T) => T) =>
  (arg: T) =>
    fns.reduce((acc, fn) => fn(acc), arg);

export const isFizz = (value: FizzBuzzValue): boolean => value.value === "Fizz";
export const isBuzz = (value: FizzBuzzValue): boolean => value.value === "Buzz";
export const isFizzBuzz = (value: FizzBuzzValue): boolean =>
  value.value === "FizzBuzz";
export const isNumber = (value: FizzBuzzValue): boolean =>
  !Number.isNaN(Number(value.value));

export function isFizzBuzzValue(value: unknown): value is FizzBuzzValue {
  return value instanceof FizzBuzzValue;
}

export function isFizzBuzzList(value: unknown): value is FizzBuzzList {
  return value instanceof FizzBuzzList;
}
