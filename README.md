# MyTE Autofill Helper

Autofill Accenture MyTE timesheets with multi-WBS allocations and homeworking/office patterns.

[![Firefox](https://img.shields.io/badge/Firefox-Maintained-orange?logo=firefoxbrowser&logoColor=white)](https://github.com/GatesLeuLeu/myte-autofill)
[![Chrome Extension](https://img.shields.io/badge/Chrome-Upstream-blue?logo=googlechrome&logoColor=white)](https://chromewebstore.google.com/detail/myte-autofill-helper/dfpohbobkklfchohecohngodhagffhib)
![Edge Add-ons](https://img.shields.io/badge/Edge_Add--ons-Pending-blue?logo=microsoftedge&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Version](https://img.shields.io/badge/Version-1.4.6-purple)
![Package manager](https://img.shields.io/badge/package%20manager-pnpm-F69220?logo=pnpm&logoColor=white)

<img width="1400" height="933" alt="marquee-promo-tile-1400x560 png" src="https://github.com/user-attachments/assets/de0b8adc-c3d2-4f52-be44-0cfa90b37de0" />

⚠️ Disclamer: This is an independent helper tool.  
It is **not** affiliated with, sponsored by, or endorsed by **Accenture** or the official **MyTE** product team.

> This is the Firefox-maintained fork of MyTE Autofill Helper. Firefox releases and support are maintained by [GatesLeuLeu](https://github.com/GatesLeuLeu). Chrome Store resources are retained as upstream references and are not maintained by this fork.

---

## 🚀 Overview

**MyTE Autofill Helper** automates repetitive tasks inside the Accenture MyTE timesheet interface.  
It simulates real user actions to safely and reliably fill your timesheet—saving time and preventing mistakes.

Everything runs **locally in your browser**.  
No data is transmitted. No tracking. No servers.

If you log time every week or every half-month, this extension reduces the process from **minutes to seconds**.

---

## ✨ Features

### 🔢 Multi-WBS Hours Autofill

- Add multiple WBS codes with weighted percentages.
- Automatically splits your daily hours (default **7.7h**) based on these weights.
- Ensures **perfect rounding** and correct totals (last WBS adjusted).
- Simulates real typing + Tab validation in the grid.

### 📥 Automatic WBS Loading

The extension:

- Opens the MyTE WBS selection popup
- Scrolls through the entire virtualized list
- Extracts **only active (white) WBS**
- Ignores inactive or closed (red) WBS
- Saves them to a dropdown for easy selection

No more manual searching.  
No more guessing.  
Instant WBS filtering.

### 🏠🏢 Weekly Homeworking / Office Pattern

Configure your weekly rhythm once.  
For each weekday (Mon-Fri), choose:

- **Homeworking (🏠)**
- **Office/Client (🏢)**
- **None**

The extension then applies the pattern across all weeks automatically using user-simulated events.

### ✔️ Automatic Compliance Checkboxes

Optionally auto-check:

- "I have respected my daily rest"
- "I have respected my weekly rest"

Works **only** on valid working days (never weekends or special days).

### 🎨 Modern Embedded UI Panel

The in-page control panel features:

- Accenture-themed styles (**Corporate** and **Developer** modes)
- Dark/light mode support
- Foldable configuration categories
- Emoji indicators
- Fixed bottom action bar
- Smooth animations
- Auto-close after autofill

---

## 🧠 How to Use

1. Navigate to  
   `https://myte.accenture.com/#/time`

2. Click the **MyTE Autofill Helper** icon in your browser toolbar.

3. In the panel:
   - Load WBS from the page
   - Configure daily hour total (default 7.7)
   - Add WBS with weights
   - Set weekly HW/Office pattern
   - Enable optional rest compliance

4. Click **Fill Timesheet**

The tool fills everything and closes itself afterwards.

Firefox users can install the signed package from Firefox Add-ons when it is published. For local testing, use `about:debugging#/runtime/this-firefox`, select **Load Temporary Add-on**, and choose the generated Firefox package's `manifest.json` after extracting it.

---

## 🔒 Privacy

This extension:

- Does **not** collect personal data  
- Does **not** send information externally  
- Does **not** use analytics or tracking  
- Stores settings **only** in browser storage  
- Runs **entirely locally**  
- Interacts only with `https://myte.accenture.com/*`

See the full Privacy Policy in the repository.

---

## 🔧 Permissions

- **storage** – Save user configuration (WBS, weights, theme, pattern)
- **activeTab** – Determine if the current tab is MyTE
- **tabs** – Open MyTE automatically if needed
- **host_permissions** (`https://myte.accenture.com/*`) – Required to interact with MyTE

No other domain is accessed.  
No remote code is used.

---

## ⚠️ Disclaimer

This is a personal productivity tool.  
Users remain fully responsible for reviewing and validating their timesheets before submission.

The tool is **not official Accenture software**.

---

## 🛠 Development

This project uses [pnpm](https://pnpm.io/) as its package manager. The required version is pinned in `package.json`; enable Corepack before installing dependencies.

### Folder Structure

```text
myte-autofill/
├── manifest.json
├── background.js
├── content.js
├── panel.html
├── styles.css
├── README.md
└── icons/
    ├── icon16.png
    ├── icon32.png
    ├── icon48.png
    ├── icon128.png
    └── icon.png
```

### Packaging

Update the version and rebuild the package in one step with:

```powershell
./scripts/bump-version.ps1 -Version X.Y.Z
```

This updates both manifests, refreshes the README version badge, and builds the Firefox package unless you pass `-SkipPackage`. The script requires Bash, such as on Linux, macOS, or Git Bash.

Create the Firefox MV3 submission package with:

```bash
./scripts/package-firefox.sh
```

This produces:

- `dist/myte-autofill-<version>-firefox.zip`
- `dist/firefox-package-<version>/`
- `dist/myte-autofill-<version>-firefox-contents.txt`

Submit the ZIP to [Firefox Add-ons](https://addons.mozilla.org/developers/) for signing and publication. AMO returns the signed XPI for distribution. The root `manifest.json` remains the authoritative release version; `firefox/manifest.json` is the Firefox MV3 variant and must have the same version. The Firefox package script enforces this.

### Automated Tests

Install the dev-only test tooling with pnpm (enabled through Corepack in supported Node.js releases) with:

```bash
corepack enable
pnpm install --frozen-lockfile
```

Run the automated tests with:

```bash
pnpm test
```

Run the browser smoke tests with Playwright after installing Chromium and Firefox once:

```bash
pnpm exec playwright install chromium firefox
pnpm run test:smoke
```

Run them locally with a visible browser window:

```bash
pnpm run test:smoke:headed
```

Run them in Playwright UI mode for interactive local debugging:

```bash
pnpm run test:smoke:ui
```

Generate a local coverage report with:

```bash
pnpm run test:coverage
```

The current automated suite covers pure allocation logic, panel lifecycle behavior, MyTE-like DOM scenarios for hour filling, weekly pattern application, WBS autocomplete and favorites, popup-based WBS extraction, and the background action routing logic. A separate Playwright smoke suite runs the real content script in Chromium and Firefox against a fake MyTE page to verify panel opening, hour filling, and popup-based WBS loading end to end. Both suites run automatically on every pull request (see [GitHub Actions](#github-actions) below). The live MyTE site still requires a manual smoke test after major DOM automation changes.

### Test Outputs

- `pnpm test`: Vitest results are printed in the terminal. There is no persistent report file unless you run coverage.
- `pnpm run test:coverage`: coverage outputs are written under `coverage/`.
- `pnpm run test:smoke`: Playwright writes the HTML report to `playwright-report/`, JSON results to `test-results/playwright/results.json`, and per-test traces/videos/artifacts to `test-results/playwright/artifacts/`.
- Open the Playwright HTML report with `pnpm run test:smoke:report`.

### GitHub Actions

The repository includes a workflow at `.github/workflows/test.yml`.

- Runs on every pull request and on pushes to `main`
- The `test` job runs the Vitest suite (`pnpm test`)
- The `playwright` job installs Chromium, runs the Playwright smoke suite (`pnpm run test:smoke`), publishes a pass/fail summary table to the job's GitHub Actions summary page, and uploads the full HTML report (screenshots, videos, traces) as a downloadable `playwright-report` artifact on the workflow run — even when tests fail
- The `pages` job publishes that same report to GitHub Pages, viewable directly in the browser (no download needed):
  - Pushes to `main` publish to `https://gatesleuleu.github.io/myte-autofill/main/`
  - Each pull request publishes to its own persistent `https://gatesleuleu.github.io/myte-autofill/pr-<number>/`, updated on every push to that PR
  - The resulting URL is also printed on the job's GitHub Actions summary page
  - Traces work directly from these pages (no `show-report` command needed) since they're served over `https://`
- To inspect traces from a CI run locally instead: download the `playwright-report` artifact, unzip it, then run `pnpm exec playwright show-report path/to/playwright-report` (opening `index.html` directly won't work for traces, see below)

The repository includes a workflow at `.github/workflows/package-firefox.yml`.

- Run it manually with **workflow_dispatch**

The workflow uploads the Firefox MV3 submission ZIP and contents manifest. Submit that ZIP to AMO manually; AMO publication is intentionally not automated.

The repository also includes a release workflow at `.github/workflows/release-firefox.yml`.

- Push a tag like `v1.2.3`
- The workflow validates that the tag version matches both manifests, builds the Firefox package, creates a GitHub Release, and attaches the ZIP and contents manifest

Tags don't have to be pushed by hand: `.github/workflows/auto-tag-release.yml` runs on every push to `main` that changes `manifest.json`. If the manifest's version doesn't already have a matching `vX.Y.Z` tag, it creates and pushes one, which triggers `release-firefox.yml` automatically. It authenticates with the `COPILOT_AGENT_TOKEN` secret rather than the default `GITHUB_TOKEN`, because tag pushes made with the default token don't trigger other workflows.

The repository also includes Copilot bug automation workflows:

- `.github/workflows/copilot-bug-intake.yml`: validates new bug issues, applies agent labels, and assigns valid issues to GitHub Copilot coding agent
- `.github/workflows/copilot-bug-pr-sync.yml`: mirrors Copilot PR investigation details and lifecycle updates back to the original issue
- `.github/workflows/copilot-bug-agent-failure.yml`: moves startup failures to `agent:blocked` so bug issues do not remain stuck in `agent:running`

The repository also includes Copilot feature automation workflows:

- `.github/workflows/copilot-feature-intake.yml`: validates new feature requests, applies agent labels, and assigns valid requests to GitHub Copilot for feasibility review
- `.github/workflows/copilot-feature-pr-sync.yml`: mirrors Copilot PR feasibility details and lifecycle updates back to the original feature request
- `.github/workflows/copilot-feature-feedback-sync.yml`: reacts to structured Copilot issue feedback when a feature request should not produce a PR
- `.github/workflows/copilot-feature-agent-failure.yml`: moves startup failures to `agent:blocked` so feature requests do not remain stuck in `agent:running`

### Copilot Issue Automation Setup

To enable automated bug investigation and feature feasibility review with GitHub Copilot:

1. Enable GitHub Copilot coding agent for this repository in the organization or repository settings.
2. Add a repository secret named `COPILOT_AGENT_TOKEN`.
3. Use a user-scoped token that can assign issues to Copilot.

Recommended fine-grained token permissions:

- Metadata: read
- Actions: read and write
- Contents: read and write
- Issues: read and write
- Pull requests: read and write

Optional repository variables:

- `COPILOT_BUG_BASE_BRANCH`: override the branch Copilot should target instead of the default branch
- `COPILOT_BUG_MODEL`: request a specific Copilot coding agent model
- `COPILOT_BUG_CUSTOM_AGENT`: set the custom agent identifier if you want issue assignment to use a repository custom agent instead of the default coding agent
- `COPILOT_FEATURE_BASE_BRANCH`: override the branch Copilot should target for feature work instead of the default branch
- `COPILOT_FEATURE_MODEL`: request a specific Copilot coding agent model for feature reviews
- `COPILOT_FEATURE_CUSTOM_AGENT`: set the custom agent identifier if you want feature requests to use a repository custom agent instead of the default coding agent

Bug workflow PRs are expected to include these sections in the PR body:

- `Fixes #<issue-number>`
- `## Investigation Summary`
- `## Root Cause`
- `## Proposed Fix`
- `## Validation`
- `## Risks`

Feature workflow PRs are expected to include these sections in the PR body:

- `Closes #<issue-number>`
- `## Feasibility Assessment`
- `## Recommendation`
- `## Proposed Implementation`
- `## Validation`
- `## Risks`

If a feature request is not feasible or needs more detail, Copilot is expected to leave an issue comment that includes:

- `<!-- copilot-feature-review -->`
- `Status: needs-info` or `Status: not-feasible`
- `## Feasibility Assessment`
- `## Recommendation`
- `## Blocking Factors`
- `## Suggested Next Steps`

The included repository custom agents at `.github/agents/bug-investigation-specialist.agent.md` and `.github/agents/feature-feasibility-specialist.agent.md` are designed to produce those structures.

GitHub MCP is optional here. The issue-to-Copilot workflow uses GitHub's native issue assignment API and does not require MCP. If you want to start Copilot tasks from an IDE or another host instead of issue assignment, GitHub MCP can be enabled separately for `create_pull_request_with_copilot` workflows.

---

## 💬 Feedback & Contributions

Issues and feature requests are welcome.  
Pull requests should preserve the extension’s **single purpose**:  
**Automating safe, accurate MyTE timesheet entry.**

---

## Attribution

The original MyTE Autofill Helper project was created by [GuillaumeLamb](https://github.com/gla-showcase). This fork adapts and maintains the extension for Firefox.

---

## 📄 License

MIT License.
