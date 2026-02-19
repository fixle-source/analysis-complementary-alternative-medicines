# ============================================================
# 02_descriptive_statistics.R
# Purpose : First glimps at the data
# ============================================================

library(tidyverse)
library(survey)
library(scales)
library(knitr)

df <- readRDS("data/processed/ess_processed.rds")

df <- df %>%
  mutate(
    # Typology: overlap conventional / CAM
    care_type  = case_when(
      mca_any == 0 & dshltgp == 0 & dshltms == 0 ~ "Neither",
      mca_any == 0 & (dshltgp == 1 | dshltms == 1) ~ "Conventional only",
      mca_any == 1 & dshltgp == 0 & dshltms == 0  ~ "CAM only",
      mca_any == 1 & (dshltgp == 1 | dshltms == 1) ~ "Both"
    ) %>% factor(levels = c("Neither", "Conventional only", "CAM only", "Both"))
  )

# ============================================================
# SURVEY DESIGN
# ============================================================

svy         <- svydesign(ids = ~1, weights = ~anweight,              data = df)
svy_country <- svydesign(ids = ~1, weights = ~cross_country_weight,  data = df)

# ============================================================
# TABLE 1 — Weighted prevalence of each CAM
# ============================================================

cam_labels <- c(
  trhltacu = "Acupuncture",      trhltho  = "Homeopathy",
  trhltht  = "Herbal treatment", trhltch  = "Chiropractic",
  trhltos  = "Osteopathy",       trhltpt  = "Physiotherapy",
  trhltre  = "Reflexology",      trhltsh  = "Spiritual healing",
  trhltacp = "Acupressure",      trhltcm  = "Chinese medicine",
  trhlthy  = "Hypnotherapy",     trhltmt  = "Therapeutic massage"
)

cam_prevalence <- map_dfr(names(cam_labels), function(var) {
  m <- svymean(as.formula(paste0("~I(", var, "==1)")), svy, na.rm = TRUE)
  tibble(
    Practice   = cam_labels[[var]],
    Prevalence = as.numeric(m)[2],
    SE         = as.numeric(SE(m))[2]
  )
}) %>% arrange(desc(Prevalence))

cam_prevalence %>%
  mutate(
    `Prevalence (%)` = percent(Prevalence, accuracy = 0.1),
    `95% Confidence Interval`         = paste0("[",
                              percent(pmax(Prevalence - 1.96*SE, 0), accuracy = 0.1),
                              " – ",
                              percent(Prevalence + 1.96*SE, accuracy = 0.1), "]")
  ) %>%
  select(Practice, `Prevalence (%)`, `95% Confidence Interval`) %>%
  kable(caption = "Table 1 – Weighted prevalence of CAM types")

# ============================================================
# TABLE 2 — mca_any prevalence by country
# ============================================================

cam_by_country <- svyby(~mca_any, ~cntry, svy_country, svymean, na.rm = TRUE) %>%
  as_tibble() %>%
  rename(prevalence = mca_any, SE = se) %>%
  arrange(desc(prevalence))

cam_by_country %>%
  mutate(`Prevalence (%)` = percent(prevalence, accuracy = 0.1)) %>%
  select(Country = cntry, `Prevalence (%)`) %>%
  kable(caption = "Table 2 – CAM prevalence by country (weighted)")

# ============================================================
# TABLE 3 — Overlap Conventional / MCA
# ============================================================

svytable(~care_type, svy) %>%
  prop.table() %>%
  as_tibble() %>%
  mutate(`%` = percent(n, accuracy = 0.1)) %>%
  kable(caption = "Table 3 – Conventional medicine × CAM overlap")

# Kruskal-Wallis : care_type vs health outcomes
map_dfr(c("health", "cesd_score", "hlthhmp"), function(outcome) {
  test <- kruskal.test(as.formula(paste(outcome, "~ care_type")), data = df)
  tibble(Outcome = outcome, H = round(test$statistic, 2),
         df = test$parameter, p = round(test$p.value, 4))
}) %>%
  kable(caption = "Table 4 – Kruskal-Wallis: health outcomes by care type")

# ============================================================
# FIGURES
# ============================================================

# Figure 1 — CAM prevalence
cam_prevalence %>%
  mutate(Practice = fct_reorder(Practice, Prevalence)) %>%
  ggplot(aes(x = Practice, y = Prevalence)) +
  geom_col(fill = "#4C72B0", width = 0.7) +
  geom_errorbar(aes(ymin = pmax(Prevalence - 1.96*SE, 0),
                    ymax = Prevalence + 1.96*SE),
                width = 0.25, colour = "grey40") +
  scale_y_continuous(labels = percent_format()) +
  coord_flip() +
  labs(title = "Figure 1 – Weighted prevalence of CAM types",
       x = NULL, y = "Prevalence (%)",
       caption = "Error bars = 95% CI. Source: ESS Health Module.") +
  theme_minimal(base_size = 12)

# Figure 2 — subjective health by CAM intensity
df %>%
  filter(!is.na(mca_category), health %in% 1:5) %>%
  mutate(health = factor(health,
                         levels = 1:5,
                         labels = c("Very good", "Good", "Fair", "Bad", "Very bad"))) %>%
  group_by(mca_category, health) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(mca_category) %>%
  mutate(pct = n / sum(n)) %>%
  ggplot(aes(x = mca_category, y = pct, fill = health)) +
  geom_col(position = "stack", width = 0.7) +
  geom_text(
    aes(label = n),
    position = position_stack(vjust = 0.5),  # centre vertical de chaque rectangle
    size = 3,
    colour = "black",
    fontface = "bold"
  ) +
  scale_fill_brewer(palette = "RdYlGn", direction = -1) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title   = "Figure 2 – Subjective health by CAM intensity",
    x       = "Number of CAM types used",
    y       = "Proportion (%)",
    fill    = "Subjective health",
    caption = "Source: ESS Health Module."
  ) +
  theme_minimal(base_size = 12)

# Figure 3 — country prevalence
cam_by_country %>%
  mutate(cntry = fct_reorder(cntry, prevalence)) %>%
  ggplot(aes(x = cntry, y = prevalence)) +
  geom_col(fill = "#55A868", width = 0.7) +
  geom_errorbar(aes(ymin = pmax(prevalence - 1.96*SE, 0),
                    ymax = prevalence + 1.96*SE),
                width = 0.3, colour = "grey40") +
  scale_y_continuous(labels = percent_format()) +
  coord_flip() +
  labs(title = "Figure 3 – CAM prevalence by country",
       x = NULL, y = "Prevalence (%)",
       caption = "Weights: pspwght × pweight. Source: ESS Health Module.") +
  theme_minimal(base_size = 12)