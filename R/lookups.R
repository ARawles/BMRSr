#' Get the cleaning function required for a parameter
#'
#' Before a parameter can be added to a request, it often needs to be cleaned. This function returns the appropriate function for a parameter.
#' Parameters can be supplied with their name used in the `build()` functions ("argument") or in the URL
#' @param parameter character; name of the parameter. Either the parameter as it's passed to the `build()` functions or the name of the parameter in the URL
#' depending on the value of `format`
#' @param format character; what format is `parameter` in? One of "argument" (default) or "url"
#' @return character; name of the cleaning function. If there is no associated cleaning function, then `NULL`
get_cleaning_function <- function(parameter, format = c("argument", "url")) {
  format <- match.arg(format)
  if (format == "url") {
    parameter <- change_parameter_name(parameter, from = "url", to = "argument")
  }
  ret <- dplyr::filter(parameter_clean_functions_map, .data$name == parameter)[["fn"]]
  if(length(ret) == 0 || is.na(ret)) {
    ret <- NULL
  }
  ret[[1]]
}

#' Convert a parameter name to a different format
#'
#' The names of the parameters that are used in the R functions do not perfectly correspond with the parameter name expected by the API. This
#' function converts an argument parameter name (e.g. `settlement_date`) to the URL argument name (e.g. `SettlementDate`) or the other way around
#' @param parameter character; name of the parameter provided to the relevant `build()` function
#' @param from character; one of "argument" or "url" depending on whether `parameter` is in the argument or URL format
#' @param to character; one of "argument" or "url"
#' @return character; name of the parameter used in the URL request or `build()` function. If no match is found, `character(0)`
change_parameter_name <- function(parameter, from = c("argument", "url"), to = c("url", "argument")) {
  from <- match.arg(from)
  to <- match.arg(to)
  from_col <- rlang::sym(paste0(from, "_name"))
  to_col <- rlang::sym(paste0(to, "_name"))
  results <- dplyr::filter(parameter_name_map,  {{ from_col }} == parameter)
  dplyr::pull(results, {{ to_col }})[[1]]
}
