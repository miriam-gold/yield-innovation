#=================================
#
# Title: USDA NASS API calls
# Description: Retrieve data from USDA NASS QuickStats API (https://quickstats.nass.usda.gov/)
# Author: Miriam Gold
# Last revised: 28 May 2026
#
# =================================

path_secrets %>%
  file.path("nass_apikey_miriam.txt") %>%
  read_lines() %>%
  nassqs_auth()

state_list <-
  read_lines(
    file.path(path_data_raw, "states_conus.txt")
  )

# Retrieve corn and soybean data for all states and write to local file
purrr::walk(
  state_list,
  import_census_county_corn_soybean
)
