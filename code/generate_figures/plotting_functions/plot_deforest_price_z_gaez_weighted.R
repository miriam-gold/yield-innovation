plot_deforest_price_z_gaez_weighted <- function() {
  deforest_price_panel <-
    price_yl_weighted_panel %>%
    left_join(
      gfc_loss_by_year_africa %>% filter(!country_co %in% c("SP", "SU", "UU")),
      by = join_by(country_co, year)
    ) %>%
    filter(!is.na(loss_ha))

  binsreg_base_plot <-
    binsreg(
      deforest_price_panel$loss_ha,
      deforest_price_panel$price_z_yl_weighted,
      printplot = FALSE,
      noplot = TRUE
    )
  binsreg_base_plot$data.plot$`Group Full Sample`$data.dots %>%
    ggplot(aes(x, fit)) +
    geom_point(size = 2, color = "#1a476f") +
    labs(
      y = "Forest loss (thousand hectares)",
      x = "GAEZ-weighted world price (z-score)"
    ) +
    coord_fixed(ratio = 2e-05) +
    scale_y_continuous(
      labels = scales::label_comma(scale = 1e-03)
    )
}
