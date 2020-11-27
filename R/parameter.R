as_parameter <- function(parameter) {
  param <- list(
    argument_name = parameter,
    url_name = get_url_parameter_name(parameter),
    clean_function = get_clean_function(parameter)
  )
  class(param) <- "parameter"
  param
}
