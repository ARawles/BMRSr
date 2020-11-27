as_data_item <- function(data_item) {
  di <- list(
    name = data_item,
    type = get_data_item_type(data_item),
    params = get_parameters(data_item)
  )

  class(di) <- "data_item"
  di
}

