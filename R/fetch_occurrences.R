#' Fetch species location and metadata from Atlas of Living Australia with `{galah}`
#'
#' This site is useful for discovering field names:
#' https://dwc.tdwg.org/list/
#'
#'
#' @title fetch_occurrences
#' @param study_date the max date of observation, to help ensure reproducibility
#'  of outputs
#' @param study_species the output of `search_taxa()` on a species query
#' @return a tibble
#' @author Miles McBain
fetch_occurrences <- function(study_species, study_date) {
  occurences <-
    galah_call() |>
    identify(study_species) |>
    galah_filter(
      cl10929 == "GREATER BRISBANE"
      ) |>
    select(
      recordID,
      eventDate,
      scientificName,
      occurrenceStatus,
      geodeticDatum,
      decimalLatitude,
      decimalLongitude,
      dataResourceName,
      sex,
      reproductiveCondition,
      lifeStage,
      organismID
    ) |>
    atlas_occurrences()

  # for some reason eventDate <= study_date did not work in galah_filter
  # it gave a HTTP 400 bad request with auth failure.
  # Perhaps some fields are restricted for queries?
  # So instead we do filtering here.
  occurences |>
    filter(
      eventDate < study_date
    )
}
