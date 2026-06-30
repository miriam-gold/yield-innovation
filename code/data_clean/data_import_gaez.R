# ----------------------------------------------------------------------------
#'
#' Description: Import raw GAEZ crop suitability rasters from the FAO endpoint
#' Author: Miriam Gold
#' Date: 16 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Read =====================================

## Crop codes (n = 48)
cropcodes <-
  path_data_raw_gaez %>%
  file.path("cropcode.csv") %>%
  read_csv()

biofuel_crop_codes <-
  cropcodes %>%
  filter(
    crop %in%
      c(
        "maize",
        "oil_palm",
        "soybean",
        "sugarcane",
        "sugarbeet",
        "rapeseed",
        "sunflower"
      )
  ) %>%
  pull(code)

## Attainable yields
for (crop in biofuel_crop_codes) {
  gaez_download(
    cropcode = crop, # cropcode.csv
    variable = "yl", # https://floswald.github.io/GAEZr/reference/theme4_varnames.html
    input = "H", # (H)igh or (L)ow
    irrigation = "r", # (r)ainfed or (i)rrigated
    scenario = c("CRUTS32", "Hist", "8110"), # Climate model | climate scenario | time period (8110 = 1981-2010)
    dir = file.path(path_data_raw_gaez, "attainable"),
    res = "res05/" #
  )
}
