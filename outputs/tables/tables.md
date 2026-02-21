
#### Table 2.1 : Weighted prevalence of CAM types

|Practice            |Prevalence (%) |95% Confidence Interval |
|:-------------------|:--------------|:-----------------------|
|Physiotherapy       |18.1%          |[17.5% – 18.8%]         |
|Therapeutic massage |10.5%          |[10.0% – 10.9%]         |
|Osteopathy          |6.9%           |[6.5% – 7.3%]           |
|Herbal treatment    |4.8%           |[4.5% – 5.1%]           |
|Homeopathy          |3.4%           |[3.1% – 3.7%]           |
|Acupuncture         |2.7%           |[2.4% – 3.0%]           |
|Chiropractic        |2.6%           |[2.3% – 2.9%]           |
|Spiritual healing   |1.5%           |[1.4% – 1.7%]           |
|Chinese medicine    |1.2%           |[1.0% – 1.3%]           |
|Reflexology         |1.2%           |[1.0% – 1.3%]           |
|Hypnotherapy        |0.6%           |[0.5% – 0.8%]           |
|Acupressure         |0.6%           |[0.4% – 0.7%]           |


#### Table: Table 2.2 : CAM prevalence by country (weighted)

|Country |Prevalence (%) |
|:-------|:--------------|
|IS      |54.5%          |
|CH      |54.4%          |
|FR      |50.6%          |
|EE      |48.4%          |
|DE      |47.8%          |
|LT      |45.8%          |
|NL      |45.3%          |
|FI      |44.6%          |
|SE      |44.3%          |
|BE      |43.9%          |
|AT      |41.8%          |
|SI      |38.8%          |
|SK      |38.3%          |
|NO      |37.7%          |
|ES      |35.2%          |
|LV      |31.8%          |
|CY      |31.4%          |
|RS      |30.8%          |
|GB      |29.4%          |
|IL      |28.0%          |
|HR      |27.9%          |
|IE      |26.5%          |
|PL      |26.2%          |
|PT      |24.7%          |
|ME      |23.1%          |
|BG      |22.7%          |
|UA      |20.4%          |
|IT      |18.2%          |
|HU      |12.9%          |
|GR      |12.7%          |


#### Table 2.3 : Conventional medicine × CAM overlap

|care_type         |     n|%     |
|:-----------------|-----:|:-----|
|Neither           | 8201 |16.4% |
|Conventional only | 24581|49.0% |
|CAM only          | 1482 |3.0%  |
|Both              | 15852|31.6% |


#### Table 2.4 : Kruskal-Wallis: health outcomes by care type
Subjective health, depression score and hampered in daily activity

|Outcome    |       H| df|  p|
|:----------|-------:|--:|--:|
|health     | 2950.30|  3|  0|
|cesd_score |  553.84|  3|  0|
|hlthhmp    | 2238.33|  3|  0|


#### Table 3.1 : LCA with 14 variables fit indices (1 to 7 classes)
This is only a reconstruction of the original results with minimal LCA iteration parameters so as not to have to wait several hours. Therefore, these are probably not the optimal data, but the actual data were not satisfying either.

| Classes|    LogLik|      AIC|      BIC| Entropy|
|-------:|---------:|--------:|--------:|-------:|
|       1| -157633.0| 315293.9| 315417.4|     NaN|
|       2| -151144.1| 302346.1| 302602.0|   0.578|
|       3| -149889.2| 299866.4| 300254.6|   0.521|
|       4| -149496.2| 299110.4| 299630.9|   0.579|
|       5| -149277.6| 298703.2| 299356.0|   0.599|
|       6| -149158.6| 298495.2| 299280.4|   0.607|
|       7| -149126.5| 298461.0| 299378.5|   0.625|

Interpretation:
  - BIC     : lower is better
  - AIC     : lower is better (penalises complexity less than BIC)
  - Entropy : > 0.80 = well-separated classes
  
####  Table 3.2 : LCA with 12 variables fit indices (1 to 7 classes)
Second attempt excluding conventional medicine variables under the hypothesis that perhaps there are no latent classes in the sense of mixed conventional/alternative practices, but perhaps there are latent classes of CAM bundles practiced together (e.g., physical therapies, spiritual therapies, herbal medicine/homeopathy, etc.). 

| Classes|    LogLik|      AIC|      BIC| Entropy|
|-------:|---------:|--------:|--------:|-------:|
|       1| -93298.96| 186621.9| 186727.8|     NaN|
|       2| -88772.77| 177595.5| 177816.1|   0.696|
|       3| -88304.78| 176685.6| 177020.8|   0.724|
|       4| -88106.36| 176314.7| 176764.6|   0.674|
|       5| -88032.25| 176192.5| 176757.1|   0.680|
|       6| -87974.66| 176103.3| 176782.6|   0.711|
|       7| -87941.90| 176063.8| 176857.8|   0.579|

That wasn't conclusive either. The fit indices are better, but the evolution of the models shows that we still have a large mixed class with everything in it, and as we add more class to the model, we simply isolate one CAM from the others, and this is done in descending order of their frequency.

Other configurations for performing the LCA were attempted, but none produced significantly satisfying results:
- By removing from the dataset those who do not use any form of medicine
- Removing users of only conventional medicine from the dataset
- Removing only the specialist doctor variable from the variables, but not the general practitioner variable, because the wording of the question in the questionnaire seems to me to be interpretable as referring to a CAM practitioner, and this would potentially have created data points where the specialist variable and certain CAM variables would be dependent variables, which could confuse the LCA, which requires exclusively independent variables

### Table 4.1 : Multivariate Tests for CAM Intensity (MANCOVA)

*Note: Multivariate Analysis of Covariance evaluating the impact of CAM intensity category (0, 1, 2-3, 4+ practices) on the multivariate health vector (8 clinical outcomes).*

| Predictor | Test Statistic | Value (Pillai) | Approx. F | num Df | den Df | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Age (Covariate)** | Pillai's trace | 0.018 | 114.58 | 8 | 49,873 | < .001 |
| **Access Difficulties (Covariate)** | Pillai's trace | 0.052 | 341.53 | 8 | 49,873 | < .001 |
| **CAM Intensity (`mca_category`)** | Pillai's trace | 0.102 | 219.18 | 24 | 149,625 | < .001 |

*Data: ESS11 Health Module. Total N = 49,884. Assumptions: Box's M test and Shapiro-Wilk test significant due to large sample size; Pillai's trace used for robustness.*

### Table 4.2 : Univariate ANCOVA Results for CAM Intensity (mca_category)

*Note: Step-down univariate models assessing the specific effect of CAM intensity on each health outcome, adjusting for age and access difficulties. Degrees of freedom: 3 (mca_category), 49,880 (Residuals).*

| Dependent Variable | Sum of Sq (Hypothesis) | Mean Square | F-value | p-value | Interpretation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Musculoskeletal problems** | 3,514.0 | 1171.29 | 1490.14 | < .001 | Highly Significant |
| **Atopic & inflammatory problems** | 301.8 | 100.59 | 341.86 | < .001 | Highly Significant |
| **Digestive problems** | 107.1 | 35.69 | 313.36 | < .001 | Highly Significant |
| **Daily limitations (hlthhmp)** | 270.3 | 90.11 | 222.08 | < .001 | Highly Significant |
| **Severe headaches** | 58.5 | 19.50 | 198.14 | < .001 | Highly Significant |
| **Poor subjective health** | 229.9 | 76.64 | 90.47 | < .001 | Highly Significant |
| **Cardiovascular problems** | 22.8 | 7.59 | 15.86 | < .001 | Significant |
| **Depression score (CES-D)** | 111.0 | 37.10 | 2.18 | **0.088** | **Not Significant** |

### Table 4.3 : Pairwise Comparisons (Post-Hoc) for Key Health Outcomes

*Note: Estimated Marginal Means (EMMs) contrasts comparing clinical scores across CAM intensity levels. P-values are strictly adjusted using the Bonferroni method.*

| Health Outcome | Contrast | Estimate (Diff) | Standard Error | t-ratio | p-value (Bonferroni) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Musculoskeletal problems** | 0 vs 1 | −0.426 | 0.0098 | −43.38 | < .0001 |
| | 0 vs (2-3) | −0.708 | 0.0134 | −52.97 | < .0001 |
| | 0 vs (4+) | −0.916 | 0.0326 | −28.08 | < .0001 |
| | 1 vs (2-3) | −0.282 | 0.0150 | −18.73 | < .0001 |
| | 1 vs (4+) | −0.489 | 0.0333 | −14.69 | < .0001 |
| | (2-3) vs (4+) | −0.208 | 0.0344 | −6.03 | < .0001 |
| --- | --- | --- | --- | --- | --- |
| **Severe headaches** | 0 vs 1 | −0.0336 | 0.0035 | −9.65 | < .0001 |
| | 0 vs (2-3) | −0.0975 | 0.0047 | −20.62 | < .0001 |
| | 0 vs (4+) | −0.1529 | 0.0115 | −13.25 | < .0001 |
| | 1 vs (2-3) | −0.0640 | 0.0053 | −12.03 | < .0001 |
| | 1 vs (4+) | −0.1193 | 0.0118 | −10.13 | < .0001 |
| | (2-3) vs (4+) | −0.0554 | 0.0122 | −4.54 | < .0001 |
| --- | --- | --- | --- | --- | --- |
| **Poor subjective health** | 0 vs 1 | −0.1072 | 0.0102 | −10.51 | < .0001 |
| | 0 vs (2-3) | −0.1881 | 0.0139 | −13.56 | < .0001 |
| | 0 vs (4+) | −0.2057 | 0.0338 | −6.08 | < .0001 |
| | 1 vs (2-3) | −0.0809 | 0.0156 | −5.18 | < .0001 |
| | 1 vs (4+) | −0.0985 | 0.0346 | −2.85 | 0.0262 |
| | (2-3) vs (4+) | −0.0176 | 0.0358 | −0.49 | **1.0000 (ns)** |
| --- | --- | --- | --- | --- | --- |
| **Depression score (CES-D)** | 0 vs 1 | 0.0288 | 0.0458 | 0.63 | **1.0000 (ns)** |
| | 0 vs (2-3) | −0.1331 | 0.0622 | −2.14 | **0.1949 (ns)** |
| | 0 vs (4+) | −0.1501 | 0.1520 | −0.99 | **1.0000 (ns)** |
| | 1 vs (2-3) | −0.1618 | 0.0700 | −2.31 | **0.1245 (ns)** |
| | 1 vs (4+) | −0.1789 | 0.1550 | −1.15 | **1.0000 (ns)** |
| | (2-3) vs (4+) | −0.0170 | 0.1600 | −0.11 | **1.0000 (ns)** |

### Table 5.1 A : Hierarchical Logistic Regression - Incremental Model Fit

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 2.64% | - | 62,615 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio, score_musculo... + cesd_score` | 13.71% | + 11.07% | 58,389 | 4,226.3 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 14.20% | + 0.49% | 58,195 | 193.4 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 14.32% | + 0.12% | 58,145 | 50.1 | < .001 |

*Note: N = 49,798. Dependent variable: `mca_any`. Goodness-of-fit: Hosmer-Lemeshow test χ² = 327.77 (p < 0.001).*

### Table 5.2.1 A : Final Model Parameters (Block 4) - Odds Ratios

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.000] | 0.189 |
| | Gender: Female (`gndr`) | 1.377 | [1.323, 1.433] | < .001 |
| | Education (`eisced`) | 1.016 | [1.012, 1.019] | < .001 |
| | Income (`hinctnta`) | 0.996 | [0.996, 0.997] | < .001 |
| | Living area / Rurality (`domicil`) | 0.972 | [0.957, 0.988] | < .001 |
| **Health Needs** | Subjective health (`health`) inv. | 0.929 | [0.905, 0.954] | < .001 |
| | Daily limitations (`hlthhmp`) inv. | 0.873 | [0.841, 0.906] | < .001 |
| | **Musculoskeletal problems (`score_musculo`)** | **1.739** | **[1.699, 1.779]** | **< .001** |
| | Digestive problems (`hltprsd`) | 1.314 | [1.241, 1.392] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.290 | [1.244, 1.337] | < .001 |
| | Severe headaches (`hltprsh`) | 1.096 | [1.031, 1.166] | 0.003 |
| | Cardiovascular problems (`score_cardio`) | 0.885 | [0.857, 0.913] | < .001 |
| **Push Factors** | **Access difficulties (`access_difficulties`)** | **1.287** | **[1.238, 1.338]** | **< .001** |
| **Pull Factors** | Openness (`ouverture`) inv. | 0.986 | [0.982, 0.990] | < .001 |
| | Tradition (`tradition`) inv. | 1.009 | [1.005, 1.013] | < .001 |

### Table 5.2.2 A : Final Model Parameters (Block 4) - Odds Ratios

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.000] | 0.119 |
| | Gender: Female (`gndr`) | 1.411 | [1.355, 1.469] | < .001 |
| | Education (`eisced`) | 1.016 | [1.013, 1.019] | < .001 |
| | Income (`hinctnta`) | 0.996 | [0.996, 0.997] | < .001 |
| | Living area / Rurality (`domicil`) | 0.966 | [0.950, 0.981] | < .001 |
| **Health Needs** | Subjective health (`health`) inv. | 0.980 | [0.953, 1.008] | 0.154 |
| | Daily limitations (`hlthhmp`) inv. | 0.843 | [0.811, 0.876] | < .001 |
| | **Musculoskeletal problems (`score_musculo`)** | **1.744** | **[1.704, 1.785]** | **< .001** |
| | Digestive problems (`hltprsd`) | 1.332 | [1.257, 1.411] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.293 | [1.247, 1.340] | < .001 |
| | Severe headaches (`hltprsh`) | 1.144 | [1.075, 1.217] | < .001 |
| | Cardiovascular problems (`score_cardio`) | 0.889 | [0.861, 0.918] | < .001 |
| | **Depression score (`cesd_score`)** | **0.964** | **[0.958, 0.969]** | **< .001** |
| **Push Factors** | **Access difficulties (`access_difficulties`)** | **1.320** | **[1.269, 1.373]** | **< .001** |
| **Pull Factors** | Openness (`ouverture`) inv. | 0.986 | [0.982, 0.990] | < .001 |
| | Tradition (`tradition`) inv. | 1.010 | [1.006, 1.014] | < .001 |


### Table 5.3 B : Hierarchical Negative Binomial Regression - Incremental Model Fit

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Likelihood-Ratio Stat (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 2.33% | - | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio, score_musculo...` | 11.43% | + 9.10% | 4,147.9 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 11.86% | + 0.43% | 207.8 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 12.02% | + 0.16% | 76.9 | < .001 |

*Note: N = 50,012 (104 observations deleted due to missingness). Dependent variable: `mca_count` (dispersion parameter: θ = 1.552).*



### Table 5.4 B : Final Model Parameters (Block 4) - Incidence Rate Ratios (IRR)

| Variable Category | Predictor | Incidence Rate Ratio (IRR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.000] | 0.379 |
| | Gender: Female (`gndr`) | 1.308 | [1.269, 1.348] | < .001 |
| | Education (`eisced`) | 1.013 | [1.010, 1.015] | < .001 |
| | Income (`hinctnta`) | 0.997 | [0.997, 0.998] | < .001 |
| | Living area / Rurality (`domicil`) | 0.972 | [0.961, 0.984] | < .001 |
| **Health Needs** | Subjective health (`health`) inv. | 0.944 | [0.925, 0.962] | < .001 |
| | Daily limitations (`hlthhmp`) inv. | 0.891 | [0.867, 0.915] | < .001 |
| | **Musculoskeletal problems (`score_musculo`)** | **1.471** | **[1.448, 1.495]** | **< .001** |
| | Digestive problems (`hltprsd`) | 1.220 | [1.174, 1.269] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.178 | [1.150, 1.206] | < .001 |
| | Severe headaches (`hltprsh`) | 1.143 | [1.096, 1.192] | < .001 |
| | **Cardiovascular problems (`score_cardio`)** | **0.914** | **[0.894, 0.935]** | **< .001** |
| **Push Factors** | **Access difficulties (`access_difficulties`)** | **1.206** | **[1.176, 1.236]** | **< .001** |
| **Pull Factors** | Openness (`ouverture`) inv. | 0.987 | [0.984, 0.990] | < .001 |
| | Tradition (`tradition`) inv. | 1.008 | [1.005, 1.011] | < .001 |

### Table 5.5 C : Hierarchical Logistic Regression - Incremental Model Fit (Homeopathy Use)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 2.37% | - | 13,277 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 4.21% | + 1.84% | 13,056 | 221.09 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 4.44% | + 0.23% | 13,028 | 27.28 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 4.58% | + 0.14% | 13,012 | 16.11 | 0.0003 |

*Note: N = 49,798. Dependent variable: trhltho (Homeopathy). Goodness-of-fit: Hosmer-Lemeshow test χ² = 16.67 (p = 0.033).*

### Table 5.6 C : Final Model Parameters (Block 4) - Odds Ratios (Homeopathy)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.001] | 0.271 |
| | **Gender: Female (`gndr`)** | **2.108** | **[1.879, 2.370]** | **< .001** |
| | Education (`eisced`) | 1.015 | [1.008, 1.021] | < .001 |
| | Income (`hinctnta`) | 0.996 | [0.994, 0.998] | 0.001 |
| | Living area / Rurality (`domicil`) | 0.934 | [0.896, 0.973] | 0.001 |
| **Health Needs** | Subjective health (`health`) | 0.926 | [0.861, 0.995] | 0.037 |
| | Daily limitations (`hlthhmp`) | 1.000 | [0.908, 1.099] | 0.999 |
| | Musculoskeletal problems (`score_musculo`) | 1.180 | [1.113, 1.250] | < .001 |
| | Digestive problems (`hltprsd`) | 1.233 | [1.073, 1.412] | 0.002 |
| | **Atopic & inflammatory problems (`score_atopi_inflam`)** | **1.347** | **[1.244, 1.455]** | **< .001** |
| | **Severe headaches (`hltprsh`)** | **1.464** | **[1.275, 1.678]** | **< .001** |
| | Cardiovascular problems (`score_cardio`) | 0.872 | [0.800, 0.949] | 0.001 |
| | Depression score (`cesd_score`) | 0.985 | [0.972, 0.999] | 0.040 |
| **Push Factors** | **Access difficulties (`access_difficulties`)** | **1.259** | **[1.156, 1.367]** | **< .001** |
| **Pull Factors** | Openness (`ouverture`) | 0.979 | [0.968, 0.990] | < .001 |
| | Tradition (`tradition`) | 1.019 | [1.009, 1.028] | < .001 | [1]

### Table 5.7 C : Hierarchical Logistic Regression - Incremental Model Fit (Herbal Treatment Use)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 2.52% | - | 22,470 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 4.97% | + 2.45% | 22,012 | 457.20 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 5.47% | + 0.50% | 21,919 | 93.18 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 5.49% | + 0.02% | 21,914 | 4.84 | 0.089 |

*Note: N = 49,798. Dependent variable: trhltht (Herbal treatment). Goodness-of-fit: Hosmer-Lemeshow test χ² = 16.65 (p = 0.033).*

### Table 5.8 C : Final Model Parameters (Block 4) - Odds Ratios (Herbal Treatment)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.001 | [1.000, 1.001] | 0.007 |
| | **Gender: Female (`gndr`)** | **1.856** | **[1.712, 2.013]** | **< .001** |
| | Education (`eisced`) | 1.012 | [1.007, 1.017] | < .001 |
| | Income (`hinctnta`) | 0.997 | [0.996, 0.999] | < .001 |
| | Living area / Rurality (`domicil`) | 0.899 | [0.873, 0.927] | < .001 |
| **Health Needs** | Subjective health (`health`) | 1.153 | [1.097, 1.212] | < .001 |
| | Daily limitations (`hlthhmp`) | 0.980 | [0.919, 1.045] | 0.545 |
| | **Cardiovascular problems (`score_cardio`)** | **1.133** | **[1.074, 1.193]** | **< .001** |
| | Musculoskeletal problems (`score_musculo`) | 1.107 | [1.062, 1.153] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.075 | [1.011, 1.142] | 0.019 |
| | **Digestive problems (`hltprsd`)** | **1.431** | **[1.300, 1.575]** | **< .001** |
| | Severe headaches (`hltprsh`) | 1.197 | [1.078, 1.327] | 0.001 |
| | Depression score (`cesd_score`) | 1.001 | [0.992, 1.011] | 0.778 |
| **Push Factors** | **Access difficulties (`access_difficulties`)** | **1.345** | **[1.269, 1.424]** | **< .001** |
| **Pull Factors** | Openness (`ouverture`) | 0.994 | [0.986, 1.001] | 0.102 |
| | Tradition (`tradition`) | 1.002 | [0.994, 1.009] | 0.665 | [2]

### Table 5.9 C : Hierarchical Logistic Regression - Incremental Model Fit (Spiritual Healing Use)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 1.90% | - | 9,303.0 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 4.81% | + 2.91% | 9,050.9 | 252.11 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 5.05% | + 0.24% | 9,030.3 | 20.67 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 5.07% | + 0.02% | 9,028.6 | 1.67 | 0.435 |

*Note: N = 49,798. Dependent variable: trhltsh (Spiritual healing). Goodness-of-fit: Hosmer-Lemeshow test χ² = 16.74 (p = 0.033).*

### Table 5.10 C : Final Model Parameters (Block 4) - Odds Ratios (Spiritual Healing)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [0.998, 1.000] | 0.375 |
| | **Gender: Female (`gndr`)** | **1.617** | **[1.407, 1.863]** | **< .001** |
| | Education (`eisced`) | 1.014 | [1.005, 1.022] | < .001 |
| | Income (`hinctnta`) | 0.995 | [0.992, 0.997] | < .001 |
| | Living area / Rurality (`domicil`) | 0.880 | [0.836, 0.927] | < .001 |
| **Health Needs** | Subjective health (`health`) | 0.867 | [0.790, 0.950] | 0.002 |
| | Daily limitations (`hlthhmp`) | 0.779 | [0.691, 0.879] | < .001 |
| | Cardiovascular problems (`score_cardio`) | 0.860 | [0.776, 0.951] | 0.004 |
| | Musculoskeletal problems (`score_musculo`) | 1.173 | [1.092, 1.259] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.245 | [1.129, 1.370] | < .001 |
| | Digestive problems (`hltprsd`) | 1.362 | [1.155, 1.601] | < .001 |
| | **Severe headaches (`hltprsh`)** | **1.638** | **[1.389, 1.925]** | **< .001** |
| | **Depression score (`cesd_score`)** | **1.030** | **[1.013, 1.047]** | **< .001** |
| **Push Factors** | **Access difficulties (`access_difficulties`)** | **1.264** | **[1.145, 1.390]** | **< .001** |
| **Pull Factors** | Openness (`ouverture`) | 0.994 | [0.981, 1.006] | 0.341 |
| | Tradition (`tradition`) | 1.008 | [0.996, 1.020] | 0.192 | [3]


### Table 5.11 D : Hierarchical Logistic Regression - Incremental Model Fit (Paraconventional Therapies)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 1.26% | - | 47,552 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 14.24% | + 12.98% | 43,353 | 4,199.80 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 14.63% | + 0.39% | 43,221 | 131.40 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 14.71% | + 0.08% | 43,194 | 26.80 | < .001 |

*Note: N = 49,798. Dependent variable: grp1_paraconv. Goodness-of-fit: Hosmer-Lemeshow test χ² = 510.33 (p < .001).*

### Table 5.12 D : Final Model Parameters (Block 4) - Odds Ratios (Paraconventional Therapies)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.000] | 0.550 |
| | Gender: Female (`gndr`) | 1.193 | [1.136, 1.253] | < .001 |
| | Education (`eisced`) | 1.012 | [1.008, 1.015] | < .001 |
| | Income (`hinctnta`) | 0.998 | [0.997, 0.999] | < .001 |
| | Living area / Rurality (`domicil`) | 1.006 | [0.986, 1.025] | 0.582 |
| **Health Needs** | Subjective health (`health`) | 1.000 | [0.966, 1.034] | 0.978 |
| | Daily limitations (`hlthhmp`) | 0.727 | [0.695, 0.761] | < .001 |
| | Cardiovascular problems (`score_cardio`) | 0.861 | [0.830, 0.894] | < .001 |
| | Musculoskeletal problems (`score_musculo`) | 1.919 | [1.870, 1.970] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.203 | [1.156, 1.252] | < .001 |
| | Digestive problems (`hltprsd`) | 1.191 | [1.116, 1.272] | < .001 |
| | Severe headaches (`hltprsh`) | 1.043 | [0.971, 1.120] | 0.248 |
| | Depression score (`cesd_score`) | 0.950 | [0.944, 0.956] | < .001 |
| **Push Factors** | Access difficulties (`access_difficulties`) | 1.289 | [1.234, 1.345] | < .001 |
| **Pull Factors** | Openness (`ouverture`) | 0.988 | [0.983, 0.993] | < .001 |
| | Tradition (`tradition`) | 1.007 | [1.002, 1.012] | 0.008 | [7]

### Table 5.13 D : Hierarchical Logistic Regression - Incremental Model Fit (Tolerated Therapies)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 2.66% | - | 27,475 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 4.89% | + 2.23% | 26,988 | 486.62 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 5.33% | + 0.44% | 26,891 | 97.09 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 5.37% | + 0.04% | 26,883 | 7.66 | 0.022 |

*Note: N = 49,798. Dependent variable: grp2_tolerated. Goodness-of-fit: Hosmer-Lemeshow test χ² = 22.23 (p = 0.005).*

### Table 5.14 D : Final Model Parameters (Block 4) - Odds Ratios (Tolerated Therapies)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.001] | 0.053 |
| | Gender: Female (`gndr`) | 1.879 | [1.751, 2.018] | < .001 |
| | Education (`eisced`) | 1.013 | [1.008, 1.017] | < .001 |
| | Income (`hinctnta`) | 0.997 | [0.996, 0.998] | < .001 |
| | Living area / Rurality (`domicil`) | 0.928 | [0.903, 0.952] | < .001 |
| **Health Needs** | Subjective health (`health`) | 1.100 | [1.052, 1.149] | < .001 |
| | Daily limitations (`hlthhmp`) | 0.989 | [0.933, 1.047] | 0.702 |
| | Cardiovascular problems (`score_cardio`) | 1.059 | [1.009, 1.111] | 0.019 |
| | Musculoskeletal problems (`score_musculo`) | 1.128 | [1.088, 1.170] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.172 | [1.111, 1.235] | < .001 |
| | Digestive problems (`hltprsd`) | 1.347 | [1.235, 1.467] | < .001 |
| | Severe headaches (`hltprsh`) | 1.266 | [1.155, 1.386] | < .001 |
| | Depression score (`cesd_score`) | 0.999 | [0.990, 1.007] | 0.785 |
| **Push Factors** | Access difficulties (`access_difficulties`) | 1.316 | [1.248, 1.387] | < .001 |
| **Pull Factors** | Openness (`ouverture`) | 0.991 | [0.984, 0.998] | 0.008 |
| | Tradition (`tradition`) | 1.006 | [0.999, 1.012] | 0.072 | [8]

### Table 5.15 D : Hierarchical Logistic Regression - Incremental Model Fit (Heterodox Therapies)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 0.48% | - | 15,930 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 5.24% | + 4.76% | 15,273 | 657.50 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 5.47% | + 0.23% | 15,241 | 31.76 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 5.65% | + 0.18% | 15,216 | 24.60 | < .001 |

*Note: N = 49,798. Dependent variable: grp3_heterodox. Goodness-of-fit: Hosmer-Lemeshow test χ² = 69.57 (p < .001).*

### Table 5.16 D : Final Model Parameters (Block 4) - Odds Ratios (Heterodox Therapies)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [1.000, 1.001] | 0.075 |
| | Gender: Female (`gndr`) | 1.041 | [0.946, 1.146] | 0.408 |
| | Education (`eisced`) | 1.013 | [1.007, 1.019] | < .001 |
| | Income (`hinctnta`) | 0.998 | [0.996, 0.999] | 0.006 |
| | Living area / Rurality (`domicil`) | 1.031 | [0.992, 1.072] | 0.118 |
| **Health Needs** | Subjective health (`health`) | 0.888 | [0.831, 0.949] | < .001 |
| | Daily limitations (`hlthhmp`) | 0.840 | [0.769, 0.918] | < .001 |
| | Cardiovascular problems (`score_cardio`) | 0.723 | [0.667, 0.782] | < .001 |
| | Musculoskeletal problems (`score_musculo`) | 1.574 | [1.498, 1.654] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.222 | [1.137, 1.313] | < .001 |
| | Digestive problems (`hltprsd`) | 1.348 | [1.195, 1.518] | < .001 |
| | Severe headaches (`hltprsh`) | 1.234 | [1.084, 1.402] | 0.001 |
| | Depression score (`cesd_score`) | 0.985 | [0.972, 0.998] | 0.020 |
| **Push Factors** | Access difficulties (`access_difficulties`) | 1.250 | [1.158, 1.346] | < .001 |
| **Pull Factors** | Openness (`ouverture`) | 0.974 | [0.963, 0.984] | < .001 |
| | Tradition (`tradition`) | 1.017 | [1.008, 1.026] | < .001 | [5]

### Table 5.17 D : Hierarchical Logistic Regression - Incremental Model Fit (Marginal Therapies)

| Model Block | Added Variables | Pseudo-R² (Nagelkerke) | Δ R² | Model Deviance | Δ Deviance (χ²) | p-value |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Block 1: Socio-demographics** | `agea, gndr, eisced, hinctnta, domicil` | 1.90% | - | 9,303.0 | - | - |
| **Block 2: Health Needs** | `health, hlthhmp, score_cardio... + cesd_score` | 4.81% | + 2.91% | 9,050.9 | 252.11 | < .001 |
| **Block 3: Push (Access)** | `access_difficulties` | 5.05% | + 0.24% | 9,030.3 | 20.67 | < .001 |
| **Block 4: Pull (Values)** | `ouverture, tradition` | 5.07% | + 0.02% | 9,028.6 | 1.67 | 0.435 |

*Note: N = 49,798. Dependent variable: grp4_marginal. Goodness-of-fit: Hosmer-Lemeshow test χ² = 16.74 (p = 0.033).*

### Table 5.18 D : Final Model Parameters (Block 4) - Odds Ratios (Marginal Therapies)

| Variable Category | Predictor | Odds Ratio (OR) | 95% CI | p-value |
| :--- | :--- | :--- | :--- | :--- |
| **Socio-demographics** | Age (`agea`) | 1.000 | [0.998, 1.000] | 0.375 |
| | Gender: Female (`gndr`) | 1.617 | [1.407, 1.863] | < .001 |
| | Education (`eisced`) | 1.014 | [1.005, 1.022] | < .001 |
| | Income (`hinctnta`) | 0.995 | [0.992, 0.997] | < .001 |
| | Living area / Rurality (`domicil`) | 0.880 | [0.836, 0.927] | < .001 |
| **Health Needs** | Subjective health (`health`) | 0.867 | [0.790, 0.950] | 0.002 |
| | Daily limitations (`hlthhmp`) | 0.779 | [0.691, 0.879] | < .001 |
| | Cardiovascular problems (`score_cardio`) | 0.860 | [0.776, 0.951] | 0.004 |
| | Musculoskeletal problems (`score_musculo`) | 1.173 | [1.092, 1.259] | < .001 |
| | Atopic & inflammatory problems (`score_atopi_inflam`) | 1.245 | [1.129, 1.370] | < .001 |
| | Digestive problems (`hltprsd`) | 1.362 | [1.155, 1.601] | < .001 |
| | Severe headaches (`hltprsh`) | 1.638 | [1.389, 1.925] | < .001 |
| | Depression score (`cesd_score`) | 1.030 | [1.013, 1.047] | < .001 |
| **Push Factors** | Access difficulties (`access_difficulties`) | 1.264 | [1.145, 1.390] | < .001 |
| **Pull Factors** | Openness (`ouverture`) | 0.994 | [0.981, 1.006] | 0.341 |
| | Tradition (`tradition`) | 1.008 | [0.996, 1.020] | 0.192 | [6]

