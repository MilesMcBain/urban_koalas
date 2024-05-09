#' @author Miles McBain
plot_banks_st_occurrences <- function(
      banks_st_reserve_poly,
      spatial_occurrences,
      date_from,
      track,
      map_style
) {

  map_area <-
    banks_st_reserve_poly |>
    buffered_bbox(200)

  map_data <-
    spatial_occurrences |>
    filter(
      eventDate >= date_from
    ) |>
    st_intersection(
      banks_st_reserve_poly
    ) |>
    st_drop_geometry() |>
    summarise(
      `times observed` = n(),
      .by = h3_hex_11
    ) |>
    mutate(
      hexagon = cell_to_polygon(h3_hex_11)
    ) |>
    st_as_sf()

  ggplot() +
    layer_mapbox(
      area = map_area,
      map_style = map_style,
      scale_ratio = 0.4
    ) +
    geom_sf(
      data = track,
      colour = "#ffc3ff",
      linewidth = 1.5
    ) +
    geom_sf(
      data = map_data,
      aes(fill = `times observed`),
      alpha = 0.7
    ) +
    scale_fill_viridis_b() +
    inset_legend_light() +
    theme_cropped_map() +
    annotation_north_arrow(location = "tl")


}
