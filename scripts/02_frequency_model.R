dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

library(dplyr)
library(broom)

df <- read.csv("outputs/claims_datasim.csv")

freq_fit <- glm(
  claim_count ~ agecat + valuecat + offset(log(exposure)),
  family = poisson(link = "log"),
  data = df
)

freq_coef <- broom::tidy(freq_fit, conf.int = TRUE)
write.csv(freq_coef, "outputs/frequency_glm_coefficients.csv", row.names = FALSE)


df_freq <- df %>% 
  mutate(freq_hat = as.numeric(predict(freq_fit, type = "response")))

saveRDS(df_freq, "outputs/claims_with_freq_hat.rds")

cat("Saved:\n",
    "- outputs/frequency_glm_coefficients.csv\n",
    "- outputs/claims_with_freq_hat.rds\n")