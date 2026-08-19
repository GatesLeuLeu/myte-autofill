# Security Policy

## Supported Versions

MyTE Autofill Helper is a small, single-maintainer browser extension with one active release line — only the **latest published version** receives security fixes.

| Version | Supported |
| - | :-: |
| Latest (see the version badge in [README.md](README.md) or [`firefox/manifest.json`](firefox/manifest.json)) | ✅ |
| Older releases | ❌ |

If you're running an older version, please update first — the issue may already be fixed.

## Reporting a Vulnerability

Please use GitHub's [private vulnerability reporting](https://github.com/GatesLeuLeu/myte-autofill/security/advisories/new) instead of opening a public issue. This creates a draft security advisory visible only to the maintainer until it's resolved.

What to expect:

- An acknowledgement within a few days.
- Best-effort response and fix timelines — this is a single-maintainer project without a dedicated security team or formal SLA.
- If the report is confirmed, a fix will be released and the advisory published (with credit, if you'd like) once a patched version is available.
- If it's declined (e.g. out of scope, not reproducible, or already known), you'll get an explanation.

## Scope

MyTE Autofill Helper is a Manifest V3 extension that automates timesheet entry on `https://myte.accenture.com`. Relevant to this project:

- It runs entirely client-side and does not send data to any server the maintainer controls.
- Its only permissions are `storage`, `activeTab`, `tabs`, and host access limited to `https://myte.accenture.com/*` (see [`manifest.json`](manifest.json)).
- Dependencies are dev-only (testing/build tooling); nothing is bundled into the shipped extension.

Reports most relevant here include:

- Permission or host-access scope creep beyond what's declared in the manifest.
- Content script / DOM automation issues that could leak, corrupt, or misfile timesheet data.
- Supply-chain issues in dependencies (`package.json` / `pnpm-lock.yaml`).

Vulnerabilities in the MyTE Accenture platform itself are out of scope — this extension only automates existing interactions on it and isn't affiliated with Accenture or the MyTE product team.
