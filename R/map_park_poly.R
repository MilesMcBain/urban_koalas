#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author Miles McBain
#' @export
map_park_poly <- function(
    park_polygon = banks_st_reserve_boundary,
    reference_point = NULL,
    map_style) {

    poly_data <-
      st_sf(park_polygon)

    rdeck(
      initial_bounds = st_bbox(poly_data),
      map_style = map_style
    ) |>
    add_polygon_layer(
      data = poly_data,
      get_polygon = geometry,
      filled = FALSE,
      get_line_color = "#6314ca"
    )


}
