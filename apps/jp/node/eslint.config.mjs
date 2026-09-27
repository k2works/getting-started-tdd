import tseslint from "@typescript-eslint/eslint-plugin";
import tsparser from "@typescript-eslint/parser";
import eslintConfigPrettier from "eslint-config-prettier";

// 既存 apps/node の設定をそのまま使い、対象に JavaScript を加えただけ
export default [
  {
    files: ["src/**/*.{js,ts}", "test/**/*.{js,ts}"],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      "no-console": "off",
      "@typescript-eslint/no-unused-vars": "warn",
      complexity: ["error", { max: 7 }],
    },
  },
  eslintConfigPrettier,
];
