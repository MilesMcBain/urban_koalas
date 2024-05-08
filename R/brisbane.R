#' Coordinates for Brisbande CBD-ish
#' @author Miles McBain
brisbane <- function() {
  st_point(c(
    153.02862730031188,
    -27.47536871974505
  )) |>
    st_sfc(crs = 4326)
}
