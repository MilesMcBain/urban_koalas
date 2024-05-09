#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param spatial_occurrences
#' @param banks_st_reserve_poly
#' @return
#' @author Miles McBain
#' @export
plot_banks_st_observation_time_series <- function(
  spatial_occurrences,
  banks_st_reserve_poly,
  study_date,
  study_species
) {

  occurrence_counts <-
    spatial_occurrences |>
    st_intersection(
      banks_st_reserve_poly
    ) |>
    st_drop_geometry() |>
    mutate(
      event_year = year(eventDate)
    ) |>
    summarise(
      num_occurrences = n(),
      .by = event_year
    )

    occurrence_counts |>
    ggplot(aes(x = event_year, y = num_occurrences)) +
    geom_col() +
    theme_light() +
    labs(
      title = glue("Yearly count of observations of {study_species$scientific_name}"),
      subtitle = "Within Banks St Reserve Brisbane"
    )

}
