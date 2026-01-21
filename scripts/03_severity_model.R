dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

library(dplyr)
library(broom)

df <- read.csv("outputs/claims_datasim.csv")

sev_data <- df %>%
  filter(claim_count > 0, total_claim_amount > 0)

quantile(sev_data$total_claim_amount, c(0.01, 0.1, 0.5, 0.9, 0.99))

sev_fit <- glm(
  total_claim_amount ~ agecat + valuecat,
  family = Gamma(link = "log"),
  data = sev_data)

sev_coef <- broom::tidy(sev_fit, conf.int = TRUE)
write.csv(sev_coef, "outputs/severity_glm_coefficients.csv", row.names = FALSE)

df_sev <- df %>%
  mutate(sev_hat = as.numeric(predict(sev_fit, newdata = df, type = "response")))

saveRDS(df_sev, "outputs/claims_with_sev_hat.rds")

cat("Saved:\n",
    "- outputs/severity_glm_coefficients.csv\n",
    "- outputs/claims_with_sev_hat.rds\n")
