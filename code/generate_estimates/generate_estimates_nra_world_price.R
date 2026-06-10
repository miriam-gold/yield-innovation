# ----------------------------------------------------------------------------
#'
#' Description: Regress Nominal rate of assistance on world price
#' Author: Miriam Gold
#' Date: 9 June 2026
#' Last revised: date, mag
#' Why: We want to know how much of NRA is explained by world price variation. Is there any leftover variation?
#'
# ---------------------------------------------------------------------------- #

# Read ================================
distortions_world_price_merged <-
  path_data_clean %>%
  file.path("wb_distortions", "distortions_world_price_merged.csv") %>%
  read_csv()

# Analyze ==============================

reg_nra_world_price <-
  fixest::feols(
    nra ~ log(price_nom),
    fixef = c("country", "year", "commodity_harmonized", "trstat2"),
    data = distortions_world_price_merged
  )

reg_nra_world_price %>%
  broom::glance()

# Write ================================
