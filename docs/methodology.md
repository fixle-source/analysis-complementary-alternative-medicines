
# Methodology

## Research context

This project investigates the determinants of Complementary and Alternative Medicine (CAM)
use across Europe, drawing on data from the European Social Survey (ESS). Two competing
hypotheses structure the analysis: the **"push" hypothesis**, which posits that CAM use is
driven by difficulties accessing conventional healthcare, and the **"pull" hypothesis**, which
frames CAM use as a reflection of personal values — particularly openness to change and
holistic worldviews.

The central questions are:

1. What are the socio-demographic, structural, and cultural determinants of CAM use in Europe?
2. Is the intensity of CAM use (number of different practices) associated with subjective
   health, depressive symptoms, and functional limitations?
3. Is CAM use better predicted by access barriers ("push") or value orientations ("pull")?
4. Do these determinants vary across CAM types and national contexts?

---

## Data source

The dataset is the **European Social Survey (ESS) Round 11 edition 4.1 (2023)**, a cross-
national survey conducted across European countries. The ESS rotating module on health 
provides detailed information on healthcare utilisation — including 12 types of CAM — alongside
measures of health status, access barriers, and personal values via the Portrait Values 
Questionnaire (PVQ).

Weights used:
- `anweight` for descriptive statistics on the pooled sample
- `pspwght × pweight` for cross-country comparisons

---

## Variables

### CAM use (binary indicators)

Twelve binary variables capture whether the respondent has used each type of CAM in the
past 12 months:

| Variable     | Practice                |
|--------------|-------------------------|
| `trhltacu`   | Acupuncture             |
| `trhltho`    | Homeopathy              |
| `trhltht`    | Herbal treatment        |
| `trhltch`    | Chiropractic            |
| `trhltos`    | Osteopathy              |
| `trhltpt`    | Physiotherapy           |
| `trhltre`    | Reflexology             |
| `trhltsh`    | Spiritual healing       |
| `trhltacp`   | Acupressure             |
| `trhltcm`    | Chinese medicine        |
| `trhlthy`    | Hypnotherapy            |
| `trhltmt`    | Therapeutic massage     |

From these, two derived variables are constructed:

- **`mca_any`** (binary): whether the respondent used at least one CAM (excluding
  physiotherapy and therapeutic massage, which are frequently prescribed within
  conventional care pathways)
- **`mca_count`** (count): number of distinct CAM types used

### Conventional healthcare use

- `dshltgp`: consulted a general practitioner
- `dshltms`: consulted a medical specialist

### Access barriers (push hypothesis)

- `medtrun`: unable to obtain medical consultation or treatment
- `medtrnp`: reason — could not afford it
- `medtrnt`: reason — could not take time off
- `medtrnl`: reason — not available locally
- `medtrwl`: reason — waiting list too long
- `medtrnaa`: reason — no appointment available

A composite **access difficulty score** is computed as:

```r
access_difficulties <- medtrnp + medtrnt + medtrnl + medtrwl + medtrnaa
```

### Health outcomes

**Subjective health:**
- `health`: self-rated health (ordinal scale)
- `hlthhmp`: limitations in daily activities

**Depressive symptoms (CES-D derived score):**

- `fltdpr`: Felt depressed
- `flteeff`: Felt everything did as effort
- `slprl`: Sleep was restless
- `fltlnl`: Felt lonely
- `fltsd`: Felt sad
- `cldgng`: Could not get going
- `wrhpp`: Were happy
- `enjlf`: Enjoyed life

Constructed from 8 items, with positive items reverse-coded:

```r
cesd_score <- fltdpr + flteeff + slprl + (5 - wrhpp) +
              fltlnl + (5 - enjlf) + fltsd + cldgng
```

Internal consistency is verified via Cronbach's α (threshold: > 0.70).

**Musculoskeletal pain:**
- `hltprbn`: back/neck pain
- `hltprpa`: arm/hand muscle pain
- `hltprpf`: leg/foot muscle pain

### Value orientations (pull hypothesis)

From the Portrait Values Questionnaire (PVQ):

| Variable     | Value dimension              |
|--------------|------------------------------|
| `ipcrtiva`   | Creativity (openness)        |
| `impdiffa`   | Novelty (stimulation)        |
| `ipadvnta`   | Adventure (excitement)       |
| `impenva`    | Environment (universalism)   |
| `iphlppla`   | Helping others (benevolence) |
| `imptrada`   | Tradition (conformity)       |
| `impsafea`   | Security                     |
| `impricha`   | Power / achievement          |

Two composite scores are derived:

```r
ouverture  <- (ipcrtiva + impdiffa + ipadvnta) / 3
tradition <- (imptrada + impsafea) / 2
```

### Controls

- `gndr`: gender
- `agea`: age
- `eisced`: education level (ISCED classification)
- `hinctnta`: household income
- `cntry`: country
- `domicil`: urban/rural residence

---

## Analytical strategy

### Step 1 — Exploratory analysis: testing for latent profiles

**Initial plan.** The original design called for a Latent Class Analysis (LCA) on the 12
CAM binary indicators (plus general practitioner and specialist consultations) to identify 
coherent healthcare utilisation profiles — e.g., "exclusive conventionals", "active pluralists",
"targeted alternative users", "holistic/spiritual users", and "non-users".

**What happened.** Tetrachoric correlations across the 12 CAM variables yielded a mean
coefficient of **r̄ = 0.278**, indicating a relative independence between practices. LCA models
from 2 to 7 classes showed poor fit (unstable BIC, low entropy), confirming the absence
of a meaningful latent structure.

**Interpretation.** This is a substantive finding, not merely a technical failure. It
suggests that CAM use in Europe is not organised into coherent "medical subcultures".
Individuals do not adopt a global orientation toward alternative medicine; rather, they
make specific, independent choices for each type of CAM. Someone who consults an
osteopath is not particularly more likely to also use homeopathy.

**Consequence.** The analytical strategy was redirected: instead of comparing latent
profiles, the analysis focuses on (a) determinants of overall CAM use and intensity,
and (b) whether these determinants differ across CAM types.

### Step 2 — Descriptive statistics

Before modelling, the data are thoroughly documented:

- **Prevalence table**: proportion of users for each of the 12 CAM types, overall and
  stratified by country
- **Intensity distribution**: frequency distribution of the number of distinct CAM types
  used (0, 1, 2–3, 4+)
- **Conventional/CAM overlap**: a 2×2 cross-tabulation yielding four mutually exclusive
  groups (neither, conventional only, CAM only, both), compared on health outcomes via
  Kruskal-Wallis tests

### Step 3 — Regression models

Three sets of regression models are estimated, all using hierarchical block entry to
assess the incremental explanatory power of each predictor set.

#### Model A: Binary logistic regression

- **Dependent variable**: `mca_any` (used at least one CAM: yes/no)
- **Block 1**: socio-demographics (age, gender, education, income)
- **Block 2**: access barriers (push hypothesis)
- **Block 3**: health needs (subjective health, functional limitations, musculoskeletal pain)
- **Block 4**: value orientations — openness, tradition (pull hypothesis)

Reported: Nagelkerke pseudo-R², change in −2LL with significance test at each block,
Hosmer-Lemeshow goodness-of-fit.

The key test of the push vs. pull debate lies in comparing the incremental R² of Block 2
(access barriers) against Block 4 (values).

#### Model B: Poisson / Negative binomial regression

- **Dependent variable**: `mca_count` (number of distinct CAM types used)
- **Same predictor blocks** as Model A

This model addresses a distinct question: what predicts *multiplying* CAM use, as opposed
to simply initiating it? Overdispersion is tested; if variance substantially exceeds the
mean, a negative binomial specification is preferred.

#### Model C: CAM-specific logistic regressions

For the 3–4 most prevalent CAM types (likely osteopathy, physiotherapy, homeopathy),
separate binary logistic regressions are estimated with the same predictor structure.

The goal is to assess whether determinants are **homogeneous** or **practice-specific** —
for instance, musculoskeletal pain may predict osteopathy use but not homeopathy, while
openness values may predict homeopathy but not physiotherapy. This partially compensates
for the absence of latent profiles by revealing differentiated logics across practices.

### Step 4 — MANCOVA: CAM intensity and health outcomes

**Design:** One-way MANCOVA with:

- **Independent variable**: CAM intensity, recoded into ordinal categories (0, 1, 2–3, 4+)
- **Dependent vector**: [subjective health, CES-D depressive score, functional limitations]
- **Covariates**: age, composite access difficulty score

This tests whether individuals who use more types of CAM differ on the multivariate
health vector, after adjusting for age and structural access factors. The MANCOVA is
followed by univariate ANCOVAs on each outcome for interpretation, with post-hoc pairwise
comparisons (Bonferroni-corrected).

Assumptions checked: multivariate normality (Shapiro-Wilk on residuals), homogeneity of
variance-covariance matrices (Box's M test), linearity between covariates and DVs.

**Interpretive caution.** The cross-sectional nature of the ESS data means that any
association between CAM intensity and health outcomes cannot be interpreted causally. It
is plausible that poorer health drives greater CAM use (reverse causation) rather than CAM
use affecting health.

### Step 5 — Multilevel model: country-level variation

**Structure**: individuals (level 1) nested within countries (level 2).

```
Level 1: logit(MCA_ij) = β₀j + β₁(age) + β₂(education) + β₃(access) + β₄(values) + εᵢⱼ
Level 2: β₀j = γ₀₀ + u₀j
```

This model addresses two questions:

- **How much variance is attributable to country?** Captured by the intraclass
  correlation coefficient (ICC). A high ICC would indicate that national-level factors
  (health system design, CAM regulation, cultural attitudes) substantially shape
  individual CAM use.
- **Do predictor effects vary across countries?** Tested by allowing random slopes for
  key predictors (e.g., value orientations). If the openness–CAM relationship varies by
  country, this suggests cultural or institutional moderation.

---

## Hypotheses

| #  | Hypothesis                                                                                      | Statistical test                              |
|----|-------------------------------------------------------------------------------------------------|-----------------------------------------------|
| H1 | CAM practices are mostly independent of one another (no coherent latent profiles)             | Tetrachoric correlations, LCA fit indices     |
| H2 | The number of CAM types used is associated with the multivariate health vector, controlling for age and access | MANCOVA: Pillai's trace              |
| H3 | Value orientations (openness) predict CAM use beyond socio-demographic and access variables    | Logistic regression: ΔR² at Block 4          |
| H4 | Access barriers (push) and values (pull) make independent contributions to CAM use            | Comparison of Blocks 2 and 4 incremental fit  |
| H5 | Determinants of CAM use differ across specific CAM types                                       | CAM-specific logistic regressions             |
| H6 | Country explains a significant share of variance in CAM use                                    | Multilevel model: ICC significance            |



---

## Software

All analyses are conducted in **R**. Key packages:

- `poLCA` — latent class analysis (exploratory step)
- `psych` — tetrachoric correlations, Cronbach's α, descriptive statistics
- `MASS`, `glm` — logistic and count regression models
- `lme4` — multilevel modelling
- `car` — MANOVA/MANCOVA
- `ggplot2` — visualisation

