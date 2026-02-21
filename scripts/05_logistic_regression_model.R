library(tidyverse)
library(DescTools)         #Pseudo-R2 Nagelkerke
library(ResourceSelection) #test Hosmer-Lemeshow
library(MASS)      # negative binomial

df <- readRDS("data/processed/ess_processed.rds")

### Model A: Binary logistic regression ========================================
df_model_A <- df %>%
  drop_na(mca_any, agea, gndr, eisced, hinctnta, domicil, 
          health, hlthhmp, score_cardio, score_musculo, score_atopi_inflam, 
          hltprsd, hltprsh, cesd_score,
          access_difficulties, ouverture, tradition)

# Hierarchical entry)

mod_block1 <- glm(mca_any ~ agea + gndr + eisced + hinctnta + domicil, 
                  data = df_model_A, family = binomial)

mod_block2 <- update(mod_block1, . ~ . + health + hlthhmp + score_cardio + score_musculo + score_atopi_inflam + hltprsd + hltprsh + cesd_score)

mod_block3 <- update(mod_block2, . ~ . + access_difficulties)

mod_block4 <- update(mod_block3, . ~ . + ouverture + tradition)

# evaluation

# p-value of -2LL
cat("\n=== Blocks comparison (-2LL change) ===\n")
anova_results_a <- anova(mod_block1, mod_block2, mod_block3, mod_block4, test = "Chisq")
print(anova_results_a)

# Pseudo-R² Nagelkerke
cat("\n=== Pseudo-R2 Nagelkerke by blocks ===\n")
c(
  Bloc1_Socio    = PseudoR2(mod_block1, which = "Nagelkerke"),
  Bloc2_Sante     = PseudoR2(mod_block2, which = "Nagelkerke"),
  Bloc3_Push   = PseudoR2(mod_block3, which = "Nagelkerke"),
  Bloc4_Pull     = PseudoR2(mod_block4, which = "Nagelkerke")
)

# Goodness-of-fit
cat("\n=== Hosmer-Lemeshow Goodness-of-Fit (Modèle Final) ===\n")
hoslem.test(mod_block4$y, fitted(mod_block4), g = 10)

# Odds Ratios

cat("\n=== Résumé des coefficients (Log-Odds et p-values) ===\n")
summary(mod_block4)

cat("\n=== Odds Ratios (OR) et Intervalles de Confiance (95%) ===\n")
or_table <- exp(cbind(OR = coef(mod_block4), confint(mod_block4)))
print(round(or_table, 3))


### Model B: Negative binomial regression ======================================

# overdispersion test

mean_count <- mean(df$mca_count, na.rm = TRUE)
var_count  <- var(df$mca_count, na.rm = TRUE)

cat("\n=== overdispersion test (Mean vs Variance) ===\n")
cat("mean mca_count :", round(mean_count, 3), "\n")
cat("Variance mca_count :", round(var_count, 3), "\n")

if (var_count > mean_count * 1.5) {
  cat("\n negative binomial mandatory\n")
} else {
  cat("\npoisson could be enough\n")
}

# blocks :

mod_count_blk1 <- glm.nb(mca_count ~ agea + gndr + eisced + hinctnta + domicil, 
                         data = df)

mod_count_blk2 <- update(mod_count_blk1, . ~ . + health + hlthhmp + score_cardio + score_musculo + score_atopi_inflam + hltprsd + hltprsh)

mod_count_blk3 <- update(mod_count_blk2, . ~ . + access_difficulties)

mod_count_blk4 <- update(mod_count_blk3, . ~ . + ouverture + tradition)

# evaluation

cat("\n=== Comparaison des blocs (Likelihood-Ratio Test) ===\n")
anova_count <- anova(mod_count_blk1, mod_count_blk2, mod_count_blk3, mod_count_blk4)
print(anova_count)

#  Pseudo-R² (Nagelkerke)
cat("\n=== Pseudo-R2 Nagelkerke by bloc ===\n")
c(
  Bloc1_Socio = PseudoR2(mod_count_blk1, which = "Nagelkerke"),
  Bloc2_Sante = PseudoR2(mod_count_blk2, which = "Nagelkerke"),
  Bloc3_Push  = PseudoR2(mod_count_blk3, which = "Nagelkerke"),
  Bloc4_Pull  = PseudoR2(mod_count_blk4, which = "Nagelkerke")
)

cat("\n=== summary of final model (Block 4) ===\n")
summary(mod_count_blk4)

cat("\n=== Incidence Rate Ratios (IRR) and CI (95%) ===\n")
irr_table <- exp(cbind(IRR = coef(mod_count_blk4), confint(mod_count_blk4)))
print(round(irr_table, 3))


# ==============================================================================
# Visualization  model A
# ==============================================================================


or_df <- as.data.frame(or_table) %>%
  rownames_to_column(var = "Variable") %>%
  rename(OR = OR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
  filter(Variable != "(Intercept)") 

or_df <- or_df %>%
  mutate(
   
    old_OR = OR,
    old_Lower = Lower,
    old_Upper = Upper,
    
    vars_to_invert = Variable %in% c("health", "hlthhmp", "ouverture", "tradition"),
    
    OR = case_when(vars_to_invert ~ 1 / old_OR, TRUE ~ old_OR),
    Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
    Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper)
  ) %>%
  dplyr::select(-old_OR, -old_Lower, -old_Upper, -vars_to_invert) 

or_df <- or_df %>%
  mutate(
    Category = case_when(
      Variable %in% c("agea", "gndr", "eisced", "hinctnta", "domicil") ~ "1. Socio-demographics",
      Variable %in% c("health", "hlthhmp", "score_cardio", "score_musculo", "score_atopi_inflam", "hltprsd", "hltprsh", 'cesd_score') ~ "2. Health Needs",
      Variable == "access_difficulties" ~ "3. Push Factors",
      Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
    ),
    Label = case_when(
      
      Variable == "agea" ~ "Age",
      Variable == "gndr" ~ "Gender (Female)",
      Variable == "eisced" ~ "Education",
      Variable == "hinctnta" ~ "Income",
      Variable == "domicil" ~ "Rurality (higher = more rural)",
      Variable == "cesd_score" ~ "Depression score",
      Variable == "health" ~ "Poor subjective health (inverted)", 
      Variable == "hlthhmp" ~ "Daily limitations (inverted)",
      Variable == "score_cardio" ~ "Cardiovascular problems",
      Variable == "score_musculo" ~ "Musculoskeletal problems",
      Variable == "score_atopi_inflam" ~ "Atopic & inflammatory problems",
      Variable == "hltprsd" ~ "Digestive problems",
      Variable == "hltprsh" ~ "Severe headaches",
      
      Variable == "access_difficulties" ~ "Access difficulties",
      
      Variable == "ouverture" ~ "High openness (inverted)",
      Variable == "tradition" ~ "High tradition (inverted)"
    )
  )

or_df <- or_df %>%
  mutate(Label = fct_reorder(Label, OR))

p_ors <- ggplot(or_df, aes(x = OR, y = Label, color = Category)) +
 
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
  
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.2, linewidth = 1) +
  geom_point(size = 3) +
  
  scale_x_log10(breaks = c(0.8, 0.9, 1.0, 1.25, 1.5, 1.75)) +

  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Figure 4.1 : Predictors of CAM Use (Probability of consulting at least once)",
    subtitle = "Odds Ratios (OR) with 95% Confidence Intervals",
    x = "Odds Ratio (log scale)",
    y = NULL,
    color = "Model Blocks",
    caption = "Values > 1 indicate an increase in the probability of using CAM.\nData: ESS11 Health Module"
  ) +
  theme(
    legend.position = "bottom",
    panel.grid.minor.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

print(p_ors)



# ==============================================================================
# Visualization B model
# ==============================================================================

irr_df <- as.data.frame(irr_table) %>%
  rownames_to_column(var = "Variable") %>%
  rename(IRR = IRR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
  filter(Variable != "(Intercept)")

irr_df <- irr_df %>%
  mutate(
    old_IRR = IRR,
    old_Lower = Lower,
    old_Upper = Upper,
    vars_to_invert = Variable %in% c("health", "hlthhmp", "ouverture", "tradition"),
    IRR = case_when(vars_to_invert ~ 1 / old_IRR, TRUE ~ old_IRR),
    Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
    Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper)
  ) %>%
  dplyr::select(-old_IRR, -old_Lower, -old_Upper, -vars_to_invert)

irr_df <- irr_df %>%
  mutate(
    Category = case_when(
      Variable %in% c("agea", "gndr", "eisced", "hinctnta", "domicil") ~ "1. Socio-demographics",
      Variable %in% c("health", "hlthhmp", "score_cardio", "score_musculo", "score_atopi_inflam", "hltprsd", "hltprsh") ~ "2. Health Needs",
      Variable == "access_difficulties" ~ "3. Push Factors",
      Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
    ),
    Label = case_when(
      Variable == "agea" ~ "Age",
      Variable == "gndr" ~ "Gender (Female)",
      Variable == "eisced" ~ "Education",
      Variable == "hinctnta" ~ "Income",
      Variable == "domicil" ~ "Rurality (higher = more rural)",
      Variable == "health" ~ "Poor subjective health (inverted)", 
      Variable == "hlthhmp" ~ "Daily limitations (inverted)",
      Variable == "score_cardio" ~ "Cardiovascular problems",
      Variable == "score_musculo" ~ "Musculoskeletal problems",
      Variable == "score_atopi_inflam" ~ "Atopic & inflammatory problems",
      Variable == "hltprsd" ~ "Digestive problems",
      Variable == "hltprsh" ~ "Severe headaches",
      Variable == "access_difficulties" ~ "Access difficulties",
      Variable == "ouverture" ~ "High openness (inverted)",
      Variable == "tradition" ~ "High tradition (inverted)"
    )
  )

irr_df <- irr_df %>%
  mutate(Label = fct_reorder(Label, IRR))

p_irrs <- ggplot(irr_df, aes(x = IRR, y = Label, color = Category)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.2, linewidth = 1) +
  geom_point(size = 3) +
  scale_x_log10(breaks = c(0.8, 0.9, 1.0, 1.25, 1.5)) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Figure 4.2 : Predictors of CAM Intensity (Count of distinct therapies)",
    subtitle = "Incidence Rate Ratios (IRR) with 95% Confidence Intervals",
    x = "Incidence Rate Ratio (log scale)",
    y = NULL,
    color = "Model Blocks",
    caption = "Values > 1 indicate an increase in the number of CAM therapies used.\nData: ESS11 Health Module"
  ) +
  theme(
    legend.position = "bottom",
    panel.grid.minor.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

print(p_irrs)



# ==============================================================================
# Model C.1 : Homeopathy
# ==============================================================================



df_model_C_ho <- df %>%
  drop_na(trhltho, agea, gndr, eisced, hinctnta, domicil, 
          health, hlthhmp, score_cardio, score_musculo, score_atopi_inflam, 
          hltprsd, hltprsh, cesd_score,
          access_difficulties, ouverture, tradition)

mod_ho_blk1 <- glm(trhltho ~ agea + gndr + eisced + hinctnta + domicil, 
                   data = df_model_C_ho, family = binomial)

mod_ho_blk2 <- update(mod_ho_blk1, . ~ . + health + hlthhmp + score_cardio + score_musculo + score_atopi_inflam + hltprsd + hltprsh + cesd_score)

mod_ho_blk3 <- update(mod_ho_blk2, . ~ . + access_difficulties)

mod_ho_blk4 <- update(mod_ho_blk3, . ~ . + ouverture + tradition)

anova(mod_ho_blk1, mod_ho_blk2, mod_ho_blk3, mod_ho_blk4, test = "Chisq")

c(
  Bloc1_Socio = PseudoR2(mod_ho_blk1, which = "Nagelkerke"),
  Bloc2_Sante = PseudoR2(mod_ho_blk2, which = "Nagelkerke"),
  Bloc3_Push  = PseudoR2(mod_ho_blk3, which = "Nagelkerke"),
  Bloc4_Pull  = PseudoR2(mod_ho_blk4, which = "Nagelkerke")
)

hoslem.test(mod_ho_blk4$y, fitted(mod_ho_blk4), g = 10)

summary(mod_ho_blk4)

or_table_ho <- exp(cbind(OR = coef(mod_ho_blk4), confint(mod_ho_blk4)))
print(round(or_table_ho, 3))

or_df_ho <- as.data.frame(or_table_ho) %>%
  rownames_to_column(var = "Variable") %>%
  rename(OR = OR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
  filter(Variable != "(Intercept)")

or_df_ho <- or_df_ho %>%
  mutate(
    old_OR = OR,
    old_Lower = Lower,
    old_Upper = Upper,
    vars_to_invert = Variable %in% c("health", "hlthhmp", "ouverture", "tradition"),
    OR = case_when(vars_to_invert ~ 1 / old_OR, TRUE ~ old_OR),
    Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
    Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper)
  ) %>%
  dplyr::select(-old_OR, -old_Lower, -old_Upper, -vars_to_invert)

or_df_ho <- or_df_ho %>%
  mutate(
    Category = case_when(
      Variable %in% c("agea", "gndr", "eisced", "hinctnta", "domicil") ~ "1. Socio-demographics",
      Variable %in% c("health", "hlthhmp", "score_cardio", "score_musculo", "score_atopi_inflam", "hltprsd", "hltprsh", "cesd_score") ~ "2. Health Needs",
      Variable == "access_difficulties" ~ "3. Push Factors",
      Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
    ),
    Label = case_when(
      Variable == "agea" ~ "Age",
      Variable == "gndr" ~ "Gender (Female)",
      Variable == "eisced" ~ "Education",
      Variable == "hinctnta" ~ "Income",
      Variable == "domicil" ~ "Rurality (higher = more rural)",
      Variable == "health" ~ "Poor subjective health (inverted)", 
      Variable == "hlthhmp" ~ "Daily limitations (inverted)",
      Variable == "score_cardio" ~ "Cardiovascular problems",
      Variable == "score_musculo" ~ "Musculoskeletal problems",
      Variable == "score_atopi_inflam" ~ "Atopic & inflammatory problems",
      Variable == "hltprsd" ~ "Digestive problems",
      Variable == "hltprsh" ~ "Severe headaches",
      Variable == "cesd_score" ~ "Depression score",
      Variable == "access_difficulties" ~ "Access difficulties",
      Variable == "ouverture" ~ "High openness (inverted)",
      Variable == "tradition" ~ "High tradition (inverted)"
    )
  )

or_df_ho <- or_df_ho %>%
  mutate(Label = fct_reorder(Label, OR))

p_ors_ho <- ggplot(or_df_ho, aes(x = OR, y = Label, color = Category)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.2, linewidth = 1) +
  geom_point(size = 3) +
  scale_x_log10(breaks = c(0.8, 0.9, 1.0, 1.25, 1.5, 1.75, 2, 2.25)) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Figure 4.3 : Predictors of Homeopathy Use",
    subtitle = "Odds Ratios (OR) with 95% Confidence Intervals",
    x = "Odds Ratio (log scale)",
    y = NULL,
    color = "Model Blocks",
    caption = "Values > 1 indicate an increase in the probability of using Homeopathy.\nData: ESS11 Health Module"
  ) +
  theme(
    legend.position = "bottom",
    panel.grid.minor.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

print(p_ors_ho)





# ==============================================================================
# Model C.2 : Herbal
# ==============================================================================

df_model_C_ht <- df %>%
  drop_na(trhltht, agea, gndr, eisced, hinctnta, domicil, 
          health, hlthhmp, score_cardio, score_musculo, score_atopi_inflam, 
          hltprsd, hltprsh, cesd_score,
          access_difficulties, ouverture, tradition)

mod_ht_blk1 <- glm(trhltht ~ agea + gndr + eisced + hinctnta + domicil, 
                   data = df_model_C_ht, family = binomial)

mod_ht_blk2 <- update(mod_ht_blk1, . ~ . + health + hlthhmp + score_cardio + score_musculo + score_atopi_inflam + hltprsd + hltprsh + cesd_score)

mod_ht_blk3 <- update(mod_ht_blk2, . ~ . + access_difficulties)

mod_ht_blk4 <- update(mod_ht_blk3, . ~ . + ouverture + tradition)

anova(mod_ht_blk1, mod_ht_blk2, mod_ht_blk3, mod_ht_blk4, test = "Chisq")

c(
  Bloc1_Socio = PseudoR2(mod_ht_blk1, which = "Nagelkerke"),
  Bloc2_Sante = PseudoR2(mod_ht_blk2, which = "Nagelkerke"),
  Bloc3_Push  = PseudoR2(mod_ht_blk3, which = "Nagelkerke"),
  Bloc4_Pull  = PseudoR2(mod_ht_blk4, which = "Nagelkerke")
)

hoslem.test(mod_ht_blk4$y, fitted(mod_ht_blk4), g = 10)

summary(mod_ht_blk4)

or_table_ht <- exp(cbind(OR = coef(mod_ht_blk4), confint(mod_ht_blk4)))
print(round(or_table_ht, 3))

or_df_ht <- as.data.frame(or_table_ht) %>%
  rownames_to_column(var = "Variable") %>%
  rename(OR = OR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
  filter(Variable != "(Intercept)")

or_df_ht <- or_df_ht %>%
  mutate(
    old_OR = OR,
    old_Lower = Lower,
    old_Upper = Upper,
    vars_to_invert = Variable %in% c("health", "hlthhmp", "ouverture", "tradition"),
    OR = case_when(vars_to_invert ~ 1 / old_OR, TRUE ~ old_OR),
    Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
    Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper)
  ) %>%
  dplyr::select(-old_OR, -old_Lower, -old_Upper, -vars_to_invert)

or_df_ht <- or_df_ht %>%
  mutate(
    Category = case_when(
      Variable %in% c("agea", "gndr", "eisced", "hinctnta", "domicil") ~ "1. Socio-demographics",
      Variable %in% c("health", "hlthhmp", "score_cardio", "score_musculo", "score_atopi_inflam", "hltprsd", "hltprsh", "cesd_score") ~ "2. Health Needs",
      Variable == "access_difficulties" ~ "3. Push Factors",
      Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
    ),
    Label = case_when(
      Variable == "agea" ~ "Age",
      Variable == "gndr" ~ "Gender (Female)",
      Variable == "eisced" ~ "Education",
      Variable == "hinctnta" ~ "Income",
      Variable == "domicil" ~ "Rurality (higher = more rural)",
      Variable == "health" ~ "Poor subjective health (inverted)", 
      Variable == "hlthhmp" ~ "Daily limitations (inverted)",
      Variable == "score_cardio" ~ "Cardiovascular problems",
      Variable == "score_musculo" ~ "Musculoskeletal problems",
      Variable == "score_atopi_inflam" ~ "Atopic & inflammatory problems",
      Variable == "hltprsd" ~ "Digestive problems",
      Variable == "hltprsh" ~ "Severe headaches",
      Variable == "cesd_score" ~ "Depression score",
      Variable == "access_difficulties" ~ "Access difficulties",
      Variable == "ouverture" ~ "High openness (inverted)",
      Variable == "tradition" ~ "High tradition (inverted)"
    )
  )

or_df_ht <- or_df_ht %>%
  mutate(Label = fct_reorder(Label, OR))

p_ors_ht <- ggplot(or_df_ht, aes(x = OR, y = Label, color = Category)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.2, linewidth = 1) +
  geom_point(size = 3) +
  scale_x_log10(breaks = c(0.8, 0.9, 1.0, 1.25, 1.5, 1.75)) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Figure 4.4 : Predictors of Herbal Treatment Use",
    subtitle = "Odds Ratios (OR) with 95% Confidence Intervals",
    x = "Odds Ratio (log scale)",
    y = NULL,
    color = "Model Blocks",
    caption = "Values > 1 indicate an increase in the probability of using Herbal treatment.\nData: ESS11 Health Module"
  ) +
  theme(
    legend.position = "bottom",
    panel.grid.minor.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

print(p_ors_ht)


# ==============================================================================
# Model C.3 : Spiritual
# ==============================================================================

df_model_C_sh <- df %>%
  drop_na(trhltsh, agea, gndr, eisced, hinctnta, domicil, 
          health, hlthhmp, score_cardio, score_musculo, score_atopi_inflam, 
          hltprsd, hltprsh, cesd_score,
          access_difficulties, ouverture, tradition)

mod_sh_blk1 <- glm(trhltsh ~ agea + gndr + eisced + hinctnta + domicil, 
                   data = df_model_C_sh, family = binomial)

mod_sh_blk2 <- update(mod_sh_blk1, . ~ . + health + hlthhmp + score_cardio + score_musculo + score_atopi_inflam + hltprsd + hltprsh + cesd_score)

mod_sh_blk3 <- update(mod_sh_blk2, . ~ . + access_difficulties)

mod_sh_blk4 <- update(mod_sh_blk3, . ~ . + ouverture + tradition)

anova(mod_sh_blk1, mod_sh_blk2, mod_sh_blk3, mod_sh_blk4, test = "Chisq")

c(
  Bloc1_Socio = PseudoR2(mod_sh_blk1, which = "Nagelkerke"),
  Bloc2_Sante = PseudoR2(mod_sh_blk2, which = "Nagelkerke"),
  Bloc3_Push  = PseudoR2(mod_sh_blk3, which = "Nagelkerke"),
  Bloc4_Pull  = PseudoR2(mod_sh_blk4, which = "Nagelkerke")
)

hoslem.test(mod_sh_blk4$y, fitted(mod_sh_blk4), g = 10)

summary(mod_sh_blk4)

or_table_sh <- exp(cbind(OR = coef(mod_sh_blk4), confint(mod_sh_blk4)))
print(round(or_table_sh, 3))

or_df_sh <- as.data.frame(or_table_sh) %>%
  rownames_to_column(var = "Variable") %>%
  rename(OR = OR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
  filter(Variable != "(Intercept)")

or_df_sh <- or_df_sh %>%
  mutate(
    old_OR = OR,
    old_Lower = Lower,
    old_Upper = Upper,
    vars_to_invert = Variable %in% c("health", "hlthhmp", "ouverture", "tradition"),
    OR = case_when(vars_to_invert ~ 1 / old_OR, TRUE ~ old_OR),
    Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
    Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper)
  ) %>%
  dplyr::select(-old_OR, -old_Lower, -old_Upper, -vars_to_invert)

or_df_sh <- or_df_sh %>%
  mutate(
    Category = case_when(
      Variable %in% c("agea", "gndr", "eisced", "hinctnta", "domicil") ~ "1. Socio-demographics",
      Variable %in% c("health", "hlthhmp", "score_cardio", "score_musculo", "score_atopi_inflam", "hltprsd", "hltprsh", "cesd_score") ~ "2. Health Needs",
      Variable == "access_difficulties" ~ "3. Push Factors",
      Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
    ),
    Label = case_when(
      Variable == "agea" ~ "Age",
      Variable == "gndr" ~ "Gender (Female)",
      Variable == "eisced" ~ "Education",
      Variable == "hinctnta" ~ "Income",
      Variable == "domicil" ~ "Rurality (higher = more rural)",
      Variable == "health" ~ "Poor subjective health (inverted)", 
      Variable == "hlthhmp" ~ "Daily limitations (inverted)",
      Variable == "score_cardio" ~ "Cardiovascular problems",
      Variable == "score_musculo" ~ "Musculoskeletal problems",
      Variable == "score_atopi_inflam" ~ "Atopic & inflammatory problems",
      Variable == "hltprsd" ~ "Digestive problems",
      Variable == "hltprsh" ~ "Severe headaches",
      Variable == "cesd_score" ~ "Depression score",
      Variable == "access_difficulties" ~ "Access difficulties",
      Variable == "ouverture" ~ "High openness (inverted)",
      Variable == "tradition" ~ "High tradition (inverted)"
    )
  )

or_df_sh <- or_df_sh %>%
  mutate(Label = fct_reorder(Label, OR))

p_ors_sh <- ggplot(or_df_sh, aes(x = OR, y = Label, color = Category)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.2, linewidth = 1) +
  geom_point(size = 3) +
  scale_x_log10(breaks = c(0.8, 0.9, 1.0, 1.25, 1.5, 1.75)) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Figure 4.5 : Predictors of Spiritual Healing Use",
    subtitle = "Odds Ratios (OR) with 95% Confidence Intervals",
    x = "Odds Ratio (log scale)",
    y = NULL,
    color = "Model Blocks",
    caption = "Values > 1 indicate an increase in the probability of using Spiritual healing.\nData: ESS11 Health Module"
  ) +
  theme(
    legend.position = "bottom",
    panel.grid.minor.x = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

print(p_ors_sh)

# ==============================================================================
# Model D : Acceptation groups
# ==============================================================================


df <- df %>%
  mutate(
    grp1_paraconv = ifelse(rowSums(select(., any_of(c("trhltpt", "trhltos"))) == 1, na.rm = TRUE) > 0, 1, 0),
    grp2_tolerated = ifelse(rowSums(select(., any_of(c("trhltma", "trhltho", "trhltht"))) == 1, na.rm = TRUE) > 0, 1, 0),
    grp3_heterodox = ifelse(rowSums(select(., any_of(c("trhltac", "trhltch", "trhltcm", "trhlthy"))) == 1, na.rm = TRUE) > 0, 1, 0),
    grp4_marginal = ifelse(rowSums(select(., any_of(c("trhltsh", "trhltrf", "trhltap"))) == 1, na.rm = TRUE) > 0, 1, 0)
  )

run_cam_group <- function(data, target_var, plot_label) {
  
  df_mod <- data %>%
    drop_na(all_of(target_var), agea, gndr, eisced, hinctnta, domicil, 
            health, hlthhmp, score_cardio, score_musculo, score_atopi_inflam, 
            hltprsd, hltprsh, cesd_score, access_difficulties, ouverture, tradition)
  
  f1 <- as.formula(paste(target_var, "~ agea + gndr + eisced + hinctnta + domicil"))
  
  mod_blk1 <- glm(f1, data = df_mod, family = binomial)
  mod_blk2 <- update(mod_blk1, . ~ . + health + hlthhmp + score_cardio + score_musculo + score_atopi_inflam + hltprsd + hltprsh + cesd_score)
  mod_blk3 <- update(mod_blk2, . ~ . + access_difficulties)
  mod_blk4 <- update(mod_blk3, . ~ . + ouverture + tradition)
  
  print(anova(mod_blk1, mod_blk2, mod_blk3, mod_blk4, test = "Chisq"))
  
  print(c(
    Bloc1_Socio = PseudoR2(mod_blk1, which = "Nagelkerke"),
    Bloc2_Sante = PseudoR2(mod_blk2, which = "Nagelkerke"),
    Bloc3_Push  = PseudoR2(mod_blk3, which = "Nagelkerke"),
    Bloc4_Pull  = PseudoR2(mod_blk4, which = "Nagelkerke")
  ))
  
  print(hoslem.test(mod_blk4$y, fitted(mod_blk4), g = 10))
  print(summary(mod_blk4))
  
  or_table <- exp(cbind(OR = coef(mod_blk4), confint(mod_blk4)))
  print(round(or_table, 3))
  
  or_df <- as.data.frame(or_table) %>%
    rownames_to_column(var = "Variable") %>%
    rename(OR = OR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
    filter(Variable != "(Intercept)") %>%
    mutate(
      old_OR = OR, old_Lower = Lower, old_Upper = Upper,
      vars_to_invert = Variable %in% c("health", "hlthhmp", "ouverture", "tradition"),
      OR = case_when(vars_to_invert ~ 1 / old_OR, TRUE ~ old_OR),
      Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
      Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper)
    ) %>%
    dplyr::select(-old_OR, -old_Lower, -old_Upper, -vars_to_invert) %>%
    mutate(
      Category = case_when(
        Variable %in% c("agea", "gndr", "eisced", "hinctnta", "domicil") ~ "1. Socio-demographics",
        Variable %in% c("health", "hlthhmp", "score_cardio", "score_musculo", "score_atopi_inflam", "hltprsd", "hltprsh", "cesd_score") ~ "2. Health Needs",
        Variable == "access_difficulties" ~ "3. Push Factors",
        Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
      ),
      Label = case_when(
        Variable == "agea" ~ "Age", Variable == "gndr" ~ "Gender (Female)",
        Variable == "eisced" ~ "Education", Variable == "hinctnta" ~ "Income",
        Variable == "domicil" ~ "Rurality (higher = more rural)", 
        Variable == "health" ~ "Poor subjective health (inverted)", 
        Variable == "hlthhmp" ~ "Daily limitations (inverted)",
        Variable == "score_cardio" ~ "Cardiovascular problems",
        Variable == "score_musculo" ~ "Musculoskeletal problems",
        Variable == "score_atopi_inflam" ~ "Atopic & inflammatory problems",
        Variable == "hltprsd" ~ "Digestive problems",
        Variable == "hltprsh" ~ "Severe headaches",
        Variable == "cesd_score" ~ "Depression score",
        Variable == "access_difficulties" ~ "Access difficulties",
        Variable == "ouverture" ~ "High openness (inverted)",
        Variable == "tradition" ~ "High tradition (inverted)"
      )
    ) %>%
    mutate(Label = fct_reorder(Label, OR))
  
  p <- ggplot(or_df, aes(x = OR, y = Label, color = Category)) +
    geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
    geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.2, linewidth = 1) +
    geom_point(size = 3) +
    scale_x_log10(breaks = c(0.8, 0.9, 1.0, 1.25, 1.5, 1.75, 2.0)) +
    scale_color_brewer(palette = "Set1") +
    theme_minimal(base_size = 12) +
    labs(
      title = paste("Predictors of", plot_label, "Use"),
      subtitle = "Odds Ratios (OR) with 95% Confidence Intervals",
      x = "Odds Ratio (log scale)",
      y = NULL,
      color = "Model Blocks",
      caption = paste("Values > 1 indicate an increase in the probability of using", plot_label, ".\nData: ESS11 Health Module")
    ) +
    theme(legend.position = "bottom", panel.grid.minor.x = element_blank(), axis.text.y = element_text(face = "bold"))
  
  print(p)
  return(list(model = mod_blk4, plot = p))
}

res_grp1 <- run_cam_group(df, "grp1_paraconv", "Paraconventional Therapies")
res_grp2 <- run_cam_group(df, "grp2_tolerated", "Tolerated Therapies")
res_grp3 <- run_cam_group(df, "grp3_heterodox", "Heterodox Therapies")
res_grp4 <- run_cam_group(df, "grp4_marginal", "Marginal Therapies")

# ==============================================================================
# comparison (Acceptance Groups)
# ==============================================================================

extract_push_pull <- function(model_obj, model_name) {
  
  suppressMessages(or_table <- exp(cbind(OR = coef(model_obj), confint(model_obj))))
  
  df <- as.data.frame(or_table) %>%
    rownames_to_column(var = "Variable") %>%
    rename(OR = OR, Lower = `2.5 %`, Upper = `97.5 %`) %>%
    filter(Variable %in% c("access_difficulties", "ouverture", "tradition")) %>%
    mutate(
      old_OR = OR, old_Lower = Lower, old_Upper = Upper,
      vars_to_invert = Variable %in% c("ouverture", "tradition"),
      
      OR = case_when(vars_to_invert ~ 1 / old_OR, TRUE ~ old_OR),
      Lower = case_when(vars_to_invert ~ 1 / old_Upper, TRUE ~ old_Lower),
      Upper = case_when(vars_to_invert ~ 1 / old_Lower, TRUE ~ old_Upper),
      Model = model_name
    ) %>%
    dplyr::select(Variable, OR, Lower, Upper, Model)
  
  return(df)
}
df_push_pull <- bind_rows(
  or_df %>% 
    filter(Variable %in% c("access_difficulties", "ouverture", "tradition")) %>% 
    dplyr::select(Variable, OR, Lower, Upper) %>% 
    mutate(Model = "1. Global CAM Use"),
  extract_push_pull(res_grp1$model, "2. Paraconventional"),
  extract_push_pull(res_grp2$model, "3. Tolerated"),
  extract_push_pull(res_grp3$model, "4. Heterodox"),
  extract_push_pull(res_grp4$model, "5. Marginal")
)

df_push_pull <- df_push_pull %>%
  mutate(
    Category = case_when(
      Variable == "access_difficulties" ~ "3. Push Factors",
      Variable %in% c("ouverture", "tradition") ~ "4. Pull Factors"
    ),
    Label = case_when(
      Variable == "access_difficulties" ~ "Access difficulties",
      Variable == "ouverture" ~ "High openness (inverted)",
      Variable == "tradition" ~ "High tradition (inverted)"
    ),
    Factor_Type = ifelse(Category == "3. Push Factors", "Push Factor (Access Difficulties)", "Pull Factor (Values)"),
    Label = factor(Label, levels = c("Access difficulties", "High tradition (inverted)", "High openness (inverted)")),
    
    Model = factor(Model, levels = rev(c("1. Global CAM Use", "2. Paraconventional", "3. Tolerated", "4. Heterodox", "5. Marginal")))
  )
p_push_pull_groups <- ggplot(df_push_pull, aes(x = Model, y = OR, color = Label, shape = Factor_Type)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black", linewidth = 0.8) +
  geom_linerange(aes(ymin = Lower, ymax = Upper), position = position_dodge(width = 0.6), linewidth = 1) +
  geom_point(position = position_dodge(width = 0.6), size = 3.5) +
  scale_color_manual(values = c("Access difficulties" = "#4DAF4A", 
                                "High tradition (inverted)" = "#984EA3", 
                                "High openness (inverted)" = "#FF7F00")) +
  scale_shape_manual(values = c("Push Factor (Access Difficulties)" = 16, "Pull Factor (Values)" = 17)) +
  scale_y_log10(breaks = c(0.8, 0.9, 1.0, 1.1, 1.25, 1.5)) +
  coord_flip() +
  theme_minimal(base_size = 12) +
  labs(
    title = "Push vs Pull Dynamics across Acceptance Groups",
    subtitle = "Odds Ratios for conventional barriers (Push) vs cultural values (Pull)",
    x = NULL,
    y = "Odds Ratio (log scale)",
    color = "Predictor",
    shape = "Hypothesis Group",
    caption = "Values > 1 indicate an increase in the probability of use.\nData: ESS11 Health Module"
  ) +
  theme(
    legend.position = "bottom",
    legend.box = "vertical",
    legend.margin = margin(t = 0, unit='cm'),
    panel.grid.minor.x = element_blank(),
    axis.text.y = element_text(face = "bold", size = 11)
  )

print(p_push_pull_groups)