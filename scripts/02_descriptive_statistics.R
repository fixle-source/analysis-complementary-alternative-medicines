library(tidyverse)
library(survey)
library(scales)
library(knitr)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(scales)


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

svy         <- svydesign(ids = ~1, weights = ~anweight,              data = df)
svy_country <- svydesign(ids = ~1, weights = ~cross_country_weight,  data = df)


# TABLE 1 — Weighted prevalence of each CAM


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
  kable(caption = "Table 2.1 : Weighted prevalence of CAM types")


# TABLE 2 — mca_any prevalence by country


cam_by_country <- svyby(~mca_any, ~cntry, svy_country, svymean, na.rm = TRUE) %>%
  as_tibble() %>%
  rename(prevalence = mca_any, SE = se) %>%
  arrange(desc(prevalence))

cam_by_country %>%
  mutate(`Prevalence (%)` = percent(prevalence, accuracy = 0.1)) %>%
  select(Country = cntry, `Prevalence (%)`) %>%
  kable(caption = "Table 2.2 : CAM prevalence by country (weighted)")

# TABLE 3 — Overlap Conventional / CAM

svytable(~care_type, svy) %>%
  prop.table() %>%
  as_tibble() %>%
  mutate(`%` = percent(n, accuracy = 0.1)) %>%
  kable(caption = "Table 2.3 : Conventional medicine × CAM overlap")

# Kruskal-Wallis : care_type vs health outcomes
map_dfr(c("health", "cesd_score", "hlthhmp"), function(outcome) {
  test <- kruskal.test(as.formula(paste(outcome, "~ care_type")), data = df)
  tibble(Outcome = outcome, H = round(test$statistic, 2),
         df = test$parameter, p = round(test$p.value, 4))
}) %>%
  kable(caption = "Table 2.4 : Kruskal-Wallis: health outcomes by care type")


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
  labs(title = "Figure 2.1 : Weighted prevalence of CAM types",
       x = NULL, y = "Prevalence (%)",
       caption = "Error bars = 95% Confidence Interval     Area: Europe     Source: ESS11 Health Module.") +
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
    position = position_stack(vjust = 0.5),  
    size = 4,
    colour = "black",
    fontface = "bold"
  ) +
  scale_fill_brewer(palette = "RdYlGn", direction = -1) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title   = "Figure 2.2 : Subjective health by CAM intensity",
    x       = "Number of CAM types used",
    y       = "Proportion (%)",
    fill    = "Subjective health",
    caption = "Area: Europe     Source: ESS11 Health Module."
  ) +
  theme_minimal(base_size = 12)

# Figure 3 — country prevalence (avec noms de pays complets)
cam_by_country %>%
  mutate(
    cntry_name = case_when(
      cntry == "IS" ~ "Iceland",
      cntry == "CH" ~ "Switzerland",
      cntry == "FR" ~ "France",
      cntry == "EE" ~ "Estonia",
      cntry == "DE" ~ "Germany",
      cntry == "LT" ~ "Lithuania",
      cntry == "NL" ~ "Netherlands",
      cntry == "FI" ~ "Finland",
      cntry == "SE" ~ "Sweden",
      cntry == "BE" ~ "Belgium",
      cntry == "AT" ~ "Austria",
      cntry == "SI" ~ "Slovenia",
      cntry == "SK" ~ "Slovakia",
      cntry == "NO" ~ "Norway",
      cntry == "ES" ~ "Spain",
      cntry == "LV" ~ "Latvia",
      cntry == "CY" ~ "Cyprus",
      cntry == "RS" ~ "Serbia",
      cntry == "GB" ~ "United Kingdom",
      cntry == "IL" ~ "Israel",
      cntry == "HR" ~ "Croatia",
      cntry == "IE" ~ "Ireland",
      cntry == "PL" ~ "Poland",
      cntry == "PT" ~ "Portugal",
      cntry == "ME" ~ "Montenegro",
      cntry == "BG" ~ "Bulgaria",
      cntry == "UA" ~ "Ukraine",
      cntry == "IT" ~ "Italy",
      cntry == "HU" ~ "Hungary",
      cntry == "GR" ~ "Greece",
      TRUE ~ cntry 
    ),
    cntry_name = fct_reorder(cntry_name, prevalence)
  ) %>%
  ggplot(aes(x = cntry_name, y = prevalence)) +
  geom_col(fill = "#4C72B0", width = 0.7) +
  geom_errorbar(aes(ymin = pmax(prevalence - 1.96*SE, 0),
                    ymax = prevalence + 1.96*SE),
                width = 0.3, colour = "grey40") +
  scale_y_continuous(labels = percent_format()) +
  coord_flip() +
  labs(title = "CAM prevalence by country",
       x = NULL, y = "Prevalence (%)",
       caption = "Weights: pspwght × pweight. Source: ESS11 Health Module.") +
  theme_minimal(base_size = 12)

# Figure 4 — map country prevalence

europe_map <- ne_countries(scale = "medium", continent = "Europe", returnclass = "sf")

europe_map <- europe_map %>%
  mutate(
    iso_a2 = case_when(
      admin == "France"         ~ "FR",
      admin == "United Kingdom" ~ "GB",
      admin == "Greece"         ~ "GR",
      admin == "Norway"         ~ "NO",
      TRUE ~ iso_a2
    )
  )

map_data <- europe_map %>%
  left_join(cam_by_country, by = c("iso_a2" = "cntry"))

p_map <- ggplot(data = map_data) +
  geom_sf(aes(fill = prevalence), color = "white", linewidth = 0.3) +
  coord_sf(xlim = c(-25, 45), ylim = c(34, 71), expand = FALSE) +
  scale_fill_viridis_c(
    option = "mako",       
    direction = -1,        
    labels = percent_format(accuracy = 1),
    na.value = "grey85",   
    name = "Prevalence"
  ) +
  theme_void(base_size = 12) +
  labs(
    title = "Figure 2.5 : CAM Prevalence across Europe",
    subtitle = "Percentage of adults using at least one Alternative Medicine in the past 12 months",
    caption = "Grey areas: Not in ESS11 dataset.\nWeights: pspwght × pweight. Source: ESS11 Health Module."
  ) +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold", hjust = 0.5, margin = margin(b = 5)),
    plot.subtitle = element_text(hjust = 0.5, margin = margin(b = 15), color = "grey30"),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  )

print(p_map)