## Load your packages, e.g. library(targets).
source("./packages.R")

## Set options
galah_config(atlas = "ALA",
             email = Sys.getenv("ALA_EMAIL"))
# use env var to avoid credential leakage

# load sources in ./R
tar_source()

tar_plan(

  # Species data
  study_species = search_taxa("Phascolarctos cinereus"),
  study_date = ymd("2024-05-08"),
  tar_target(
     occurrences,
     fetch_occurences(
       study_species,
       study_date
     )
  ),

  # Assorted extra geospatial datasets
  # - park boundaries
  # - plotting reference points
  tar_file(
    alexander_clark_park_boundary,
    "data/alexander_clark_park.geojson"
  ),
  tar_file(
    banks_st_reserve_boundary,
    "data/banks_st_reserve.geojson"
  ),
  tar_target(
    alexander_clark_park_poly,
    read_sf(alexander_clark_park_boundary)
  ),
  tar_target(
    banks_st_reserve_poly,
    read_sf(banks_st_reserve_boundary)
  ),
  tar_target(
    brisbane_reference_point,
    brisbane()
  ),
  tar_target(
    logan_reference_point,
    logan()
  ),
  tar_target(
    spatial_occurrences,
    create_spatial_occurrences(
      occurrences
    )
  ),

  # Visualisations
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
    rd_banks_st,
    map_park_poly(
      park_polygon = banks_st_reserve_poly,
      reference_point = NULL,
      map_style = base_map_style
    )
  ),
 tar_render(report, "doc/report.Rmd")

)
