plot_nass_available_county_stats <- function(commodity) {
  commodity <- str_to_upper(commodity)

  data_available_stats <-
    data_nass_census_county_corn_soybeans %>%
    filter(
      county_name != ""
    ) %>%
    count(state_alpha, year, commodity_desc, statisticcat_desc) %>%
    mutate(
      statisticcat_desc = str_to_title(statisticcat_desc)
    )

  function() {
    data_available_stats %>%
      filter(commodity_desc == commodity) %>%

      ggplot(aes(year, statisticcat_desc)) +
      geom_tile(color = "white", linewidth = 1) +
      facet_wrap(~state_alpha) +
      #coord_fixed() +
      theme_bw() +
      labs(
        y = NULL,
        x = "Census Year",
        title = paste0(
          "Stats available at county level: ",
          str_to_lower(commodity)
        )
      ) +
      theme(
        text = element_text(family = "cmr", size = 16),
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 30, hjust = 1)
      )
  }
}
