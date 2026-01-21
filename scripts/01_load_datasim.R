dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

library(dplyr)
library(insuranceData)

data("ClaimsLong")  

df <- ClaimsLong %>%
  mutate(
    exposure = 1,                           
    claim_count = as.integer(numclaims),
    total_claim_amount = as.numeric(claim*valuecat),
    has_claim = as.integer(claim_count > 0)
  ) %>%
  select(
    policyID, period, exposure,
    agecat, valuecat,
    claim_count, total_claim_amount, has_claim
  )

stopifnot(all(df$exposure > 0))
stopifnot(all(df$claim_count >= 0))
stopifnot(all(df$total_claim_amount >= 0))

write.csv(df, "outputs/claims_datasim.csv", row.names = FALSE)

cat("Saved: outputs/claims_datasim.csv\n")