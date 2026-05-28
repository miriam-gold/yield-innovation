#=================================
#
# Title: USDA NASS API calls
# Description: Retrieve data from USDA ag survey API
# Author: Miriam Gold
# Last revised: 28 May 2026
#
# =================================

library(rnassqs)
library(tidyverse)
library(magrittr)

path <- here::here()
path_code <- file.path(path, "code")
path_secrets <- file.path(path, "secrets")

path_secrets %>%
  file.path("nass_apikey_miriam.txt") %>%
  read_lines() %>%
  nassqs_auth()

# Example query (https://docs.ropensci.org/rnassqs/)
params <- list(commodity_desc = "CORN", year__GE = 2012, state_alpha = "VA")
d <- nassqs(params)
