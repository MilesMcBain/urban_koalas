#' Make a h3 hex bin dataset also binned by event years
#' @author Miles McBain
make_spatial_temporal_hex_counts <- function(
  spatial_occurrences,
  h3_index_col
) {

  temporal_bin_occurence <-
    spatial_occurrences |>
    st_drop_geometry() |>
    mutate(
      event_year = year(eventDate)
    ) |>
    filter(
      event_year >= 2012
    ) |>
    mutate(
      event_year_bin = santoku::chop(
        event_year,
        breaks = seq(2012, 2024, by = 4)
      ),
      h3_index = {{ h3_index_col }}
    ) |>
    dplyr::summarise(
      occurrence_count = n(),
      .by = c(h3_index, event_year_bin)
    )

  temporal_bin_occurence
}
