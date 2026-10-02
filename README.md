# All-in-One Calculator

Ek **single self-contained `index.html`** — 8 calculators, koi folder structure nahi,
koi build step nahi, koi dependencies nahi. File kholo, chal gaya.

```
index.html     the entire website
serve.ps1      optional tiny server, only needed for live currency rates
README.md
```

---

## Chalane ke do tareeke

**1. Seedha kholo** — `index.html` par double-click.
Sab kuch chalta hai. Sirf live currency rates nahi milengi (browser `file://`
se internet request block karta hai) — currency card saaf likh dega
`Offline — using fixed reference rates (2025-06)`. Yeh galat number nahi hai,
sirf purana hai, aur usay label laga diya gaya hai.

**2. Server se kholo** — live rates chahiye to:

```powershell
powershell -ExecutionPolicy Bypass -File .\serve.ps1
```

Phir browser mein kholo: **http://localhost:8765**
Band karne ke liye us window mein `Ctrl+C`.

---

## The calculators

| Tool | Kya karta hai |
| --- | --- |
| **Basic** | `+ − × ÷`, %, ±, chained operators, poori keyboard support |
| **Age** | Years/months/days, total days·weeks·months·years, agla birthday, janm din |
| **BMI** | `kg ÷ m²`, WHO bands, metric ⇄ imperial, healthy weight range |
| **Percentage** | `X% of Y`, `X is what % of Y`, `% change`, add %, subtract % |
| **GPA** | 4.0 / 4.3 / 5.0 / 10-point / 0–100 scales, credit weighting, quality points |
| **Loan** | Amortised payment, total interest, payoff time, pehle 12 mahine ka schedule |
| **Currency** | 50+ currencies, live rates + clearly labelled offline fallback |
| **Units** | Length, mass, temperature, volume, area, speed, time, data, energy, pressure |

### Verify kiye hue results

| Input | Output |
| --- | --- |
| BMI — 70 kg, 175 cm | **22.86** · Normal weight |
| Percentage — 15 % of 200 | **30** |
| Length — 10 km | **6.213712** miles |
| Loan — $300,000 · 5 % · 30 y | **$1,610.46** / month |
| Temperature — 100 °C | **212 °F** |
| Age — 15 Jun 2000 → 1 Oct 2026 | **26 years, 3 months, 16 days** |
| 2.5 US gal | **9.463529** litres |

---

## Currency rates: live ya fixed, hamesha label

Yehi ek hissa hai jo internet use karta hai, aur UI kabhi nahi chhupata ki aap
kaunsa number dekh rahe hain.

- **Live** — `open.er-api.com` se, fallback `frankfurter.app`. Hara pill source
  aur timestamp dikhata hai. Har 30 minute refresh.
- **Fixed** — `2025-06` ka stored offline snapshot. Laal pill:
  `Offline — using fixed reference rates (2025-06)`, aur line par saaf likha hota
  hai *"this is a stored reference snapshot, not a live market price."*

Dono hi **mid-market reference values hain, bina kisi fee ke**. Bank aur card
network hamesha thoda behtar rate dete hain — yeh baat card par khud likhi hai.

---

## File ke andar kya kahan hai

Sab kuch `index.html` mein hai, is order mein:

1. `<head>` — SEO meta, inline CSS (`<style>`), inline SVG favicon
2. Page body — header, hero, sidebar nav, 8 `<article class="card">` blocks
3. Inline JavaScript — 10 `<script>` blocks, har ek aik calculator:
   `core` (shared helpers) → `basic` → `age` → `bmi` → `percentage` →
   `gpa` → `loan` → `currency` → `units` → `app` (theme, search, scroll-spy)

### Kuch badalne ke liye

- **Colours / dark mode** — `<style>` ke shuru mein `:root` block. Har rang ek
  `--token` hai. `--brand` badlo, poori site badal jaati hai. Dark mode uske
  turant baad `[data-theme="dark"]` block mein hai.
- **Koi nayi unit** — `const CATEGORIES` (units script mein). Har unit ek line:
  `['mi', 'Mile', 1609.344]`. Temperature alag hai, woh ratio nahi affine hai.
- **GPA mapping** — `MAP_40` / `MAP_43` / `MAP_50` / `MAP_10`. Abhi `4.0` scale
  par `A+ = A = 4.0` hai (common US convention). Apne syllabus ke hisaab se badal lein.
- **Currency snapshot** — `const FIXED` aur `SNAPSHOT_DATE`. Numbers aur date dono
  update karein, warna UI jhooth bol raha hoga.
- **Naya calculator** — `bmi.js` ka wala section copy karo, numbers badlo, phir
  `index.html` mein nayi `<article class="card" id="x">` block aur sidebar link
  add karo. Search, scroll-spy, deep links aur accessibility khud ban jaate hain.

> **Notepad mein save karte waqt Encoding: UTF-8 chuno.** Warna `−`, `×`, `÷`
> jaise symbols kharab ho jaate hain aur GPA dropdown labels toot jaate hain.

---

## Quality checks

- Lighthouse **100 / 100 / 100** — accessibility, best practices, SEO ( dono themes).
- Page par sirf **ek** network request: currency API. Koi font request nahi,
  koi tracker nahi. System font use hota hai.
- Koi horizontal overflow nahi 320px se 1600px tak, har breakpoint par test kiya.
- Console errors: 0.
- Sirf ek cheez `localStorage` mein save hoti hai: light/dark choice.

## Accuracy

- **BMI** — WHO adult cut-offs. Population screening tool, diagnosis nahi.
- **GPA** — standard US mapping; rounding answer badle to bina round wala value bhi dikhata hai.
- **Loan** — standard monthly amortisation. Fees, PMI, points, aur rate reset
  shamil nahi. Lender se verify karein.
- **Units** — jahan exact definition hai wahi use hota hai (1 mile = 1609.344 m,
  1 lb = 0.45359237 kg); averages jaise "month = 30.44 din" openly label hain.

Yahan koi financial, medical ya legal advice nahi hai.
