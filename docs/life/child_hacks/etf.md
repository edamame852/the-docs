---
layout: default
parent: Life Hacks
title: ETF hacks
---
# US TAX
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## ETF filing (estate tax)

### US-domiciled ETFs vs Irish-domiciled ETFs
- US-domiciled ETFs (e.g. SPY, QQQ, VOO, VTI, VT ...)
    - What I should hold: (US Domicled equivalent ETF)
        - VT (Vanguard Total World Stock)
        - VEA / IDEV (developed ex-US)
        - AVUV + AVDV (Avantis US + International Small Cap Value — same manager, same strategy, split into two funds)
        - IEF (iShares 7-10 Year Treasury) /  VGIT (Vanguard Intermediate Treasury)
- Irish-domiciled ETFs (e.g. CSPX, SWDA, VWRL, EIMI, EUNA, EUNL)
    - What I hold now:
        - VWRA (Vanguard FTSE All-World) [Sector: Global all-cap equity]
        - EXUS (Xtrackers MSCI World ex-USA) [Sector: Developed markets ex-US]
        - AVGS (Avantis Global Small Cap Value) [Sector: Global small-cap value, actively managed]
        - CSBGU0 (iShares $ Treasury 7-10yr) [Sector: US Treasuries 7–10yr]

### Issues with PFIC
- PFIC =  Passive Foreign Investment Companies
    - Max tax rate = 43.4% (37% + 3.8% NIIT + 2.6% state tax) + Interest charge (interest on the tax due) EACH YEAR
    - You also have to file for Form 8621 (PFIC Annual Information Statement) EACH YEAR PER FUND
    - PFIC interest charge compounds with time
    - Solution: Purchase US-domiciled ETFs via US brokerage to avoid PFIC issues


### Assumptions on gradual withdrawal
- Gradual withdrawal = portfolio stays invested at 7.5%, drawn over 25 years AFTER 65
    - If de-risk into bonds:
    - If just like usual (ETF): 268k USD a month  

### Scenario 1: Holding Irish-domiciled ETFs as a US citizen, Holding Irish-domiciles ETFs as a HK only citizen, Holding US-domiciled ETFs as a US citizen (retire in Hong Kong), Holding US-domiciled ETFs as a US citizen (retire in US)

- Ground rules and assumptions
    - Starting portfolio: 12,400 USD / 97,000 HKD
    - Monthly contribution: 1,282 USD (10,000 HKD @ 7.8) × 432 months (age 29 → 65)
    - Assume 7.5% annual return (0.625% monthly, nominal compounded monthly)
    - FV of monthly contributions: FV = P × [(1+r)^n − 1] / r
        - = 1,282 × [(1.00625)^432 − 1] / 0.00625 ≈ 2,821,000 USD
    - FV of starting portfolio: 12,400 × (1.075)^36 ≈ 168,000 USD
    - Portfolio at 65: ≈ 2,990,000 USD
    - Total basis: 553,800 (contributions) + 12,400 (start) ≈ 566,000 USD
    - Total gain: ≈ 2,420,000 USD
    - Worst-case tax rate assumption: 43.4% (37% + 3.8% NIIT + 2.6% state)
    - IRS underpayment interest assumption: 7%/year, compounded
    - Gradual withdrawal model: portfolio stays invested at 7.5%, drawn over
      25 years (age 65–90) → ~268,000 USD/year, ~6.7M USD total extracted

- Scenario 1a: US person + Irish ETFs, §1291 default (worst case)
    - Form 8621 filed annually with no election → default "excess distribution" regime
    - Accumulating UCITS funds = no distributions → entire 2.42M gain becomes
      an excess distribution at sale
    - Gain allocated ratably over 36 years (~67,300/year), each prior year taxed
      at max ordinary rate (37%) regardless of actual bracket, plus compound
      interest charge on each year's deemed tax
    - Lump-sum liquidation at 65:
        - Total tax + interest: ≈ −3.70M USD
        - Net position: ≈ −710,000 USD (tax bill EXCEEDS the portfolio)
        - Effective tax rate: ~153% of gain
    - Gradual withdrawal: WORSE, not better
        - §1291 rate is fixed at max ordinary rate by statute — 0% LTCG bracket
          never applies, retirement income level is irrelevant
        - Each year of deferral adds ~7% compound interest; lots held 50+ years
          exceed 200% effective tax
        - No step-up at death (death = deemed disposition for §1291 stock)
        - Net extractable wealth: ≈ 0 or negative
    - PnL summary: contributed 566K → net −710K (lump) / ~0 (gradual)

- Scenario 1b: US person + Irish ETFs, Mark-to-Market election (Form 8621, §1296)
    - All unrealized gains taxed ANNUALLY at ordinary rates (43.4% worst case)
    - No interest charge, but compounding rate cut from 7.5% → ~4.25% after tax
    - Portfolio at 65: ≈ 1.36M USD (fully after-tax)
    - Gradual withdrawal (25 years, MTM continues at lower retirement rates):
        - Total extracted: ≈ 2.9M gross, ~2.6–2.7M net
    - Damage occurred during accumulation — retirement strategy can't repair it
    - PnL summary: contributed 566K → net ~1.36M (lump) / ~2.65M (gradual)
    - Note: QEF election would be better but UCITS funds almost never provide
      the required annual information statements

- Scenario 2: Holding Irish-domiciled ETFs as a HK-only citizen (benchmark)
    - HK: no capital gains tax; Ireland: 0% withholding for non-residents
    - Only leak: 15% internal US dividend withholding (already inside fund NAV)
    - Lump-sum at 65: 2.99M USD, tax = 0
    - Gradual withdrawal: 6.7M USD extracted over 25 years, tax = 0
    - PnL summary: contributed 566K → net 2.99M (lump) / 6.7M (gradual)

- Scenario 3: US citizen + US-domiciled ETFs, retire in Hong Kong
    - Citizenship-based taxation follows you, but no state tax abroad;
      HK adds nothing
    - Lump-sum liquidation: 2.42M gain × 23.8% (20% LTCG + 3.8% NIIT)
        - Tax: −576,000 → net 2.41M USD
    - Gradual withdrawal (~268K/year):
        - Standard deduction (~17.6K at 65+) + 0% LTCG bracket (~49K) shelter
          first ~65K; remainder mostly at 15%; small NIIT above 200K MAGI
        - Effective rate on gains: ~10–11%
        - Total tax over 25 years: ≈ 650K
        - Net extracted: ≈ 6.05M USD
    - PnL summary: contributed 566K → net 2.41M (lump) / ~6.05M (gradual)

- Scenario 4: US citizen + US-domiciled ETFs, retire in US
    - Same federal treatment as Scenario 3, plus 2.6% state tax on all gains
      (state ignores the 0% federal bracket)
    - Lump-sum liquidation: 2.42M × 26.4%
        - Tax: −639,000 → net 2.35M USD
    - Gradual withdrawal:
        - Federal ~650K + state ~160K ≈ 810K total tax
        - Net extracted: ≈ 5.9M USD
    - PnL summary: contributed 566K → net 2.35M (lump) / ~5.9M (gradual)
    - Mitigation: retire in a no-income-tax state → converges to Scenario 3

- Final scoreboard

| Scenario                     | Lump sum net | Gradual net | Effective tax on gains |
|------------------------------|--------------|-------------|------------------------|
| 2. HK-only + Irish ETFs      | +2.99M       | +6.7M       | 0%                     |
| 3. US citizen + US ETFs (Retire HK) | +2.41M       | ~+6.05M     | ~10%                   |
| 4. US citizen + US ETFs (Retire US) | +2.35M       | ~+5.9M      | ~12–13%                |
| 1b. US citizen + Irish ETFs, MTM          | +1.36M       | ~+2.65M     | ~50%+                  |
| 1a. US citizen + Irish ETFs, §1291        | −710K        | ~0          | 150–200%+              |

- Key takeaways
    - Filing Form 8621 does not reduce tax — it is only the reporting vehicle;
      the default regime (§1291) is the punitive one
    - Gradual withdrawal rescues Scenarios 3/4 (23.8% → ~10%) but does nothing
      for PFIC scenarios: MTM damage happens during accumulation, §1291
      worsens with every year of deferral
    - Spread between best and worst US-person outcome: ~3.1–3.7M USD on
      identical investments — determined entirely by fund domicile
    - One free move available: sell all UCITS funds BEFORE US tax residency
      begins (tax-free in HK, resets basis), rebuy US equivalents
      (VWRA→VT, EXUS→VEA/IDEV, AVGS→AVUV+AVDV, CSBGU0→IEF/VGIT)
    - All figures are illustrative approximations: real §1291 runs lot-by-lot
      (432 lots), IRS rates float quarterly, brackets are inflation-indexed;
      rankings are robust, absolute values are ±10%