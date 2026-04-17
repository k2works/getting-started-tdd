import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: false,
    environment: "node",
    include: ["test/**/*.test.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "text-summary"],
      reportsDirectory: "coverage",
      exclude: [
        "node_modules/**",
        "dist/**",
        "**/*.test.ts",
        "**/*.config.*",
        "src/index.ts",
        "gulpfile.js",
      ],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
    },
  },
});
