#' @description Retrieve and save locally county-level census data on corn and soybeans for a given state

import_census_county_corn_soybean <- function(state) {
  params <- list(
    source_desc = "CENSUS",
    agg_level_desc = "COUNTY",
    commodity_desc = c("corn", "soybeans"),
    state_alpha = state
  )

  census_data <- nassqs(params)

  filename <- paste0("nass_county_corn_soybean_", state, ".csv")

  write_csv(
    census_data,
    file = file.path(path_data_raw, "nass_census", filename)
  )

  message("Saved: ", filename)
}
