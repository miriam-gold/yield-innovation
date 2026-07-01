plot_gaez_attain_yl_by_country <- function() {
  gaez_country_crop <-
    gaez_yield_by_country %>%
    janitor::clean_names() %>%
    select(starts_with("x"), country_co, country_na) %>%
    rename_with(~ str_remove(.x, "x\\d_yl_hr_")) %>%
    pivot_longer(
      cols = !starts_with("country_"),
      names_to = "crop",
      values_to = "mean_attain_yl"
    ) %>%
    filter(country_co != "UU", crop %in% c("mze", "soy", "olp")) %>%
    mutate(
      crop_name = case_when(
        crop == "mze" ~ "Maize",
        crop == "olp" ~ "Oilpalm",
        crop == "soy" ~ "Soybean"
      )
    )

  gaez_country_crop %>%
    group_by(crop) %>%
    slice_max(order_by = mean_attain_yl, n = 5) %>%
    ungroup() %>%
    ggplot(aes(mean_attain_yl, country_na)) +
    geom_bar(stat = "identity", width = 0.6, fill = "#1a476f") +
    facet_wrap(~crop_name, scales = "free", nrow = 2) +
    labs(
      y = NULL,
      x = "Mean attainable yield (kg/ha)",
      subtitle = "Top 5 countries in each crop"
    )
}
