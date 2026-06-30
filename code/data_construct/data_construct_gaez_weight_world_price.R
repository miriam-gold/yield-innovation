# ----------------------------------------------------------------------------
#'
#' Description: Construct a GAEZ-weighted world price country panel
#' Author: Miriam Gold
#' Date: 29 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Read =================================

## GAEZ from G Drive (historical rainfed yield, kg/ha)
gaez_yield_by_country <-
  path_drive %>%
  file.path("gaez_avg_yield_by_country.csv") %>%
  read_csv()

## Pink sheet world prices (real or nominal?)
wb_world_price_annual <-
  path_data_clean %>%
  file.path("wb_pinksheet", 'wb_world_price_annual_clean.csv') %>%
  read_csv()

# Clean ================================

## Price data
gaez_yl_by_country_crop <-
  gaez_yield_by_country %>%
  janitor::clean_names() %>%
  select(starts_with("x"), country_co, country_na) %>%
  rename_with(~ str_remove(.x, "x\\d_yl_hr_")) %>%
  pivot_longer(
    cols = !starts_with("country_"),
    names_to = "crop",
    values_to = "mean_attain_yl"
  ) %>%
  filter(country_co != "UU", crop %in% c("mze", "soy", "olp")) %>%
  mutate(
    commodity_harmonized = case_when(
      crop == "mze" ~ "maize",
      crop == "olp" ~ "palmoil",
      crop == "soy" ~ "soybean"
    )
  )

# Major biofuel crops
biofuel_crops <- c(
  "maize",
  "palmoil",
  "soybean"
)

## Express each product price as a within product z-score
wb_world_price_z_score <-
  wb_world_price_annual %>%
  filter(commodity_harmonized %in% biofuel_crops, source == "real") %>%
  group_by(commodity_harmonized) %>%
  mutate(
    price_z_score = (price - mean(price)) / sd(price)
  )


## For each country-year, calculate average world price, weighted by country's GAEZ average attainble yield

price_yl_weighted_panel <-
  full_join(
    gaez_yl_by_country_crop,
    wb_world_price_z_score,
    by = join_by(commodity_harmonized),
    relationship = "many-to-many"
  ) %>%
  relocate(country_na, crop, year) %>%
  group_by(country_na, country_co, year) %>%
  summarize(
    price_z_yl_weighted = weighted.mean(price_z_score, mean_attain_yl)
  ) %>%
  ungroup() %>%
  replace_na(list(price_z_yl_weighted = 0))


# Write ================================
price_yl_weighted_panel %>%
  write_csv(
    file.path(
      path_data_clean,
      "wb_pinksheet",
      "wb_world_price_yl_weighted.csv"
    )
  )
