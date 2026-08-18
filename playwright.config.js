import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/playwright",
  fullyParallel: false,
  workers: 1,
  outputDir: "test-results/playwright/artifacts",
  reporter: [
    ["list"],
    ["html", { open: "never", outputFolder: "playwright-report" }],
    ["json", { outputFile: "test-results/playwright/results.json" }]
  ],
  use: {
    headless: true,
    trace: "on",
    video: "on",
    screenshot: "only-on-failure"
  },
  projects: [
    { name: "chromium", use: { browserName: "chromium" } },
    { name: "firefox", use: { browserName: "firefox" } }
  ]
});
