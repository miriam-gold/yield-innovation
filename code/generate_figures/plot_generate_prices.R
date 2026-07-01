# ---------------------------------------------------------------------------- #
#'
#' Description: Generate and save plots of Nominal Rate of Assistance and WB pinksheet
#' Author: Miriam Gold
#' Date: 9 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Should we re-load the input datasets below? FALSE saves time if not needed
READ_DATA <- TRUE

# Read in data ====================================

if (READ_DATA) {
  distortions_world_price_merged <-
    path_data_clean %>%
    file.path("wb_distortions", "distortions_world_price_merged.csv") %>%
    read_csv()

  ## Pink sheet world prices
  wb_world_price_annual <-
    path_data_clean %>%
    file.path("wb_pinksheet", 'wb_world_price_annual_clean.csv') %>%
    read_csv()

  gaez_yield_by_country <-
    path_drive %>%
    file.path("gaez_avg_yield_by_country.csv") %>%
    read_csv()

  # World prices, weighted by average GAEZ suitability
  price_yl_weighted_panel <-
    path_data_clean %>%
    file.path("wb_pinksheet", "wb_world_price_yl_weighted.csv") %>%
    read_csv()
}

# Plot generation ========================================

## Make sure plotting functions are up-to-date ====
path_code_generate_figures %>%
  file.path("plotting_functions") %>%
  source_dir()

theme_set(
  theme_bw() +
    theme(
      strip.background = element_blank(),
      text = element_text(family = "cmss", size = 16)
    )
)

## Collect figure generation elements, where each row is a figure and each
## column is an argument that will be passed to ggsave_wrapper()
nra_fig_args <-
  tribble(
    ~plot_fn                                     , ~filename                                  , ~path    , ~width , ~height ,
    plot_world_price_nra_by_country("india")     , "world_price_nra_by_country_india.pdf"     , path_fig ,      7 ,       6 ,
    plot_world_price_nra_by_country("us")        , "world_price_nra_by_country_us.pdf"        , path_fig ,      7 ,       6 ,
    plot_world_price_nra_by_country("brazil")    , "world_price_nra_by_country_brazil.pdf"    , path_fig ,      7 ,       6 ,
    plot_world_price_nra_by_country("indonesia") , "world_price_nra_by_country_indonesia.pdf" , path_fig ,      7 ,       6 ,
    plot_world_price_nra_by_country("china")     , "world_price_nra_by_country_china.pdf"     , path_fig ,      7 ,       6 ,
    plot_biofuel_crop_prices                     , "biofuel_crop_prices.pdf"                  , path_fig ,      8 ,       6 ,
    plot_gaez_attain_yl_by_country               , "gaez_attain_yl_by_country.pdf"            , path_fig ,      8 ,       6 ,
    plot_price_z_gaez_weighted_by_country        , "price_z_gaez_weighted_by_country.pdf"     , path_fig ,      8 ,       6
  )

## Generate and save plots
nra_fig_args %>%
  #slice() %>%
  pwalk(ggsave_wrapper)
