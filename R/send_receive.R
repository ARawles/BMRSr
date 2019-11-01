#' Send an API request (basically a wrapper to httr:GET that adds a marker for the data item)
#'
#' @param request list; a named list with at least a url to be sent and the data item contained within (most easily generated from build_call())
#' @param config_options list; a named list of config options to be passed to httr::GET
#' @return A response() object with an added data_item attribute
#' @examples
#' send_request(
#' build_call(data_item = "TEMP", from_date = "01 Jun 2019", to_date = "10 Jun 2019", api_key = "test")
#' )
#' @export
send_request <- function(request, config_options = list()) {
  response <- httr::GET(request$url, do.call(httr::config, config_options))
  response$data_item_type <- get_data_item_type(request$data_item)
  response$data_item <- request$data_item
  response$service_type <- request$service_type
  return(response)
}






