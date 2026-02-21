# Summary of the results

### Part 1: Descriptive Statistics

**1.1. Overall Prevalence of Specific CAM Types**

![](/outputs/figure/2_1_wheighted_CAM_prevalence.png)

Analysis of the European Social Survey (ESS Round 11) reveals a broad spectrum of utilization across different Complementary and Alternative Medicine (CAM) modalities. Physiotherapy is the most widely used practice, reported by 18.1% of the adult population in the past 12 months . This is followed by therapeutic massage (10.5%) and osteopathy (6.9%) onversely, practices such as acupressure and hypnotherapy show the lowest penetration rates, each utilized by only 0.6% of the population

**1.2. Cross-Country Variations in Europe**

![](/outputs/figure/2_3_country_prevalence_map.png)
![](/outputs/figure/2_2_country_prevalence.png)

CAM usage is highly heterogeneous across European countries . The highest prevalences are concentrated in Western and Northern Europe, led by Iceland (54.5%), Switzerland (54.4%), and France (50.6%) n stark contrast, Southern and Eastern European countries report significantly lower utilization rates, particularly in Greece (12.7%), Hungary (12.9%), and Italy (18.2%)

**1.3. Overlap Between Conventional and Alternative Care**
To better understand healthcare navigation, the sample was divided into [four mutually exclusive groups](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-23--conventional-medicine--cam-overlap) depending on their combined use of conventional medical visits (General Practitioner or Specialist) and CAM over the past 12 months.

- Almost half of the respondents (49.0%) rely exclusively on **conventional medicine** .
- Nearly a third (31.6%) use **both conventional and alternative therapies**, representing the vast majority of CAM users .
- Exclusive use of **CAM only** is marginal, concerning just 3.0% of the population .
- Finally, 16.4% reported using **neither** conventional nor alternative care .

**1.4. Health Outcomes by Typology of Care**
Following the descriptive distribution, nonparametric [Kruskal-Wallis rank sum tests](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-24--kruskal-wallis-health-outcomes-by-care-type) were conducted to investigate the association between the four-level care typology (Neither, Conventional only, CAM only, Both) and essential health indicators. The test results indicate highly significant global differences (p < 0.001) across the groups regarding subjective general health, physical limitations (hampered in daily activities), and levels of depressive symptoms (based on the prorated CES-D score).

![](/outputs/figure/2_4_subjective_health.png)

---
---

### Part 2: Latent Class Analysis (LCA)

**2.1. Objective and Hypothesis Testing**
To investigate the potential existence of specific "subcultures" or profiles of healthcare practices among the European population, a Latent Class Analysis (LCA) was conducted. The primary objective was to test [Hypothesis 1 (H1)](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/docs/methodology.md#hypotheses), which posited that discernible latent profiles of overlapping CAM usage could be identified. 

**2.2. Initial LCA Models (14 Indicators)**
The [initial LCA](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-31--lca-with-14-variables-fit-indices-1-to-7-classes) evaluated models ranging from 1 to 7 classes based on 14 binary variables: the 12 specific CAM modalities and 2 conventional medicine touchpoints (GP and specialist visits). However, the statistical fit indices did not reveal a viable classification. Notably the entropy values remained consistently poor, peaking at only 0.625 for the 7-class model.

**2.3. Refined LCA Models (12 CAM Indicators)**
Under the assumption that latent classes might strictly reflect bundles of alternative practices (e.g., physical therapies vs. spiritual healing), a [second set of LCAs](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-32--lca-with-12-variables-fit-indices-1-to-7-classes) was computed excluding the conventional medicine variables. While this pure CAM model demonstrated a slight improvement in fit indices, entropy still failed to reach the satisfactory threshold (peaking at 0.724 for the 3-class model). Furthermore, the model evolution revealed no conceptually meaningful groupings; rather than clumping complementary practices together, adding new classes simply isolated individual CAM modalities in descending order of their global prevalence. Successive attempts with altered configurations (e.g., excluding non-users or conventional-only users) proved equally inconclusive.

**2.4. Underlying Structure and Conclusion**
To diagnostically validate the failure of the LCA models to form clusters, a tetrachoric correlation matrix was generated to assess the unobserved continuous structure between the binary CAM variables. The resulting matrix confirmed a notably weak average correlation across practices (r = 0.278). This demonstrates a poor underlying structure in the dataset, indicating that the use of one alternative medicine is only marginally predictive of using another. Consequently, [Hypothesis 1](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/docs/methodology.md#hypotheses) is rejected: the data does not support the existence of distinct, cohesive subcultures of CAM practices in Europe.

![](/outputs/figure/3_1_tetrachoric.png)

---
---

### Part 3: MANCOVA Analysis

**3.1. Objective and Hypothesis Testing**
To address [Hypothesis 2 (H2)](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/docs/methodology.md#hypotheses), a Multivariate Analysis of Covariance (MANCOVA) was employed to evaluate whether the intensity of CAM utilization (categorized into 0, 1, 2-3, or 4+ practices with variable `mca_category`) is associated with a comprehensive multivariate health vector encompassing 8 distinct clinical outcomes. Due to the large sample size (N+49000) leading to significant Box's M and Shapiro-Wilk tests, Pillai's trace was utilized as a robust test statistic. The model also systematically controlled for demographic (age) and structural (access difficulties) covariates.

**3.2. Global Multivariate Results**
[The MANCOVA results](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-41--multivariate-tests-for-cam-intensity-mancova) reveal a highly significant multivariate effect of CAM intensity on the combined health vector (Pillai’s trace = 0.102, F = 219.18, p < 0.001), indicating that health profiles differ substantially depending on the sheer number of alternative therapies an individual uses. The covariates (age and access difficulties) were also highly significant independent predictors of the multivariate outcome. Consequently, [Hypothesis 2](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/docs/methodology.md#hypotheses) is fully supported by the data.

**3.3. Specific Item Associations (Univariate Step-Down)**
To decompose the global effect, [univariate step-down ANCOVAs](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-42--univariate-ancova-results-for-cam-intensity-mca_category) were conducted for each of the 8 clinical outcomes. The results highlighted a distinct contrast between physical symptoms and psychological well-being. Highly significant associations (p < 0.001) were observed for all physical variables, led by musculoskeletal problems (F = 1490.14), atopic and inflammatory conditions (F = 341.86), digestive problems (F = 313.36), and daily functional limitations (F = 222.08). Conversely, the prorated CES-D depression score emerged as the only variable not significantly associated with CAM intensity (F = 2.18, p = 0.088).

**3.4. Dose-Response Profiles (Post-Hoc Comparisons)**
[Estimated Marginal Means (EMMs) with Bonferroni correction](https://github.com/fixle-source/analysis-complementary-alternative-medicines/blob/main/outputs/tables/tables.md#table-43--pairwise-comparisons-post-hoc-for-key-health-outcomes) were calculated to investigate the exact pairwise contrasts across the CAM intensity groups. The post-hoc estimations delineated a clear "dose-response" profile for somatic complaints : as the number of utilized CAM types increases incrementally, there is a corresponding, significant exacerbation in musculoskeletal pain, severe headaches, and globally poor subjective health. In stark contrast, confirming the univariate findings, psychological distress remains disconnected from CAM intensity, with all pairwise comparisons for the depression score yielding non-significant differences (p > 0.10 or p = 1.000). 

![](/outputs/figure/4_1_dose_response_profiles_intensity.png)

---
---

