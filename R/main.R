#' Create an API call, send the request and retrieve the results, and parse them
#'
#' @inheritParams build_call
#' @param get_params A list of parameters to be passed to the send_request function (which will pass those parameters to httr::get)
#' @return If parse == TRUE: A tibble if service_type = "csv", otherwise a list \n If parse == FALSE: a response() object
#'
#' @examples
#' full_request(data_item = "B1730", api_key = "12345", settlement_date = "14-12-2016", parse = TRUE)
#' @export

full_request <- function(..., get_params = list(), parse = TRUE){
  d_item <- list(...)[['data_item']]
  if (is.null(list(...)[['service_type']])){
    s_type = "csv"
  }
  else {
    s_type <- list(...)[['service_type']]
  }
  url <- do.call(build_call, args = list(...))
  results <- send_request(url, d_item, get_params)
  if (parse == TRUE){
    ret <- parse_response(results, format = s_type)
  } else {
    ret <- results
  }
  return(ret)
}
