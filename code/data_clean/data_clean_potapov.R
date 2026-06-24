# ----------------------------------------------------------------------------
#'
#' Description: Clean Potapov cropland expansion data
#' Author: Miriam Gold
#' Date: 24 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Read =================================

potapov_cropland_by_country_raw <-
  path_drive %>%
  file.path("potapov_cropland_by_country.csv") %>%
  read_csv()

# Clean ================================

potapov_cropland_by_country_clean <-
  potapov_cropland_by_country_raw %>%
  clean_names() %>%
  select(country_co, starts_with("x")) %>%
  pivot_longer(
    cols = starts_with("x"),
    names_to = "year",
    values_to = "cropland_sqm",
    names_prefix = "x\\d_"
  ) %>%
  mutate(
    year = as.integer(year),
    cropland_ha = cropland_sqm * 1e-4
  ) %>%
  group_by(country_co, year) %>%
  arrange(desc(cropland_ha)) %>%
  ungroup() %>%
  distinct(country_co, year, .keep_all = TRUE)

# Write ================================
potapov_cropland_by_country_clean %>%
  write_csv(
    file.path(
      path_data_clean,
      "potapov",
      "potapov_cropland_by_country_clean.csv"
    )
  )
