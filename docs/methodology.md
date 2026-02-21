# Complementary and Alternative Medicine in Europe

## Research context

This project investigates the determinants of Complementary and Alternative Medicine (CAM) use across Europe, drawing on data from the European Social Survey (ESS). Two competing hypotheses structure the analysis: the **"push" hypothesis**, which posits that CAM use is driven by difficulties accessing conventional healthcare, and the **"pull" hypothesis**, which frames CAM use as a reflection of personal values — particularly openness to change and holistic worldviews.

The central questions are:

1. What are the socio-demographic, structural, and cultural determinants of CAM use in Europe?
2. Is the intensity of CAM use (number of different practices) associated with subjective health, depressive symptoms, and functional limitations?
3. Is CAM use better predicted by access barriers ("push") or value orientations ("pull")?
4. Do these determinants vary across CAM types and national contexts?

---

## Data source

The dataset is the European Social Survey (ESS) Round 11 edition 4.1 (2023). You can find more information in the `data/raw` directory.

---

## Tools used

R studio and, as this is my first R project, Claude (free account) to help me with the code syntax.

---

## Analytical strategy

#### Step 1 : Descriptive statistics

Simple prevalence tables, distribution, and testing for mutually exclusive groups (2x2 : CAM only, conventional only, neither, both) on health outcomes with Kruskal-Wallis test.

#### Step 2 : Latent Class Analysis

Clusterizing the sample to see if latent profiles of CAM users exist or not. And just then, after computing for hours to be completly sure they doesn't exist, generating a tetrachorich correlation matrix to validate poor average underlying structure in the dataset (*average correlation = 0.278*).

#### Step 3 : MANCOVA

Testing the association between the intensity of CAM use (`mca_category`: 0, 1, 2-3, or 4+ practices) and a multivariate health vector composed of 8 health variables (subjective health, daily limitations, musculoskeletal, atopic/inflammatory, digestive, cardiovascular, severe headaches, and depression score) + age and access difficulties as covariates. Because n=+50000 Pillai's trace was used.

Then I did univariate step-down ANCOVAs and post-hoc pairwise comparisons (estimated marginal means with Bonferroni adjustment) to evaluate specific "dose-response" profiles, here we saw a clear contrast between physical symptoms (highly significant) and the depression score (not significant).

#### Step 4 : Regression models

4 round of hierarchical block entry to test the predictive value of each predictor set :

- **dependent variable** : `mca_any` (used at least one CAM in the 12 month)

- **Block 1** : socio-demographics (age, gender, education, income, rural or urban)

- **Block 2** : health needs (subjective health, functional limitations, depression score, musculoskeletal problems, digestive problems, inflammatory problems, cardiovascular problems, severe headaches)

- **Block 3** : access difficulties to conventional health system (push hypothesis)

- **Block 4** : value orientations : openness, tradition (pull hypothesis)

The main interest here was initially the added values of the blocks 3 and 4 in the following models (with Nagelkerke pseudo-R² and Hosmer-Lemeshow goodness-of-fit every time) :

- **Model A** : Binary logistic regression

- **Model B** : Negative binomial regression (testing the *how much*, so `mca_count` instead of `mca_any`)

- **Models C** : Same as A but on specifics CAM, mostly exploratory

- **Models D** : Same as A but on groups of CAM divides by level of acceptation in society (paraconventional, tolerated, heterodox and marginal), the idea here was to investigate more precisly the pull factor (values) but I didn't get great results.

## Hypotheses

| #   | Hypothesis                                                                                                     | Statistical test                     | Result |
| --- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------ | ------ |
| H1  | Their exist subcultures of practices towards CAM (latent profiles)                                             | LCA, Tetrachoric correlations        | False  |
| H2  | The number of CAM types used is associated with the multivariate health vector, controlling for age and access | MANCOVA                              | True   |
| H3  | Access difficulties (push) predict CAM use beyond socio-demographic                                            | Logistic regression : ΔR² at Block 3 | True   |
| H4  | Value orientations (pull) predict CAM use beyond socio-demographic and access variables                        | Logistic regression : ΔR² at Block 4 | False  |
| H5  | Determinants of CAM use differ across specific CAM types                                                       | CAM-specific logistic regressions    | True   |



## Variables used :

* `trhltacu` : Treatments used for own health, last 12 months: acupuncture 
* `trhltho` : Treatments used for own health, last 12 months: homeopathy 
* `trhltht` : Treatments used for own health, last 12 months: herbal treatment 
* `trhltch` : Treatments used for own health, last 12 months: chiropractics 
* `trhltos` : Treatments used for own health, last 12 months: osteopathy 
* `trhltpt` : Treatments used for own health, last 12 months: physiotherapy 
* `trhltre` : Treatments used for own health, last 12 months: reflexology 
* `trhltsh` : Treatments used for own health, last 12 months: spiritual healing 
* `trhltacp` : Treatments used for own health, last 12 months: acupressure 
* `trhltcm` : Treatments used for own health, last 12 months: chinese medicine 
* `trhlthy` : Treatments used for own health, last 12 months: hypnotherapy 
* `trhltmt` : Treatments used for own health, last 12 months: massage therapy 
* `dshltgp` : Discussed health, last 12 months: general practitioner 
* `dshltms` : Discussed health, last 12 months: medical specialist 
* `medtrun` : Unable to get medical consultation or treatment, last 12 months 
* `medtrnp` : No medical consultation or treatment, reason: could not pay 
* `medtrnt` : No medical consultation or treatment, reason: could not take time off work 
* `medtrnl` : No medical consultation or treatment, reason: not available where you live 
* `medtrwl` : No medical consultation or treatment, reason: waiting list too long 
* `medtrnaa` : No medical consultation or treatment, reason: no appointments available 
* `health` : Subjective general health 
* `hlthhmp` : Hampered in daily activities by illness/disability/infirmity/mental problem 
* `hltprhc` : Health problems, last 12 months: heart or circulation problem 
* `hltprhb` : Health problems, last 12 months: high blood pressure 
* `hltprdi` : Health problems, last 12 months: diabetes 
* `hltprbn` : Health problems, last 12 months: back or neck pain 
* `hltprpa` : Health problems, last 12 months: muscular or joint pain in hand or arm 
* `hltprpf` : Health problems, last 12 months: muscular or joint pain in foot or leg 
* `hltprbp` : Health problems, last 12 months: breathing problems 
* `hltpral` : Health problems, last 12 months: allergies 
* `hltprsc` : Health problems, last 12 months: skin condition related 
* `hltprsd` : Health problems, last 12 months: stomach or digestion related 
* `hltprsh` : Health problems, last 12 months: severe headaches 
* `fltdpr` : Felt depressed, how often past week 
* `flteeff` : Felt everything did as effort, how often past week 
* `slprl` : Sleep was restless, how often past week 
* `wrhpp` : Were happy, how often past week 
* `fltlnl` : Felt lonely, how often past week 
* `enjlf` : Enjoyed life, how often past week 
* `fltsd` : Felt sad, how often past week 
* `cldgng` : Could not get going, how often past week 
* `ipcrtiva` : Important to think new ideas and being creative 
* `impdiffa` : Important to try new and different things in life 
* `ipadvnta` : Important to seek adventures and have an exciting life 
* `impenva` : Important to care for nature and environment 
* `iphlppla` : Important to help people and care for others well-being 
* `imptrada` : Important to follow traditions and customs 
* `impsafea` : Important to live in secure and safe surroundings 
* `impricha` : Important to be rich, have money and expensive things 
* `gndr` : Gender 
* `agea` : Age of respondent, calculated 
* `eisced` : Highest level of education, ES - ISCED 
* `hinctnta` : Household's total net income, all sources 
* `cntry` : Country 
* `domicil` : Domicile, respondent's description 
* `anweight` : Analysis weight 
* `pspwght` : Post-stratification weight including design weight 
* `pweight` : Population size weight (must be combined with dweight or pspwght)
  
   

## Built variables and composite scores :

* `mca_count` : Sum of the 12 alternative medicines used by the respondent (0 to 12) 
* `mca_any` : Binary indicator showing if at least 1 alternative medicine was used 
* `score_cardio` : Sum of cardiovascular problems (`hltprhc`, `hltprhb`, `hltprdi`) 
* `score_musculo` : Sum of musculoskeletal pain/problems (`hltprbn`, `hltprpa`, `hltprpf`) 
* `score_atopi_inflam` : Sum of atopic and inflammatory problems (`hltprbp`, `hltpral`, `hltprsc`) 
* `cesd_wrhpp_inv` : Inverted score of the positive CES-D item `wrhpp` 
* `cesd_enjlf_inv` : Inverted score of the positive CES-D item `enjlf` 
* `cesd_n_valid` : Count of individual valid items remaining per respondent for the CES-D scale 
* `cesd_score` : Prorated 8-item depression index (calculated only for respondents with >= 6 valid items) 
* `access_difficulties` : Sum of structural access barriers to healthcare (`medtrnp`, `medtrnt`, `medtrnl`, `medtrwl`, `medtrnaa`) 
* `ouverture` : Mean of values indicating openness to change (`ipcrtiva`, `impdiffa`, `ipadvnta`) 
* `tradition` : Mean of values indicating tradition and security (`imptrada`, `impsafea`) 
* `cross_country_weight` : Multiplied probability weight (`pspwght` * `pweight`) for cross-country European representativeness 
* `care_type` : 4-level typology overlapping conventional visits (`dshltgp`, `dshltms`) and CAM use (`mca_any`): "Neither", "Conventional only", "CAM only", "Both" 
* `mca_category` : Categorical grouping of CAM use intensity based on `mca_count` ("0", "1", "2-3", "4+") 
* `grp1_paraconv` : Binary indicator mapping therapies considered as "paraconventional"  (Physiotherapy, Osteopathy)
* `grp2_tolerated` : Binary indicator mapping therapies considered as "tolerated" (Massage, Homeopathy, Herbal treatment) 
* `grp3_heterodox` : Binary indicator mapping therapies considered as "heterodox" (Acupuncture, Chiropractic, Chinese medicine, Hypnotherapy) 
* `grp4_marginal` : Binary indicator mapping therapies considered as "marginal" (Spiritual healing, Reflexology, Acupressure) 
