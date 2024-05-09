#' @author Miles McBain
map_brisbane_occurrences <- function(
  spatial_occurrences,
  park_polygon,
  reference_point,
  study_date,
  map_style,
  spatial_temporal_hexbin_occurrence_counts
) {

  initial_bounds <-
    c(
      st_geometry(park_polygon),
      reference_point
    ) |>
    buffered_bbox(2000) |>
    st_transform(4326)

  temporal_occurrence_hex_groups <-
    group_split(
      spatial_temporal_hexbin_occurrence_counts |>
        arrange(event_year_bin),
      event_year_bin
    )

  hex_occurrences <-
    spatial_temporal_hexbin_occurrence_counts |>
    summarise(
      occurrence_count = sum(occurrence_count),
      .by = c(h3_index)
    )


  rdeck(
    initial_bounds = initial_bounds,
    map_style = map_style
  ) |>
    add_polygon_layer(
      name = "Banks St Reserve outline",
      data = park_polygon,
      get_polygon = geometry,
      filled = FALSE,
      get_line_color = "#6314ca",
      line_width_units = "pixels",
      get_line_width = 2
    ) |>
    add_heatmap_layer(
      name = "Dynamic heatmap",
      data = spatial_occurrences,
      get_position = geometry,
    ) |>
    add_point_cloud_layer(
      name = "Point cloud (blended)",
      data = spatial_occurrences,
      get_position = geometry,
      get_color = "#007a8a",
      blending_mode = "additive",
      point_size = 4,
      opacity = 0.7,
      visible = FALSE,
      tooltip = c("scientificName", "eventDate"),
      pickable = TRUE
    ) |>
    add_h3_hexagon_layer(
      name = "H3 hexbin (all years)",
      data = hex_occurrences,
      get_hexagon = h3_index,
      get_fill_color = scale_color_log(
        col = occurrence_count
      ),
      visible = FALSE,
      tooltip = "occurrence_count",
      pickable = TRUE,
      opacity = 0.7
    ) |>
    add_historic_occurrence_hex_layers(
      temporal_occurrence_hex_groups,
      max_count = max(spatial_temporal_hexbin_occurrence_counts$occurrence_count),
      visible = FALSE,
      tooltip = "occurrence_count",
      pickable = TRUE,
      opacity = 0.7
    )




}

#' A collection of hex occurrence layers based on a list of datasets
#' @param rdeck_map the rdeck object
#' @param temporal_occurrence_hex_groups a list of data frames containing the
#'   occurence counts and h3 indexes
#' @param ... additional parameters forwarded to hexagon layer
add_historic_occurrence_hex_layers <- function(
  rdeck_map,
  temporal_occurrence_hex_groups,
  max_count,
  ...
) {

  Reduce(
    \(rdeck_map, layer_data) {
      rdeck_map |>
        add_h3_hexagon_layer(
          name = glue("Occurrences in {first(layer_data$event_year_bin)}"),
          group_name = "Historic occurrences binned yearly",
          data = layer_data,
          get_hexagon = h3_index,
          get_fill_color = scale_color_log(
            col = occurrence_count,
            limits = c(1, max_count),
          ),
          ...
        )
    },
    temporal_occurrence_hex_groups,
    init = rdeck_map
  )
}

# TODO
# heatmap
# hex map all occurrences
