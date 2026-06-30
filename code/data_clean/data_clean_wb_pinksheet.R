# ---------------------------------------------------------------------------- #
#'
#' Description: World Bank commodity price panel
#' Author: Miriam Gold
#' Date: 9 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

data_wb_world_price_annual <-
  path_data_raw %>%
  file.path("wb_pinksheet", "CMO-Historical-Data-Annual.xlsx") %>%
  read_xlsx(sheet = "Annual Prices (Nominal)", skip = 6) %>%
  mutate(source = "nominal")

data_wb_world_price_real <-
  path_data_raw %>%
  file.path("wb_pinksheet", "CMO-Historical-Data-Annual.xlsx") %>%
  read_xlsx(sheet = "Annual Prices (Real)", skip = 5) %>%
  mutate(source = "real")


data_wb_world_price_annual_clean <-
  data_wb_world_price_annual %>%
  bind_rows(data_wb_world_price_real) %>%
  clean_names() %>%
  rename(
    year = x1
  ) %>%
  filter(!is.na(year)) %>%
  pivot_longer(
    cols = !c(source, year),
    names_to = "commodity",
    values_to = "price"
  ) %>%
  mutate(
    commodity_harmonized = case_when(
      commodity == "palm_oil" ~ "palmoil",
      commodity == "soybeans" ~ "soybean",
      str_starts(commodity, "rice_") ~ "rice",
      str_starts(commodity, "wheat_") ~ "wheat",
      .default = commodity
    ),
    price = as.numeric(price)
  )

wb_ag_commodity_units <-
  data_wb_world_price_annual %>%
  slice(1) %>%
  clean_names() %>%
  select(!x1) %>%
  pivot_longer(
    cols = everything()
  ) %>%
  filter(
    str_detect(
      name,
      "cocoa|coffee_|tea_|coconut|groundnut|palm|soybean|barley|maize|sorghum|rice_|wheat|banana|orange|sugar_|tobacco|cotton|rubber"
    )
  )
# Write ==========================================

## World Bank price panel
data_wb_world_price_annual_clean %>%
  write_csv(
    file.path(
      path_data_clean,
      "wb_pinksheet",
      "wb_world_price_annual_clean.csv"
    )
  )

## Reference table for World Bank pinksheet commodities
wb_ag_commodity_units %>%
  write_csv(
    file.path(path_data_clean, "wb_pinksheet", "wb_ag_commodity_units.csv")
  )
