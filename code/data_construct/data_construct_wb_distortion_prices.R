# ----------------------------------------------------------------------------
#'
#' Description: Merge NRA and world prices datasets by crop
#' Author: Miriam Gold
#' Date: 9 June 2026
#' Last revised: date, mag
#' Why: We will use this dataset for a regression testing how much of NRA
#' is explained by world price variation
#'
# ---------------------------------------------------------------------------- #

# Read ===========================

## Major crops
major_crops <- c(
  "barley",
  "maize",
  "palmoil",
  "rice",
  "soybean",
  "wheat"
)

## NRA ====================
wb_distortions <-
  path_data_clean %>%
  file.path("wb_distortions", "wb_distortions_clean.csv") %>%
  read_csv()

## World prices ===========
wb_world_price_annual <-
  path_data_clean %>%
  file.path("wb_pinksheet", 'wb_world_price_annual_clean.csv') %>%
  read_csv()

# Work ===========================
wb_distortions_filtered <-
  wb_distortions %>%
  select(country, year, commodity, trstat2, nra) %>%
  filter(
    commodity %in% major_crops
  )

distortions_world_price_merged <-
  wb_world_price_annual %>%
  filter(commodity_harmonized %in% major_crops) %>%
  full_join(
    wb_distortions_filtered,
    by = join_by(year == year, commodity_harmonized == commodity),
    relationship = "many-to-many"
  ) %>%
  filter(
    !is.na(nra),
    !is.na(price_nom)
  ) %>%
  mutate(
    price_nom_ln = log(price_nom)
  )

# Write ===========================
distortions_world_price_merged %>%
  write_csv(
    file.path(
      path_data_clean,
      "wb_distortions",
      "distortions_world_price_merged.csv"
    )
  )
