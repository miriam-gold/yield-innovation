# ---------------------------------------------------------------------------- #
#'
#' Description: Data importing, cleaning, and analysis for price, yield, and innovation paper
#' Author: Miriam Gold
#' Date: 2 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Set up ==========================================

rm(list = ls())

SOURCE_SCRIPTS <- FALSE

## Load packages ====
library(tidyverse)
library(dplyr)
library(magrittr)
library(showtext)
library(glue)
library(fs)
library(janitor)
library(lubridate)
library(readxl)

library(ggthemes)
library(binsreg)

library(rnassqs)
library(FAOSTAT)
library(GAEZr)

library(fixest)

library(raster)
library(terra)
library(sf)
library(tidyterra)


## File system paths ====

path <- here::here()
path_data <- "~/Dropbox/Innovation/data"
path_drive <- "~/Google Drive/My Drive/yield-innovation"

path_code <- file.path(path, "code")
path_secrets <- file.path(path, "secrets")

path_data_raw <- file.path(path_data, "raw")
path_data_clean <- file.path(path_data, "clean")

path_data_raw_gaez <- file.path(path_data_raw, "gaez")
path_data_raw_geo <- file.path(path_data_raw, "geography")
path_data_raw_gfc <- file.path(path_data_raw, "gfc")
path_data_raw_gfc_lossyear <- file.path(path_data_raw_gfc, "lossyear")

path_output <- file.path(path, "output")
path_fig <- file.path(path_output, "figures")

path_code_functions <- file.path(path_code, "functions")
path_code_generate_figures <- file.path(path_code, "generate_figures")
path_code_data_clean <- file.path(path_code, "data_clean")

## Source general use custom functions
path_code_functions %>%
  dir_ls() %>%
  walk(source)

# Run entire pipeline =====================

if (SOURCE_SCRIPTS) {
  path_code_data_clean %>%
    file.path("_master_data_clean.R") %>%
    source()

  path_code_generate_figures %>%
    file.path("_master_generate_figures.R") %>%
    source()
}
