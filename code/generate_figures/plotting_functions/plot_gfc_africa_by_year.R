plot_gfc_africa_by_year <- function() {
  most_loss_countries <-
    gfc_loss_by_year_africa %>%
    group_by(country_co) %>%
    summarize(total_loss = sum(loss_km)) %>%
    ungroup() %>%
    slice_max(order_by = total_loss, n = 7) %>%
    pull(country_co)

  gfc_loss_by_year_africa %>%
    mutate(
      loss_top_only = if_else(country_co %in% most_loss_countries, loss_km, NA),
      country_top_loss = if_else(
        country_co %in% most_loss_countries,
        country_co,
        "Other"
      )
    ) %>%
    group_by(country_co) %>%
    mutate(total_loss = sum(loss_km)) %>%
    ungroup() %>%
    mutate(
      country_top_loss = fct_reorder(country_top_loss, total_loss, .desc = TRUE)
    ) %>%
    ggplot(aes(x = year, group = country_co)) +
    geom_line(aes(y = loss_km), color = "grey50", alpha = 0.4) +
    geom_line(
      aes(y = loss_top_only, color = country_top_loss),
      linewidth = 1.5,
      alpha = 0.7
    ) +
    scale_color_brewer(
      palette = "Dark2",
      na.value = "black"
    ) +
    labs(
      x = NULL,
      y = "Forest loss (sq. km)",
      color = "Country"
    )
}
