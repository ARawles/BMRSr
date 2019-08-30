#' Create an API call, send the request and retrieve the results, and parse them
#'
#' @inheritParams build_call
#' @param get_params list; parameters to be passed to the send_request function (which will pass those parameters to httr::get)
#' @param parse boolean; whether the results should be parsed or returned as a response() object
#' @param clean_dates boolean; whether the csv response columns should be cleaned (reformatted to be correct date/time/datetime)
#' @return If parse == TRUE, a tibble if service_type = "csv", otherwise a list. If parse == FALSE, a response() object is returned
#' @examples
#' \donttest{
#' full_request(data_item = "B1730", api_key = "12345",
#' settlement_date = "14-12-2016", parse = TRUE, service_type = "xml")
#' }
#' @export

full_request <- function(..., get_params = list(), parse = TRUE, clean_dates = TRUE){
  request <- do.call(build_call, args = list(...))
  results <- send_request(request, get_params)
  if (parse == TRUE){
    ret <- parse_response(results, format = request$service_type, clean_dates = clean_dates)
  } else {
    ret <- results
  }
  return(ret)
}
