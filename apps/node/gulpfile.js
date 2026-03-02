import { watch, series } from "gulp";
import shell from "gulp-shell";

export const test = shell.task(["npm run test"]);
export const coverage = shell.task(["npm run test:coverage"]);
export const lint = shell.task(["npm run lint"]);
export const lintFix = shell.task(["npm run lint:fix"]);
export const format = shell.task(["npm run format"]);
export const formatCheck = shell.task(["npm run format:check"]);
export const typecheck = shell.task(["npm run typecheck"]);

export const checkAndFix = series(lintFix, format, test);

export function guard() {
  console.log("Guard is watching for file changes...");
  watch("src/**/*.ts", series(lintFix, format, test));
  watch("test/**/*.ts", series(test));
}

export default series(checkAndFix, guard);
