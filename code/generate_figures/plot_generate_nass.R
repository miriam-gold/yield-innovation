# ---------------------------------------------------------------------------- #
#'
#' Description: Generate and save plots of USDA NASS data
#' Author: Miriam Gold
#' Date: 2 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Should we re-load the input datasets below? FALSE saves time if not needed
READ_DATA <- FALSE

# Read in data ====================================

if (READ_DATA) {
  data_nass_census_county_corn_soybeans <-
    path_data_raw %>%
    file.path("nass_census") %>%
    fs::dir_ls() %>%
    map(read_csv) %>%
    map(~ select(.x, !c(state_ansi, state_fips_code))) %>%
    list_rbind()
}

# Plot generation ========================================

## Make sure plotting functions are up-to-date ====
path_code_generate_figures %>%
  file.path("plotting_functions") %>%
  source_dir()

## Collect figure generation elements, where each row is a figure and each
## column is an argument that will be passed to ggsave_wrapper()
nass_fig_args <-
  tribble(
    ~plot_fn                                     , ~filename                                  , ~path    , ~width , ~height ,
    plot_nass_available_county_stats("corn")     , "nass_available_county_stats_corn.pdf"     , path_fig ,     10 ,       7 ,
    plot_nass_available_county_stats("soybeans") , "nass_available_county_stats_soybeans.pdf" , path_fig ,     10 ,       7
  )

## Generate and save plots
nass_fig_args %>%
  #slice() %>%
  pwalk(ggsave_wrapper)
