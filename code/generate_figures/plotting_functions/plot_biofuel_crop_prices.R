plot_biofuel_crop_prices <- function() {
  wb_world_price_annual %>%
    filter(commodity_harmonized %in% biofuel_crops, source == "real") %>%
    group_by(commodity_harmonized) %>%
    mutate(
      price_z_score = (price - mean(price)) / sd(price)
    ) %>%
    ggplot(aes(
      year,
      price_z_score,
      group = commodity_harmonized,
      color = commodity_harmonized
    )) +
    geom_line(alpha = 0.6, linewidth = 1.2) +
    geom_hline(yintercept = 0) +
    scale_color_stata(scheme = "s1color") +
    labs(
      y = "Real world price (z-score)",
      x = "Year",
      color = "Crop"
    ) +
    theme_bw()
}
