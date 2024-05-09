#' make occurence data spatial
#'
#' Add:
#'   - sf point geomety
#'   - uber h3 hex indices
#'
#' For h3 here is a handy table of size information:
#' https://h3geo.org/docs/core-library/restable/
#'
#' @param occurences the spatial data returned from `galah::atlas_ocurrences()`
#' @param h3_hex_resolutions a vector of uber h3 hex resolutions to create columns for.
#'   Each is named h3_hex_<resolution>.
#' @return an sf data frame
#' @author Miles McBain
create_spatial_occurrences <- function(
  occurrences,
  h3_hex_resolutions
) {
  occurences_sf <-
    occurrences |>
    st_as_sf(
      coords = c(
        "decimalLongitude",
        "decimalLatitude"
      ),
      crs = 4326
    ) |>
    mutate(
      compute_h3_indices_at_resolutions(h3_hex_resolutions, geometry)
    )


  occurences_sf
}

compute_h3_indices_at_resolutions <- function(
  resolutions,
  point_geometry
) {
  lapply(
    resolutions,
    \(res, geometry) {
      point_to_cell(geometry, res = res)
    },
    point_geometry
  ) |>
    setNames(paste0("h3_hex_", resolutions)) |>
    as.data.frame()
}
