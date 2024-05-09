#' Make a ggplot of a park polygon
#'
#' @return a ggassembly
#' @author Miles McBain
plot_park_poly <- function(
    park_polygon,
    reference_point,
    map_style) {

  area <-
    c(
      st_geometry(park_polygon),
      reference_point
    ) |>
    buffered_bbox(2000)


  ggplot() +
    layer_mapbox(
      area,
      map_style = map_style,
      scale_ratio = 0.3
    ) +
    geom_sf(
      data = park_polygon,
      colour = "#6314ca",
      fill = NA,
      linewidth = 2
    ) +
    theme_cropped_map() +
    annotation_north_arrow(location = "tl")
}


