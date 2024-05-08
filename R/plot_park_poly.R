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
    st_bbox() |>
    st_as_sfc() |>
    st_transform(crs = "+proj=utm +zone=56 +south") |> # MGA Zone 56
    st_buffer(2000) # for spatital context


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
    theme_cropped_map()
}
