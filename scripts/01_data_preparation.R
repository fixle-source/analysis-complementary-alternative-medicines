# ==============================================================================
# 01_data_preparation.R
# Purpose : loading, cleaning and building variables
# ==============================================================================

# Packages  --------------------------------------------------------------------
library(tidyverse)
library(psych)      # for Cronbach's alpha

# Files path -------------------------------------------------------------------
raw_data_path <- "data/raw/ESS11e04_1.csv"
output_path <- "data/processed/ess_processed.rds"

# 1. Data loading ==============================================================

cat("Loading ESS dataset...\n")
ess_raw <- read_csv(raw_data_path, 
                    col_types = cols(), 
                    na = c("", "NA", "9999", "7777", "8888"))

cat("Initial size:", dim(ess_raw), "\n")

# 2. Variables selection =======================================================

# 12 alternative medicines
mca_vars <- c("trhltacu", "trhltho", "trhltht", "trhltch", "trhltos", 
              "trhltpt", "trhltre", "trhltsh", "trhltacp", "trhltcm", 
              "trhlthy", "trhltmt")

# Conventional medicines
conv_vars <- c("dshltgp", "dshltms")

# Access difficulty
access_vars <- c("medtrun", "medtrnp", "medtrnt", "medtrnl", "medtrwl", "medtrnaa")

# Health variables
health_vars <- c("health", "hlthhmp", "hltprbn", "hltprpa", "hltprpf")

# Variables for depression score (CES-D)
cesd_items <- c("fltdpr", "flteeff", "slprl", "wrhpp", "fltlnl", 
                "enjlf", "fltsd", "cldgng")

# Values variables (Portrait Values Questionnaire)
values_vars <- c("ipcrtiva", "impdiffa", "ipadvnta", "impenva", 
                 "iphlppla", "imptrada", "impsafea", "impricha")

# Control variables
control_vars <- c("gndr", "agea", "eisced", "hinctnta", "cntry", "domicil")

# Weighting
weight_vars <- c("anweight", "pspwght", "pweight")

# Selection
all_vars <- c(mca_vars, conv_vars, access_vars, health_vars, cesd_items, 
              values_vars, control_vars, weight_vars)

ess_selected <- ess_raw %>% 
  select(all_of(all_vars))

cat("Selected variables:", ncol(ess_selected), "\n")

# 3. Missing data ==============================================================

cat("\n=== Missing data rate by variables ===\n")
missing_rates <- ess_selected %>% 
  summarise(across(everything(), ~mean(is.na(.)))) %>% 
  pivot_longer(everything(), names_to = "variable", values_to = "missing_rate") %>% 
  arrange(desc(missing_rate))

print(missing_rates, n = 50)

# 4. Composit score codification ===============================================

ess_processed <- ess_selected %>% 
  mutate(
    mca_count = rowSums(select(., all_of(mca_vars)) == 1, na.rm = TRUE),
    
    # Creation of 4 variables for future MANOVA
    mca_0 = case_when(
      mca_count == 0 ~ 1,
      TRUE ~ 0
    ),
    
    mca_1 = case_when(
      mca_count == 1 ~ 1,
      TRUE ~ 0
    ),
    
    mca_2_3 = case_when(
      mca_count >= 2 & mca_count <= 3 ~ 1,
      TRUE ~ 0
    ),
    
    mca_4plus = case_when(
      mca_count >= 4 ~ 1,
      TRUE ~ 0
    ),
    
    mca_category = case_when(
      mca_count == 0 ~ "0_MCA",
      mca_count == 1 ~ "1_MCA",
      mca_count >= 2 & mca_count <= 3 ~ "2-3_MCA",
      mca_count >= 4 ~ "4+_MCA"
    ) %>% factor(levels = c("0_MCA", "1_MCA", "2-3_MCA", "4+_MCA"),
                 ordered = TRUE),
    
    # CES-D score (depression)
    # Correcting missing value (7, 8, 9)
    across(all_of(cesd_items), ~na_if(., 7)),
    across(all_of(cesd_items), ~na_if(., 8)),
    across(all_of(cesd_items), ~na_if(., 9)),
    
    # inversion of 2 positive items (happy and enjoyed life)
    cesd_wrhpp_inv = case_when(
      is.na(wrhpp) ~ NA_real_,
      TRUE ~ 5 - wrhpp
    ),
    cesd_enjlf_inv = case_when(
      is.na(enjlf) ~ NA_real_,
      TRUE ~ 5 - enjlf
    ),
    
    # Valid items count
    cesd_n_valid = rowSums(!is.na(cbind(fltdpr, flteeff, slprl, 
                                        cesd_wrhpp_inv, fltlnl, 
                                        cesd_enjlf_inv, fltsd, cldgng))),
    
    # Compute prorated CES-D score (only if ≥ 6 out of 8 valid items)
    cesd_score = case_when(
      cesd_n_valid < 6 ~ NA_real_,  # less than 75% of valid items = missing score
      TRUE ~ rowMeans(cbind(fltdpr, flteeff, slprl, cesd_wrhpp_inv, 
                            fltlnl, cesd_enjlf_inv, fltsd, cldgng), 
                      na.rm = TRUE) * 8  # prorate = mean x 8
    ),
    
    # Access to care services difficulty score
    access_difficulties = medtrnp + medtrnt + medtrnl + medtrwl + medtrnaa,
    
    # Values score
    ouverture = (ipcrtiva + impdiffa + ipadvnta) / 3,
    tradition = (imptrada + impsafea) / 2,
    
    # Weight for cross-country comparison
    cross_country_weight = pspwght * pweight
  )

# 5. Internal consistency check ================================================

cat("\n=== Internal consistency of CES-D score ===\n")
cesd_data <- ess_processed %>% 
  select(all_of(cesd_items)) %>% 
  
  mutate(
    wrhpp = 5 - wrhpp,
    enjlf = 5 - enjlf
  ) %>% 
  drop_na()

alpha_cesd <- alpha(cesd_data)
cat("Cronbach's alpha CES-D:", round(alpha_cesd$total$raw_alpha, 3), "\n")

if(alpha_cesd$total$raw_alpha < 0.70) {
  warning("Alpha < 0.70 : insufficient")
}

# 6. Descriptive statistics ====================================================

cat("\n=== Rate of use of CAM ===\n")
mca_freq <- ess_processed %>% 
  select(all_of(mca_vars)) %>% 
  summarise(across(everything(), ~sum(. == 1, na.rm = TRUE))) %>% 
  pivot_longer(everything(), names_to = "treatment", values_to = "n_users") %>% 
  mutate(percentage = round(n_users / nrow(ess_processed) * 100, 2)) %>% 
  arrange(desc(n_users))

print(mca_freq)

cat("\n=== Overall use of CAM ===\n")
cat("N CAM users:", sum(ess_processed$mca_count >= 1, na.rm = TRUE), "\n")
cat("Rate:", round(mean(ess_processed$mca_count >= 1, na.rm = TRUE) * 100, 2), "%\n")

# 7. Checking distributions ====================================================

cat("\n=== Depression score distribution (CES-D) ===\n")
summary(ess_processed$cesd_score)

cat("\n=== Access difficulties distribution ===\n")
table(ess_processed$access_difficulties, useNA = "ifany")

# 8. Processed data export =====================================================

saveRDS(ess_processed, file = output_path)
write_csv(ess_processed, str_replace(output_path, ".rds", ".csv"))
cat("Data saved at:", output_path, "\n")
cat("\nFinal size:", dim(ess_processed), "\n")
