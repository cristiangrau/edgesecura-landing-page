# EdgeSecura — Landing Page

Marketing landing site for **EdgeSecura** — the platform for governing the lifecycle of external (non-employee) identities: contractors, partners, vendors, and guest users.

This repo is the **public website**, not the product itself. The product UI lives in [`edgesecura-frontend`](https://github.com/cristiangrau/edgesecura-frontend).

## Tech stack

- **Astro 5** — static-first multi-page framework, zero JS by default
- **Tailwind CSS v4** — utility-first styling via `@tailwindcss/vite`, theme tokens declared in `@theme {}` inside `src/styles/global.css`
- **Inter** — typography, loaded from Google Fonts in `Layout.astro`
- **Editorial design language** — full-page navy palette matching the EdgeSecura product login (`color-mix(srgb, #005497 30%, #0a0f2e) ≈ #091F50`)

## Getting started

### Prerequisites

- Node.js 18+
- npm 9+

### Install dependencies

```bash
npm install
```

### Run the development server

```bash
npm run dev
```

Open `http://localhost:4321`.

## Scripts

| Command | Description |
|---|---|
| `npm run dev` | Start dev server (`http://localhost:4321`) |
| `npm run build` | Production static build (output: `dist/`) |
| `npm run preview` | Preview the production build locally |

## Project structure

```
src/
├── components/
│   ├── Nav.astro           # Sticky top nav, blurred bg, anchor links
│   ├── Hero.astro          # Tagline + headline + CTA, accent-tinted blobs
│   ├── Problem.astro       # 3 problem cards on a band
│   ├── Features.astro      # 6 feature cards with stroked icons (Icon.astro)
│   ├── HowItWorks.astro    # Inverted white slab — 3 numbered steps
│   ├── SocialProof.astro   # Logo strip + testimonial (placeholders)
│   ├── Security.astro      # 4 security pillars, no stack leaks
│   ├── Pricing.astro       # 3-tier per-identity pricing
│   ├── Faq.astro           # Buyer-question FAQ, native <details>
│   ├── Cta.astro           # End-of-page demo CTA
│   ├── Footer.astro        # Logo + tagline + columns, deeper navy bg
│   └── Icon.astro          # Inline SVG icon set, switch by name prop
├── layouts/
│   ├── Layout.astro        # Page shell (head, fonts, Nav, Footer)
│   └── LegalLayout.astro   # Narrow article shell for legal pages
├── pages/
│   ├── index.astro         # Coming-soon holding page (white bg, no Layout)
│   ├── preview.astro       # Full landing composition (uses Layout) — swap to index at launch
│   ├── privacy.astro       # Privacy Policy (placeholder)
│   ├── terms.astro         # Terms of Service (placeholder)
│   └── dpa.astro           # Data Processing Agreement (placeholder)
└── styles/
    └── global.css          # Tailwind v4 import + @theme tokens (navy)

public/
├── assets/
│   └── logo.svg            # EdgeSecura wordmark (shared with frontend)
├── favicon.svg
└── favicon.png
```

## Design tokens

All colors live as CSS variables in `src/styles/global.css` under `@theme {}`. Token names are theme-agnostic so component classes stay valid when switching between light and dark themes; only the variable values flip.

| Token | Role |
|---|---|
| `--color-page` | Page bg (deepest navy, `#091F50`) |
| `--color-deep` | Footer / extra-deep accents |
| `paper-50` → `paper-300` | Surfaces (raised cards → subtle border) |
| `ink-900` → `ink-100` | Foreground (heading → dimmest text → border-strong) |
| `accent-700` → `accent-100` | Brand accent ladder (Lapis Lazuli `#005497`) |

## Sections in order

Hero → Problem → Features → HowItWorks → SocialProof → Security → Pricing → FAQ → CTA → Footer.

The page rhythm uses a single inverted band (HowItWorks = white slab) to break the navy and emphasize the lifecycle steps; Pricing's middle tier reuses the same inversion to mark the recommended plan.

## Placeholders to replace before launch

- `Pricing.astro` tier prices (`$4` / `$8`) — wrong price teaches your sales motion before you do.
- `SocialProof.astro` customer logos and testimonial.
- `Hero.astro` compliance badges (`SOC 2`, `ISO 27001`).
- `Faq.astro` jurisdiction in Terms § 8 placeholder.
- `pages/privacy.astro`, `terms.astro`, `dpa.astro` — placeholder legal copy. Replace with the version reviewed by your counsel.
- All `mailto:` CTAs (`hello@`, `demo@`, `sales@`, `privacy@`, `legal@`) — provision real inboxes or wire to a form.

## Marketing copy guideline

Speak **capabilities + outcomes**, not **components + protocols**. "Encrypted at rest" yes, internal cipher and storage details no. "Durable execution engine" yes, the underlying queue product no. Specific component and vendor names belong in internal architecture docs — not on a buyer-facing page.

## Deployment

Static `dist/` output from `npm run build` can be served by any static host:

- **Any static-host platform** — point it at the repo, set build command `npm run build`, publish dir `dist`.
- **nginx on the EdgeSecura host** — `rsync` `dist/` to the server, configure a `server` block for the apex domain (`edgesecura.dev`) with a `try_files $uri /index.html` fallback.

## About EdgeSecura

EdgeSecura is a SaaS platform for managing the lifecycle of external (non-employee) identities. It provisions, certifies, and offboards every contractor, partner, and vendor across customer systems, with one audit-ready record per identity.
