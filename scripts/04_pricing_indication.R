
dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

library(dplyr)

df_freq <- readRDS("outputs/claims_with_freq_hat.rds")
df_sev  <- readRDS("outputs/claims_with_sev_hat.rds")

df <- df_freq %>%
  select(policyID, period, exposure, agecat, valuecat, claim_count, total_claim_amount, freq_hat) %>%
  left_join(
    df_sev %>% select(policyID, period, sev_hat),
    by = c("policyID", "period")
  ) %>%
  mutate(
    pure_premium_hat = freq_hat * sev_hat
  )

indicated_pp <- weighted.mean(df$pure_premium_hat, w = df$exposure, na.rm = TRUE)

pricing_summary <- df %>%
  group_by(agecat, valuecat) %>%
  summarise(
    exposure_sum = sum(exposure, na.rm = TRUE),
    avg_freq = weighted.mean(freq_hat, w = exposure, na.rm = TRUE),
    avg_sev  = weighted.mean(sev_hat,  w = exposure, na.rm = TRUE),
    pure_premium = weighted.mean(pure_premium_hat, w = exposure, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(agecat, valuecat)

write.csv(pricing_summary, "outputs/pricing_summary.csv", row.names = FALSE)

writeLines(
  paste0(
    "Indicated Pure Premium (Frequency-Severity GLM): ", signif(indicated_pp, 8), "\n",
    "Frequency: Poisson(log) with offset(log(exposure))\n",
    "Severity: Gamma(log) on positive claims\n",
    "Data: insuranceData::ClaimsLong"
  ),
  "outputs/indicated_pp_freqsev.txt"
)

cat("Saved:\n",
    "- outputs/pricing_summary.csv\n",
    "- outputs/indicated_pp_freqsev.txt\n")
