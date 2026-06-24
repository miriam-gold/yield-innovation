plot_potapov_africa_by_year <- function() {
  most_crop_countries <-
    potapov_cropland_by_country_clean %>%
    group_by(country_co) %>%
    summarize(total_crop = sum(cropland_ha)) %>%
    ungroup() %>%
    slice_max(order_by = total_crop, n = 7) %>%
    pull(country_co)

  potapov_cropland_by_country_clean %>%
    mutate(
      crop_top_only = if_else(
        country_co %in% most_crop_countries,
        cropland_ha,
        NA
      ),
      country_top_crop = if_else(
        country_co %in% most_crop_countries,
        country_co,
        "Other"
      )
    ) %>%
    group_by(country_co) %>%
    mutate(total_crop = sum(cropland_ha)) %>%
    ungroup() %>%
    mutate(
      country_top_crop = fct_reorder(country_top_crop, total_crop, .desc = TRUE)
    ) %>%
    ggplot(aes(year, cropland_ha, group = country_co)) +
    geom_line(aes(y = cropland_ha), color = "grey50", alpha = 0.4) +
    geom_line(
      aes(y = crop_top_only, color = country_top_crop),
      linewidth = 1.5,
      alpha = 0.7
    ) +
    geom_point(
      aes(y = crop_top_only, color = country_top_crop)
    ) +
    scale_color_brewer(
      palette = "Dark2",
      na.value = "black"
    ) +
    scale_y_continuous(
      labels = scales::label_comma(scale = 1e-06)
    ) +
    scale_x_continuous(
      breaks = c(2003, 2007, 2011, 2015, 2019)
    ) +
    labs(
      x = NULL,
      y = "Cropland (million ha)",
      color = "Country"
    )
}
