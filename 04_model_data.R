##### Libraries #####
library(conflicted)
library(dplyr)
library(randomForest)
library(rsample)
library(tidyr)
library(tibble)
library(sf)
library(purrr)

conflicts_prefer(
  tidyr::unnest
)

occurrence_training_data <-
  readRDS("data/wrangled_occurences_weather_data.Rds") |>
  st_drop_geometry() |>
  select(
    scientificName,
    decimalLatitude,
    decimalLongitude,
    hour,
    month,
    air_tmin,
    air_tmax,
    vp
  ) |>
  mutate(
    scientificName = as.factor(scientificName)
  )

# TODO test/train split

N_CV_FOLDS <- 2
set.seed(2048)
occurrence_cv_splits <-
  vfold_cv(occurrence_training_data, v = 5, repeats = 1)

split <- occurrence_cv_splits$splits[[1]]

mtry_candidates <- c(1, 2, 3)
num_trees_candidates <- c(200, 500, 100)

training_grid <-
  expand.grid(
    fold_id = occurrence_cv_splits$id,
    mtry = mtry_candidates,
    num_trees = num_trees_candidates
  ) |>
  as_tibble() |>
  left_join(
    occurrence_cv_splits,
    by = c(fold_id = "id")
  )

fit_fold_calc_results <- function(split, num_trees, mtry) {
  model <-
    randomForest(
      scientificName ~ .,
      data = training(split),
      mtry = mtry,
      ntree = num_trees
    )
  test_set <-
    testing(split) |>
    mutate(
      is_moluccus = if_else(
        scientificName == "Threskiornis moluccus",
        1,
        0
      )
    )
  test_set$predicted_prob_is_moluccus <-
    predict(
      model,
      newdata = test_set,
      type = "prob"
    ) |>
    _[, 1] # We get a matrix with 2 columns, 1 per class. Threskiornis moluccus is column 1.

  roc_object <- roc(
    test_set$is_moluccus,
    test_set$predicted_prob_is_moluccus
  )

  # use auc and accuracy as our summary statistics
  data.frame(
      auc = auc(roc_object) |> as.numeric(),
      accuracy = sum(test_set$is_moluccus > 0.5 & test_set$is_moluccus == 1) / nrow(test_set)
  )
}

# Can take a while on a single core
training_results <-
  training_grid |>
  mutate(
    pmap(
      .l = list(
        training_grid$splits,
        training_grid$num_trees,
        training_grid$mtry
      ),
      .f = fit_fold_calc_results
    ) |>
    bind_rows()
    # by returning a dataframe inside mutate, the resulting columns are appended to training_grid
  )

summarised_training_results <-
  training_results |>
  summarise(
    mean_auc = mean(auc),
    mean_accuracy = mean(accuracy),
    .by = c(mtry, num_trees)
  ) |>
  arrange(-mean_auc)

# Our best model by AUC is not row 1
best_model <-
  randomForest(

  )

function() {
}
