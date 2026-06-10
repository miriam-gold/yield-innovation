SOURCE_SCRIPTS <- FALSE

## Source block-specific custom functions =======

path_code_data_clean %>%
  file.path("functions") %>%
  source_dir()

# Source individual scripts =====================

if (SOURCE_SCRIPTS) {
  ## Import NASS Ag Census data via API ==================
  path_code_data_clean %>%
    file.path("data_import_nass_census.R") %>%
    source()
}

# Analysis ========================================

# Output ==========================================
