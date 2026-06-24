# ---------------------------------------------------------------------------- #
#'
#' Description: Generate and save plots of Potapov's Global Cropland Expansion
#' Author: Miriam Gold
#' Date: 24 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# Should we re-load the input datasets below? FALSE saves time if not needed
READ_DATA <- TRUE

# Read in data ====================================

if (READ_DATA) {
  potapov_cropland_by_country_clean <-
    path_data_clean %>%
    file.path("potapov", "potapov_cropland_by_country_clean.csv") %>%
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
gfc_fig_args <-
  tribble(
    ~plot_fn                    , ~filename                    , ~path    , ~width , ~height ,
    plot_potapov_africa_by_year , "potapov_africa_by_year.pdf" , path_fig ,      8 ,       6 ,
    plot_potapov_africa_diff    , "potapov_africa_diff.pdf"    , path_fig ,      8 ,       6
  )

## Generate and save plots
gfc_fig_args %>%
  #slice() %>%
  pwalk(ggsave_wrapper)
