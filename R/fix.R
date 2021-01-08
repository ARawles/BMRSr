#' Fixes parameters provided in the `build_x_call()` functions
#'
#' @param param list; named list with the parameter name and value (e.g. `list(settlement_date = "01/01/2020")`)
#' @param before function; function to fix the parameter. `param` will be passed as the first argument to this function.
#' Default NULL does nothing
#' @param ... additional arguments passed to the `before` function
#' @seealso fix_all_parameters
#' @return modified `param` object (if `before` isn't NULL)
fix_parameter <- function(param, before = NULL, ...) {
  if (is.null(names(param))) {
    stop("param must be a named list.")
  }
  if (is.null(before)) {
    before <- get_cleaning_function(names(param))
  }

  if (!is.null(before)) {
    param <- do.call(before, args = list(unlist(param), ...))
  } else {
    param <- unname(unlist(param))
  }
  param
}


#' Fixes multiple parameters
#'
#' Provided with a list of `build_..._call()` parameters, this function will fix each one and return a new list with the fixed parameters.
#' This is implemented by applying the `fix_parameter` function
#' @seealso fix_parameter
#' @param params list; list of the params. Should have a name and a value
#' @return list; list of the fixed parameters
fix_all_parameters <- function(params = list()) {
  param_values  <- purrr::map2(params, names(params),
                               ~ fix_parameter(rlang::list2(!!.y := .x)))
  names(param_values) <- unlist(purrr::map(names(param_values), ~change_parameter_name(.x)))
  param_values
}
