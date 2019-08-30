#' Parse the results of a call
#'
#' @param response A response object returned from the API request
#' @param format character string; format of the content of the response object; either "csv" or "xml"
#' @param clean_dates boolean; whether to clean date/time columns
#' @return A tibble if format == "csv", otherwise a list
#' @examples
#' tibble_example <- parse_response(
#' send_request(
#' build_call("TEMP", api_key = "12345", from_date = "01 Jun 2019", to_date = "10 Jun 2019", service_type = "xml")
#' ), "xml")
#' @export
parse_response <- function(response, format, clean_dates = TRUE){

  if (httr::status_code(response) != 200){
    warning(paste("Parsing unsuccessful: response code was", httr::status_code(response)))
    return()
  }

  parsed_content <- httr::content(response, "text")
  if (format == "csv"){

    if (methods::is(httr::content(response, "parsed"))[1] == "xml_document"){
      stop(paste("csv requested, xml returned. ", "Error code = ", xml2::as_list(xml2::read_xml(response))$response$responseMetadata$httpCode[[1]]))
    }

    if (response$data_item_type == "B Flow"){
      end_ind <- stringr::str_locate(parsed_content, "\\<EOF>")
      parsed_content <- substr(parsed_content, 1, end_ind-1)
      ret <- tibble::as_tibble(readr::read_delim(file = parsed_content, delim = ",", skip = 4, na = "NA"))
      if (clean_dates == TRUE){
        try({
          ret <- clean_date_columns(ret)}
          , TRUE)
      }
    }
    else if (response$data_item_type == "Legacy"){
      ret <- tibble::as_tibble(readr::read_delim(file = parsed_content, delim = ",", col_name = FALSE, na = "NA", skip = 1))
      ret <- droplevels(ret)
      ret <- ret[1:nrow(ret) - 1,]
      if (ncol(ret) != length(get_column_names(response$data_item))){
        warning("Number of columns in csv doesn't match expected; leaving names as default")
      }
      else {
        names(ret) <- get_column_names(response$data_item)
      }
      if (clean_dates == TRUE){
        try({
        ret <- clean_date_columns(ret)}
        , TRUE)
      }
    }}
  else if (format == "xml"){
    ret <- xml2::as_list(xml2::read_xml(response))
  }
  else {
    stop("Invalid format specified")
  }
  return(ret)
}
