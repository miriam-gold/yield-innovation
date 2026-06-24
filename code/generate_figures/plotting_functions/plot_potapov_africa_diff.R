plot_potapov_africa_diff <- function() {
  potapov_cropland_diff <-
    potapov_cropland_by_country_clean %>%
    group_by(country_co) %>%
    arrange(country_co, year) %>%
    mutate(
      cropland_diff_ha = cropland_ha - lag(cropland_ha),
      cropland_diff_ha = if_else(year == 2003L, 0, cropland_diff_ha)
    ) %>%
    ungroup()

  potapov_cropland_diff %>%
    ggplot(aes(year, cropland_diff_ha, group = country_co)) +
    geom_line(alpha = 0.6, color = "grey30", linewidth = 1) +
    geom_hline(yintercept = 0, color = "darkred", linetype = 2) +
    scale_y_continuous(
      labels = scales::label_comma(scale = 1e-06)
    ) +
    scale_x_continuous(
      breaks = c(2003, 2007, 2011, 2015, 2019)
    ) +
    labs(
      y = "Cropland difference (million ha)",
      x = NULL
    )
}
