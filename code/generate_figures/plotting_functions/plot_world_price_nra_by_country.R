plot_world_price_nra_by_country <- function(.country) {
  country_title <- switch(.country, us = "USA", str_to_title(.country))
  distortions_world_price_country <-
    distortions_world_price_merged %>%
    filter(country == .country) %>%
    mutate(commodity_harmonized = str_to_title(commodity_harmonized))

  function() {
    distortions_world_price_country %>%
      ggplot(aes(price_nom_ln, nra)) +
      geom_point(color = "#90353b", size = 1.2, alpha = 0.8) +
      geom_smooth(
        se = FALSE,
        method = "lm",
        color = "#1a476f",
        linewidth = 1,
        alpha = 0.5
      ) +
      geom_hline(yintercept = 0) +
      labs(
        x = "Log World Price (nominal)",
        y = "Nominal Rate of Assistance",
        subtitle = country_title
      ) +
      facet_wrap(~commodity_harmonized, scales = "free_x")
  }
}
