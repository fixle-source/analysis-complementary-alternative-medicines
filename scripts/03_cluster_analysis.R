library(tidyverse)
library(poLCA)
library(psych)
library(knitr)
library(ggcorrplot)

df <- readRDS("data/processed/ess_processed.rds")

# First attempt at LCA with 12 CAM and 2 conventionnals

lca_vars <- c("trhltacu", "trhltho", "trhltht", "trhltch",
              "trhltos",  "trhltre", "trhltsh", "trhltacp",
              "trhltcm",  "trhlthy", "trhltpt", "trhltmt", "dshltgp", "dshltms")

# 1 and 0 coded in 2 and 1 for LCA

data_lca <- df %>%
  dplyr::select(all_of(lca_vars)) %>%
  mutate(across(everything(), ~ case_when(
    . == 1 ~ 1L,
    . == 0 ~ 2L,
    TRUE   ~ NA_integer_
  ))) %>%
  drop_na()

lca_14_formula <- cbind(trhltacu, trhltho, trhltht, trhltch,
           trhltos,  trhltre, trhltsh, trhltacp,
           trhltcm,  trhlthy, trhltpt, trhltmt, dshltgp, dshltms) ~ 1

# prepare entropy computation

compute_entropy <- function(model) {
  probs <- model$posterior
  N     <- nrow(probs)
  K     <- ncol(probs)
  probs[probs == 0] <- .Machine$double.eps
  raw_entropy <- -sum(probs * log(probs))
  1 - raw_entropy / (N * log(K))
}

set.seed(123)
n_classes <- 1:7
lca_14_models <- list()
fit_14_indices <- tibble()

for (k in n_classes) {
  cat("\n--- Fitting LCA model:", k, "classes ---\n")
  
  lca_14_models[[k]] <- poLCA(
    formula   = lca_14_formula,
    data      = data_lca,
    nclass    = k,
    maxiter   = 5000,
    nrep      = 20,     
    tol       = 1e-10,
    verbose   = FALSE
  )
  
  m <- lca_14_models[[k]]
  
  fit_14_indices <- bind_rows(fit_14_indices, tibble(
    Classes = k,
    LogLik  = round(m$llik, 2),
    AIC     = round(m$aic,  2),
    BIC     = round(m$bic,  2),
    Entropy = round(compute_entropy(m), 3)
  ))
}

cat("\n=== LCA fit indices ===\n")
kable(fit_14_indices,
      caption = "Table 3.1 : LCA with 14 variables fit indices (2 to 7 classes)")
cat("
Interpretation:
  - BIC     : lower is better
  - AIC     : lower is better
  - Entropy : > 0.80 = well-separated classes
")

# Second attempt at LCA without conventional

lca_12_formula <- cbind(trhltacu, trhltho, trhltht, trhltch,
                        trhltos,  trhltre, trhltsh, trhltacp,
                        trhltcm,  trhlthy, trhltpt, trhltmt) ~ 1

lca_12_models <- list()
fit_12_indices <- tibble()

for (k in n_classes) {
  cat("\n--- Fitting LCA model:", k, "classes ---\n")
  
  lca_12_models[[k]] <- poLCA(
    formula   = lca_12_formula,
    data      = data_lca,
    nclass    = k,
    maxiter   = 5000,
    nrep      = 20,     
    tol       = 1e-10,
    verbose   = FALSE
  )
  
  n <- lca_12_models[[k]]
  
  fit_12_indices <- bind_rows(fit_12_indices, tibble(
    Classes = k,
    LogLik  = round(n$llik, 2),
    AIC     = round(n$aic,  2),
    BIC     = round(n$bic,  2),
    Entropy = round(compute_entropy(n), 3)
  ))
}

cat("\n=== LCA fit indices ===\n")
kable(fit_12_indices,
      caption = "Table 3.2 : LCA with 12 variables fit indices (2 to 7 classes)")
cat("
Interpretation:
  - BIC     : lower is better
  - AIC     : lower is better
  - Entropy : > 0.80 = well-separated classes
")

# Deceiving results of the LCAs, checking tetrachoric corelations

data_lca_binary <- data_lca %>%
  dplyr::select(all_of(lca_vars)) %>%
  mutate(across(everything(), ~ case_when(
    . == 1 ~ 1L,
    . == 2 ~ 0L,
    TRUE   ~ NA_integer_
  )))

tet_data_lca <- tetrachoric(data_lca_binary)
cat("\nMean tetrachoric correlation:", round(mean(tet_data_lca$rho[lower.tri(tet_data_lca$rho)]), 3), "\n")
corr_matrix <- tet_data_lca$rho

# heatmap

ggcorrplot(corr_matrix, 
           method = "square",       
           type = "lower",          
           lab = TRUE,              
           lab_size = 3,            
           colors = c("#6D9EC1", "white", "#E46726"),
           title = "Figure 3.1 : Tetrachoric correlation heatmap",
           legend.title = "Correlation",
           ggtheme = ggplot2::theme_minimal())