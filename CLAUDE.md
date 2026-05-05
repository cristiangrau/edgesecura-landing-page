# CLAUDE.md — `edgesecura-landing-page`

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repo.

## What lives here

The **public marketing site** for EdgeSecura — *not* the product itself. The product UI lives in [`edgesecura-frontend`](https://github.com/cristiangrau/edgesecura-frontend).

Two distinct page modes coexist while in development:

| Route | Purpose | File |
|---|---|---|
| `/` | Coming-soon holding page — white bg, big colored logo, single H1 | `src/pages/index.astro` |
| `/preview` | Full marketing landing — dark navy theme, all sections | `src/pages/preview.astro` |

When the product launches, **swap the two files** (the simplest cut-over — rename `preview.astro` → `index.astro`, delete or stash the holding page). Until then, only `/` is intended for public traffic; `/preview` is the dev URL for iterating on the launch site.

## Tech stack

- **Astro 5** — static-first multi-page framework, zero JS by default. Component model: `.astro` files with frontmatter (TypeScript) + JSX-like template.
- **Tailwind CSS v4** — wired via `@tailwindcss/vite` plugin in `astro.config.mjs`. Theme tokens declared in `@theme {}` inside `src/styles/global.css`.
- **Inter** — typography, loaded from Google Fonts in `Layout.astro`.
- **pa11y-ci + puppeteer** — local accessibility checks. Run `npm run a11y`. No CI workflow currently — that was removed. The script remains for manual checks.

## Commands

```bash
# Dev server (http://localhost:4321)
npm run dev

# Production build (writes static output to dist/)
npm run build

# Preview production build
npm run preview

# Accessibility check — boots `astro preview`, runs pa11y-ci against /
npm run a11y
```

First time running `npm run a11y` on a fresh checkout may need:

```bash
npx puppeteer browsers install chrome
```

`pa11y-ci` uses `puppeteer-core`, which needs a specific Chrome version cached at `~/.cache/puppeteer`. The full `puppeteer` package is a devDep so install scripts normally fetch it; if a `--silent` install skipped that step, run the line above once.

## Project structure

```
src/
├── components/
│   ├── Nav.astro           # Sticky top nav, blurred bg, anchor links
│   ├── Hero.astro          # Tagline + headline + CTA, accent-tinted blobs
│   ├── Problem.astro       # 3 problem cards on a band
│   ├── Features.astro      # 6 feature cards with stroked icons (via Icon.astro)
│   ├── HowItWorks.astro    # Inverted white slab — 3 numbered steps
│   ├── SocialProof.astro   # Logo strip + testimonial (placeholders)
│   ├── Security.astro      # 4 security pillars, no stack leaks
│   ├── Pricing.astro       # 3-tier per-identity pricing
│   ├── Faq.astro           # Buyer-question FAQ, native <details>
│   ├── Cta.astro           # End-of-page demo CTA
│   ├── Footer.astro        # Logo + tagline + columns, deeper navy bg
│   └── Icon.astro          # Inline SVG icon set, switch by `name` prop
├── layouts/
│   ├── Layout.astro        # Page shell (head, fonts, Nav, Footer) — full landing
│   └── LegalLayout.astro   # Narrow article shell wrapping Layout
├── pages/
│   ├── index.astro         # Coming-soon holding page (white bg, no Layout)
│   ├── preview.astro       # Full landing composition (uses Layout)
│   ├── privacy.astro       # Privacy Policy placeholder (LegalLayout)
│   ├── terms.astro         # Terms of Service placeholder (LegalLayout)
│   └── dpa.astro           # Data Processing Agreement placeholder (LegalLayout)
└── styles/
    └── global.css          # Tailwind import + @theme tokens (navy) + @layer base

public/
├── assets/
│   └── logo.svg            # EdgeSecura wordmark (shared with frontend)
├── favicon.svg
└── favicon.png
```

## Design language — "editorial, dense, navy"

Inspired by enterprise-vendor sites. Restrained, B&W-with-one-accent typography, narrow content (`max-w-6xl`), tight letter-spacing on headings, generous whitespace. The single accent is EdgeSecura blue (`#005495`) layered on full-page navy.

Page bg comes from the same color recipe as the EdgeSecura product login:

```css
color-mix(in srgb, var(--primary-color) 30%, #0a0f2e) ≈ #091F50
```

## Design tokens

All colors live as CSS variables in `src/styles/global.css` under `@theme {}`. Token NAMES are theme-agnostic (a neutral grayscale palette would map to the same names) so component classes stay valid; VALUES here are tuned for the navy theme.

| Token | Value | Role |
|---|---|---|
| `--color-page` | `#091f50` | Body bg (deepest navy) |
| `--color-deep` | `#040b2a` | Footer / extra-deep accents |
| `--color-paper-50` | `#142e6b` | Raised cards (brighter than band) |
| `--color-paper-100` | `#0d265b` | Band bg (slight lift from page) |
| `--color-paper-200` | `#1a3a82` | Hover surfaces |
| `--color-paper-300` | `#243d80` | Subtle border |
| `--color-ink-900` | `#f5f7fc` | Headings (lightest fg) |
| `--color-ink-700` | `#d6dbe9` | Body |
| `--color-ink-500` | `#92a0c1` | Muted body |
| `--color-ink-300` | `#5d6c98` | Eyebrow / very muted |
| `--color-ink-100` | `#3a4880` | Border-strong on dark |
| `--color-accent-700` | `#1d3f7d` | Deep accent |
| `--color-accent-600` | `#005495` | Brand accent |
| `--color-accent-500` | `#2a85d4` | Lighter accent (links / CTAs on dark) |
| `--color-accent-100` | `#143a82` | Accent-tinted surface (chips) |

Brightness ordering on dark bg: `page` < `paper-100` (band) < `paper-50` (cards) < `paper-200` (hover) < `paper-300` (border).

## Cascade-layer gotcha

Base styles MUST live in `@layer base` so Tailwind utility classes (which sit in `@layer utilities`) can override them.

```css
@layer base {
  body { background: var(--color-page); color: var(--color-ink-700); }
  h1, h2, h3, h4 {
    letter-spacing: -0.02em;
    color: var(--color-ink-900);
  }
}
```

Without the layer wrapper, an unlayered `h1 { color: ... }` outranks `.text-gray-900` regardless of selector specificity, because **unlayered styles win against layered ones** in the cascade. This bit us once on the holding page — H1 was rendering near-white on white (1.07:1 contrast, invisible) until base rules were moved into the layer.

Do not add unlayered element selectors here.

## Page rhythm (`/preview`)

```
Hero (page bg, accent blobs)
  ↓
Problem (paper-100 band)
  ↓
Features (page bg)
  ↓
HowItWorks (INVERTED white slab — single rhythm break)
  ↓
SocialProof (page bg)
  ↓
Security (page bg)
  ↓
Pricing (page bg, middle tier inverted white)
  ↓
FAQ (paper-100 band)
  ↓
CTA (page bg)
  ↓
Footer (deeper navy)
```

The single light slab in `HowItWorks` is intentional — it breaks the run of dark sections and provides a featured-emphasis zone. Pricing's middle tier reuses the same inversion to mark the recommended plan.

## Component conventions

- All `.astro` components are **standalone** (no shared composition layer beyond `Layout` / `LegalLayout`).
- Section components own their own background, vertical padding, and `border-b border-paper-300` separator.
- Wrap content in `<div class="mx-auto max-w-6xl px-6 py-20 md:py-24">` so every section shares the same horizontal frame and rhythm.
- Eyebrows use `text-xs uppercase tracking-[0.18em] text-ink-300 mb-4`.
- H2 uses `text-3xl md:text-4xl font-semibold leading-tight`.
- Card grids use a `grid + gap-px + bg-paper-300` pattern so the 1px gap shows as the divider between cards (no per-card border tweaking).
- Icons in `Features.astro` come from `Icon.astro` — pass `name` prop. Add new ones by appending a case to the switch.
- Logo on dark bg: SVG fills are dark, apply `brightness-0 invert` to render as white silhouette.

## Copy guidelines — read before writing marketing text

1. **Speak capabilities + outcomes, not components + protocols.** "Encrypted at rest" yes, internal cipher and storage details no. "Durable execution engine" yes, queue-product brand name no. Architecture-level details belong in `CLAUDE.md` files inside the product repos, not on a buyer-facing page.

2. **No third-party brand names.** Do not reference identity providers, IGA suites, hosting providers, queue or workflow products, or design-language inspirations by name. If a claim needs to mention an integration partner, use a category descriptor — "your identity provider", "major directories", "the SaaS catalog you already run" — never the specific vendor. The same rule applies to README, CLAUDE, and any other docs in this repo.

3. **No internal infra leaks.** Don't mention specific databases, queue products, frameworks, or implementation details that live inside the EdgeSecura backends. Stay at the capability level (e.g. "durable execution", "logical tenant isolation", "encrypted at rest").

4. **No promises that aren't on the roadmap.** Self-host has been ruled out — do not bring it back. Avoid words like "soon", "Q2", or "in beta" unless there's a confirmed plan.

5. **Audience = security/compliance + procurement.** Tone is restrained, declarative, gravitas. Cute lines and emoji are off-tone.

## Accessibility

The holding page (`/`) currently passes pa11y-ci at WCAG 2.1 AA. Verified bits:

- Contrast on every visible text element on white passes ≥ 4.5:1 (gray-900 H1, gray-500 copyright).
- `<html lang="en">` + descriptive `<title>` + `<meta description>` set.
- Single `<h1>`, no skipped heading levels.
- Logo `<img>` carries non-empty `alt`.
- `<main>` landmark wraps the centered card.
- An `sr-only` `<p>` inside `<main>` gives screen-reader users full context that the page is a holding page launching soon.
- No interactive elements → no focus-style / keyboard-trap risk.
- No animation → reduced-motion media query irrelevant.
- Decorative dividers are removed; if reintroduced, mark with `aria-hidden="true"`.
- Reflow at 320px CSS width works (no `whitespace-nowrap` on body text below `sm:`).

The full landing (`/preview`) and the legal placeholder pages (`/privacy`, `/terms`, `/dpa`) **do not yet pass AA**. The navy palette uses `text-ink-300` and `text-ink-500` muted shades that fail 4.5:1 against `paper-50`/`paper-100` backgrounds in several places — Nav links, footer column headings, pricing checkmarks on navy cards, etc. Resolution paths when a future session works on this:

1. Brighten `--color-ink-300` and `--color-ink-500` (changes the muted look).
2. Add per-component overrides (e.g. Nav links bump from `text-ink-500` to `text-ink-700`).
3. Run `npm run a11y` after restoring the additional URLs in `.pa11yci.json`.

The `.pa11yci.json` config currently only tests `/` because that is the only page on public release. Add the others back when their content + theme are AA-clean.

## Deployment

The build output (`dist/`) is fully static. Three reasonable hosts:

1. **nginx on the EdgeSecura host** — `rsync` `dist/` to the server, configure a `server` block for the apex domain (`edgesecura.com`) with a `try_files $uri /index.html` fallback. Match the existing pattern from `compose.yml` in the parent monorepo.
2. **Static-host platform** — point at the repo, set build command `npm run build`, publish dir `dist`. Auto-TLS, atomic deploys.
3. **Built-in static-page service of the repo host** — small enough; would require a workflow to build + push to a deployment branch.

## Pre-launch checklist (when promoting `/preview` → `/`)

- [ ] Swap `src/pages/index.astro` ↔ `src/pages/preview.astro` (rename or move).
- [ ] Drop `<meta name="robots" content="noindex">` from the new `/`.
- [ ] Replace placeholder pricing numbers (`$4` / `$8`) with the agreed-on figures or `Contact us`.
- [ ] Replace placeholder customer logos + testimonial in `SocialProof.astro` (or remove the section).
- [ ] Confirm SOC 2 / ISO 27001 status in `Hero.astro` compliance line is truthful.
- [ ] Replace `[Jurisdiction]` in Terms § 8.
- [ ] Have counsel review `privacy.astro`, `terms.astro`, `dpa.astro`. They are placeholders today.
- [ ] Mailto CTAs (`hello@`, `demo@`, `sales@`, `privacy@`, `legal@`) — provision real inboxes or wire to a form.
- [ ] Add `/contact`, `/about`, `/subprocessors` pages — referenced from footer + DPA, currently 404.
- [ ] Restore `/preview` (or its replacement), `/privacy`, `/terms`, `/dpa` to `.pa11yci.json` and fix any contrast failures.
- [ ] Add a sitemap (`@astrojs/sitemap` integration) and a `robots.txt`.
- [ ] Wire up analytics + a privacy-respecting cookie/consent banner if the analytics tool requires it.

## Git workflow

- Branch: `master`.
- Push to remote immediately after committing.
- Never add `Co-Authored-By` lines to commit messages (per the user's global instruction).

## What does NOT live here

- Product UI (`/admin`, `/dashboard`, `/login`, etc.) → `edgesecura-frontend`.
- Any backend code → `backend/edgesecura-*` repos in the parent monorepo.
- Architecture / design docs / runbooks → the per-service `CLAUDE.md` files in those repos.
- Customer data, secrets, or env-specific config — keep this repo deployable as-is from any branch.
