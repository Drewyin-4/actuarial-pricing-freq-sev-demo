# Frequency–Severity Pricing Model (P&C Insurance)

## Project Overview
This project builds a claim-level frequency–severity pricing model for a property and casualty (P&C) insurance portfolio.  
Claim frequency and claim severity are modeled separately using generalized linear models (GLMs), and combined to produce an indicated pure premium.

The objective is to demonstrate a standard actuarial pricing workflow using claim-level data, with an emphasis on interpretability and reproducibility.

---

## Business Context
In insurance pricing, expected loss cost is often decomposed into:
\[
\text{Pure Premium} = \mathbb{E}[\text{Claim Count}] \times \mathbb{E}[\text{Claim Severity}]
\]

This frequency–severity framework is widely used in P&C pricing to:
- Understand drivers of risk at a granular level
- Build transparent and explainable rating structures
- Support rate indications and portfolio analysis

---

## Data
The analysis uses the `ClaimsLong` dataset from the R package `insuranceData`.

- Simulated automobile insurance data commonly used for actuarial modeling practice
- 40,000 policies observed over 3 periods (≈120,000 policy-period records)
- Key variables include:
  - `numclaims`: number of claims per policy-period
  - `claim`: total claim amount
  - `agecat`: driver age category
  - `valuecat`: vehicle value category

Each record is treated as one policy-period with exposure equal to 1.

---

## Methodology

### Frequency Model
- Model: Poisson GLM
- Response: claim count
- Offset: log(exposure)
- Predictors: driver age category, vehicle value category

### Severity Model
- Model: Gamma GLM with log link
- Response: claim amount
- Fitted on policy-periods with positive claims only
- Predictors: driver age category, vehicle value category

### Pricing Indication
Predicted pure premium is calculated as:
\[
\widehat{\text{Pure Premium}} = \widehat{\mathbb{E}[\text{Claim Count}]} \times \widehat{\mathbb{E}[\text{Claim Severity}]}
\]

An exposure-weighted average is used to obtain the overall indicated pure premium.

---

## Results
The frequency–severity model produces an indicated pure premium based on claim-level GLMs.

- Final indicated pure premium is reported in `outputs/indicated_pp_freqsev.txt`
- Rating-level summaries are available in `outputs/pricing_summary.csv`
- Model coefficients for frequency and severity are provided for interpretability

---

## How to Run
Run the full analysis pipeline from the project root:

```r
source("scripts/00_run_all.R")
