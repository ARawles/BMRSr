#' Create an API call, send the request and retrieve the results, and parse them
#'
#' @inheritParams build_call
#' @param get_params list; parameters to be passed to the send_request function (which will pass those parameters to httr::get)
#' @param parse boolean; whether the results should be parsed or returned as a response() object
#' @return If parse == TRUE: A tibble if service_type = "csv", otherwise a list. If parse == FALSE: a response() object is returned
#' @examples
#' full_request(data_item = "B1730", api_key = "12345",
#' settlement_date = "14-12-2016", parse = TRUE)
#' @export

full_request <- function(..., get_params = list(), parse = TRUE){
  request <- do.call(build_call, args = list(...))
  results <- send_request(request$url, request$data_item, get_params)
  if (parse == TRUE){
    ret <- parse_response(results, format = request$service_type)
  } else {
    ret <- results
  }
  return(ret)
}
