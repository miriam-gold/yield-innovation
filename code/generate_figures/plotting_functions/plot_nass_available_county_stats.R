plot_nass_available_county_stats <- function(commodity) {
  commodity <- str_to_upper(commodity)

  data_available_stats <-
    data_nass_census_county_corn_soybeans %>%
    filter(
      county_name != ""
    ) %>%
    mutate(
      has_value = !is.na(Value)
    ) %>%
    group_by(state_alpha, year, commodity_desc, statisticcat_desc) %>%
    summarise(Records = sum(has_value)) %>%
    ungroup() %>%
    mutate(
      statisticcat_desc = str_to_title(statisticcat_desc)
    ) %>%
    filter(Records != 0)

  function() {
    data_available_stats %>%
      filter(commodity_desc == commodity) %>%

      ggplot(aes(year, statisticcat_desc, fill = Records)) +
      geom_tile(color = "white", linewidth = 1) +
      facet_wrap(~state_alpha) +
      scale_x_continuous(breaks = seq(1997, 2022, by = 5)) +
      scale_fill_viridis_c() +
      labs(
        y = NULL,
        x = "Census Year",
        title = paste0(
          "Stats available at county level: ",
          str_to_lower(commodity)
        )
      ) +
      theme_bw() +
      theme(
        text = element_text(family = "cmr", size = 16),
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 60, hjust = 1, size = 8)
      )
  }
}
