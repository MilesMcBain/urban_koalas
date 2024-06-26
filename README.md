# Galah Vis

This is a demonstration of using R and data via the `{galah}` R package to make species distribution maps backed by a reproducible pipeline built using `{targets}`.

A number of techniques are showcased:
  - Static maps using `{ggplot2}` see `R/plot_banks_st_occurences.R`
    - Many of the packages in this workflow were built out by myself and ex-colleagues at QFES
  - Interactive mapping using a variety of layer types using the `{rdeck}` bindings to Uber's deck.gl framework. See `R/map_brisbane_occurences.R`
    - Built by my ex-colleague @anthonynorth
  - Using the h3 spatial index system to create aggregations for visualisation. See:
    - `R/create_spatial_occurences.R`
    - `R/R/make_spatial_temporal_hex_counts.R`

The root of the project is the `_targets.R` file that defines the pipeline plan.

With the working dir set to the repository root, the  `targets::tar_make()` command will build the pipeline, and render the main report output: `docs/index.html`

The R package dependencies are described in the `renv.lock` file which can be used to reproduce the project package environment with `renv::restore()` if desired.

# Output

The report output by this pipeline is served from this repository here: https://milesmcbain.github.io/urban_koalas/


# External Dependencies

You will need the following environment variables set:
  - `ALA_EMAIL` and email address registered with the _Atlas of Living Australa_
  - `MAPBOX_API_KEY` an API key from mapbox for fetching basemap tiles for interactive mapping
