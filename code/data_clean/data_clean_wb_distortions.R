# ---------------------------------------------------------------------------- #
#'
#' Description: World Bank nominal rate of assistance panel (country-by-crop)
#' Author: Miriam Gold
#' Date: 2 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Read ========================
data_wb_distortions_raw <-
  path_data_raw %>%
  file.path(
    "wb_distortions",
    "UpdatedDistortions_to_AgriculturalIncentives_database_0613.xls"
  ) %>%
  read_xls(sheet = "Data")

wb_distortion_commodities <-
  data_wb_distortions %>%
  distinct(prod2)

data_wb_distortions_clean <-
  data_wb_distortions_raw %>%
  filter(prod2 != "GENERAL") %>%
  rename(
    commodity = "prod2"
  )

# Write =================================

## Reference table for WB NRA-recorded commodities
wb_distortion_commodities %>%
  write_csv(
    file.path(
      path_data_clean,
      "wb_distortions",
      "wb_distortion_commodities.csv"
    )
  )

## Cleaned NRA panel
data_wb_distortions_clean %>%
  write_csv(
    file.path(
      path_data_clean,
      "wb_distortions",
      "wb_distortions_clean.csv"
    )
  )
