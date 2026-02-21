library(tidyverse)
library(car)        
library(heplots)    
library(emmeans)    

df_mancova <- df %>%
  mutate(
    mca_category = case_when(
      mca_count == 0 ~ "0",
      mca_count == 1 ~ "1",
      mca_count %in% c(2, 3) ~ "2-3",
      mca_count >= 4 ~ "4+"
    ),
    mca_category = factor(mca_category, levels = c("0", "1", "2-3", "4+"))
  ) %>%
  drop_na(mca_category, agea, access_difficulties, 
          health, hlthhmp, score_cardio, score_musculo, 
          score_atopi_inflam, hltprsd, hltprsh, cesd_score)

Y_matrix <- with(df_mancova, cbind(health, hlthhmp, score_cardio, score_musculo, 
                                   score_atopi_inflam, hltprsd, hltprsh, cesd_score))

box_m_test <- boxM(Y_matrix, df_mancova$mca_category)
print(box_m_test)
mod_lm_residus <- lm(Y_matrix ~ agea + access_difficulties + mca_category, data = df_mancova)
set.seed(42)  
print(shapiro.test(sample(residuals(mod_lm_residus)[,1], 5000)))

mancova_model <- lm(Y_matrix ~ agea + access_difficulties + mca_category, data = df_mancova)

mancova_res <- Manova(mancova_model, test.statistic = "Pillai")

print(summary(mancova_res))

univariate_res <- summary.aov(mancova_model)
print(univariate_res)

lm_musculo <- lm(score_musculo ~ agea + access_difficulties + mca_category, data = df_mancova)
posthoc_musculo <- emmeans(lm_musculo, ~ mca_category)
print(pairs(posthoc_musculo, adjust = "bonferroni"))

lm_cesd <- lm(cesd_score ~ agea + access_difficulties + mca_category, data = df_mancova)
posthoc_cesd <- emmeans(lm_cesd, ~ mca_category)
print(pairs(posthoc_cesd, adjust = "bonferroni"))

lm_health <- lm(health ~ agea + access_difficulties + mca_category, data = df_mancova)
posthoc_health <- emmeans(lm_health, ~ mca_category)
print(pairs(posthoc_health, adjust = "bonferroni"))

lm_headache <- lm(hltprsh ~ agea + access_difficulties + mca_category, data = df_mancova)
posthoc_headache <- emmeans(lm_headache, ~ mca_category)
print(pairs(posthoc_headache, adjust = "bonferroni"))


# ==============================================================================
# plot
# ==============================================================================

df_emm_musculo <- as.data.frame(emmeans(lm_musculo, ~ mca_category)) %>%
  mutate(Outcome = "Musculoskeletal Pain")

df_emm_cesd <- as.data.frame(emmeans(lm_cesd, ~ mca_category)) %>%
  mutate(Outcome = "Depression (CES-D)")

df_emm_health <- as.data.frame(emmeans(lm_health, ~ mca_category)) %>%
  mutate(Outcome = "Poor Subjective Health")

df_emm_headache <- as.data.frame(emmeans(lm_headache, ~ mca_category)) %>%
  mutate(Outcome = "Severe Headaches")

df_emm_combined <- bind_rows(df_emm_musculo, df_emm_cesd, df_emm_health, df_emm_headache)

df_emm_combined$Outcome <- factor(df_emm_combined$Outcome, 
                                  levels = c("Musculoskeletal Pain", "Severe Headaches", 
                                             "Poor Subjective Health", "Depression (CES-D)"))

p_dose_response <- ggplot(df_emm_combined, aes(x = mca_category, y = emmean, group = 1)) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_point(color = "darkblue", size = 3) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), width = 0.2, color = "darkblue", linewidth = 0.8) +
  facet_wrap(~ Outcome, scales = "free_y") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Dose-Response Profiles of CAM Intensity",
    subtitle = "Estimated Marginal Means (controlling for age and access difficulties)",
    x = "Number of CAM therapies used (Intensity)",
    y = "Adjusted Mean Score",
    caption = "Data: ESS11 Health Module"
  ) +
  theme(
    strip.text = element_text(face = "bold", size = 11),
    panel.grid.minor = element_blank()
  )

print(p_dose_response)