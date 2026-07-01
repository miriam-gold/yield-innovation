plot_price_z_gaez_weighted_by_country <- function() {
  price_yl_weighted_panel %>%
    mutate(year_jitter = year + runif(nrow(.), min = -0.5, max = 0.5)) %>%
    ggplot(aes(year_jitter, price_z_yl_weighted, group = country_na)) +
    geom_point(alpha = 0.3) +
    geom_line(alpha = 0.25, color = "grey45", linewidth = 0.4) +
    labs(
      y = NULL,
      x = "Year (jittered)",
      subtitle = "GAEZ-weighted world price (z-score)",
      caption = "Crops include soybean, maize, and palm oil"
    ) +
    theme(
      legend.position = "none"
    )
}
