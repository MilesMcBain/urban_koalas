#' Create a buffered bounding box polygon around geometry for setting map bounds
#'
#' @param sf_obj an sf object sf, sfc, sfg
#' @param buffer_metres the buffer to apply in meteres
#' @return a polygon sfc
#' @author Miles McBain
buffered_bbox <- function(
  sf_obj,
  buffer_metres = 2000,
  crs = "+proj=utm +zone=56 +south" # MGA Zone 56
  ) {
    sf_obj |>
    st_bbox() |>
    st_as_sfc() |>
    st_transform(crs = crs) |>
    st_buffer(buffer_metres)

}
