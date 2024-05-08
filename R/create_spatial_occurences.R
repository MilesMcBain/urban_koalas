#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param occurences
#' @return
#' @author Miles McBain
#' @export
create_spatial_occurrences <- function(occurences) {

  occurences_sf <-
    occurences |>
    st_as_sf(
      coords = c(
        "decimalLongitude",
        "decimalLatitude"
      ),
      crs = 4326
    )

  occurences_sf
}
