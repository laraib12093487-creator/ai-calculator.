# All-in-One Calculator

A fast, private, responsive dashboard with **8 calculators** in plain HTML, CSS and
JavaScript. No framework, no build step, no tracking, no accounts. Open
`index.html` and it works.

---

## The calculators

| Tool | What it does | Notes |
| --- | --- | --- |
| **Basic calculator** | `+ − × ÷`, %, ±, chained operators, full keyboard support | Float noise trimmed (0.1 + 0.2 = 0.3), divide-by-zero caught |
| **Age** | Years / months / days, total days·weeks·months·years, next birthday, birth weekday, life progress | Reference date is editable, so you can project any date |
| **BMI** | `kg ÷ m²` with WHO adult bands and a position marker on the scale | Metric ⇄ imperial, healthy weight range for your height |
| **Percentage** | `X% of Y`, `X is what % of Y`, `% change`, add %, subtract % | Shows the formula it used; blocks divide-by-zero and change-from-zero |
| **GPA** | Per-course grades, 4.0 / 4.3 / 5.0 / 10-point / 0–100 scales | Optional credit weighting, adjustable rounding, quality-point total |
| **Loan** | Amortised payment, total interest, payoff time, first-12-months schedule | Extra monthly payment and optional tax & insurance escrow |
| **Currency** | 50+ currencies, live mid-market rates with a labelled offline fallback | Always states whether the rate is **live** or a **fixed snapshot** |
| **Unit conversion** | Length, mass, temperature, volume, area, speed, time, data, energy, pressure | Shows every unit in the category at once, plus the exact multiplier |

### Verified examples

| Input | Output |
| --- | --- |
| BMI — 70 kg, 175 cm | **22.86** · Normal weight |
| Percentage — 15 % of 200 | **30** |
| Length — 10 km | **6.213712** miles |
| Loan — $300,000 · 5 % · 30 y | **$1,610.46** / month |
| Temperature — 100 °C | **212 °F** |
| Age — born 15 Jun 2000, at 1 Oct 2026 | **26 years, 3 months, 16 days** |

---

## Currency rates: live vs. fixed, always labelled

This is the only part of the site that touches the network, and the UI never lets
you guess which kind of number you are looking at.

- **Live** — fetched from `open.er-api.com`, falling back to `frankfurter.app`.
  A green pill shows the source and a timestamp; the rate line is prefixed
  `Live rate`. Rates refresh every 30 minutes while the tab is visible.
- **Fixed** — a stored offline snapshot dated `2025-06` in `assets/js/currency.js`.
  A red pill shows `Offline — using fixed reference rates`, and the rate line is
  prefixed `Fixed offline rate` with an explicit "this is not a live market price".

Both are **mid-market reference values with no fees or margin**. Real banks and
card networks add a spread, so you will never actually get the displayed rate.
That caveat is printed in the card itself, not buried in a tooltip.

---

## Accessibility

- Lighthouse **100 / 100 / 100** (accessibility, best practices, SEO) in **both** light and dark themes, with no contrast failures.
- Every control has a real `<label>`; invalid fields get `aria-invalid` plus a text message, never colour alone.
- Segmented controls are proper `radiogroup`s and respond to arrow keys, Home and End.
- Results are announced through a single **debounced** polite live region, so a screen reader is not flooded on every keystroke.
- Skip link, visible focus rings, `prefers-reduced-motion` support, and a `#id` deep link per card.
- All text meets WCAG AA contrast (verified, not eyeballed).

## Performance and privacy

- ~7 KB of CSS and ~55 KB of JavaScript, uncompressed, with no runtime dependencies.
- One render-blocking web font, preconnected, with a system-font fallback stack.
- Every calculation runs locally. Nothing you type is uploaded or stored. Only the
  theme choice is saved, in `localStorage`.

---

## Running it

Any static host works — the site is pure static files.

```powershell
# Windows PowerShell, no Node or Python needed:
powershell -ExecutionPolicy Bypass -File .\serve.ps1 8765
# then open http://localhost:8765/
```

## Structure

```
index.html
serve.ps1                     tiny static server for local testing
assets/css/styles.css         design tokens, layout, components
assets/js/
  core.js                     formatting, validation, DOM helpers, dates
  basic.js  age.js  bmi.js  percentage.js
  gpa.js     loan.js currency.js units.js
  app.js                     theme, search, scroll-spy, live-region announcer
```

## Accuracy notes

- **BMI** uses the WHO adult cut-offs (under 18.5, 18.5–24.9, 25–29.9, 30+). It is a
  population screening tool, not a diagnosis, and does not separate muscle from fat.
- **GPA** uses the standard US mapping (A− = 3.7, B+ = 3.3 …) and shows the unrounded
  value whenever rounding changes the answer. Cut-offs differ by institution.
- **Loan** uses standard monthly amortisation. It excludes origination fees, PMI,
  points, and any rate that resets after a fixed period — verify with your lender.
- **Unit conversion** factors are exact definitions where one exists (1 mile =
  1609.344 m, 1 lb = 0.45359237 kg) and averages are labelled as such (month =
  30.44 days, mach = 340.29 m/s at sea level).

Nothing here is financial, medical or legal advice.
