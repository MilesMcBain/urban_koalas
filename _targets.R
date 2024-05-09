## Load your packages, e.g. library(targets).
source("./packages.R")

## Set options
options(
)
galah_config(
  atlas = "ALA",
  email = Sys.getenv("ALA_EMAIL")
)
# use env var to avoid credential leakage

# load sources in ./R
tar_source()

tar_plan(
  # Species data
  study_species = search_taxa("Phascolarctos cinereus"),
  study_date = ymd("2024-05-08"),
  tar_target(
    occurrences,
    fetch_occurrences(
      study_species,
      study_date
    )
  ),

  # Assorted extra geospatial datasets
  # - park boundaries
  # - plotting reference points
  # - trail course
  tar_file(
    banks_st_reserve_boundary,
    "data/banks_st_reserve.geojson"
  ),
  tar_file(
    banks_st_run,
    "data/run_track.geojson"
  ),
  tar_target(
    banks_st_reserve_poly,
    read_sf(banks_st_reserve_boundary)
  ),
  tar_target(
    banks_st_run_linestring,
    read_sf(banks_st_run)
  ),
  tar_target(
    brisbane_reference_point,
    brisbane()
  ),
  tar_target(
    spatial_occurrences,
    create_spatial_occurrences(
      occurrences,
      h3_hex_resolutions = c(8, 9, 10, 11)
    )
  ),

  # Visualisations
  ## ggplots
  base_map_style = stylebox::mapbox_gallery_frank(),
  tar_target(
    gg_banks_st,
    plot_park_poly(
      park_polygon = banks_st_reserve_poly,
      reference_point = brisbane_reference_point,
      map_style = base_map_style
    )
  ),
  tar_target(
    gg_banks_run_and_occurrences_6yr,
    plot_banks_st_occurrences(
      banks_st_reserve_poly,
      spatial_occurrences,
      date_from = study_date - years(6),
      track = banks_st_run_linestring,
      map_style = base_map_style
    )
  ),
  tar_target(
    gg_bank_st_observation_time_series,
    plot_banks_st_observation_time_series(
      spatial_occurrences,
      banks_st_reserve_poly,
      study_date,
      study_species
    )
  ),

  ## Interfactive maps
  ### Data
  tar_target(
    spatial_temporal_hexbin_occurrence_counts,
    make_spatial_temporal_hex_counts(
      spatial_occurrences,
      h3_index_col = h3_hex_9
    )
  ),
  ### Map
  tar_target(
    rd_brisbane_occurrences,
    map_brisbane_occurrences(
      spatial_occurrences,
      park_polygon = banks_st_reserve_poly,
      reference_point = brisbane_reference_point,
      map_style = base_map_style,
      study_date,
      spatial_temporal_hexbin_occurrence_counts
    )
  ),
  tar_render(report, "docs/index.Rmd")
)
