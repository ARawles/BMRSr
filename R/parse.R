#' Parse the results of a call
#'
#' @param response A response object returned from the API request
#' @param format character string; NULL to use response service type or "csv" or "xml" to force that format
#' @param clean_dates boolean; whether to clean date/time columns
#' @param rename boolean; whether to rename column headings (they are usually blank from the API)
#' @return A tibble if format == "csv", otherwise a list
#' @examples
#' list_example <- parse_response(
#' send_request(
#' build_call("TEMP", api_key = "12345", from_date = "01 Jun 2019",
#' to_date = "10 Jun 2019", service_type = "xml")
#' ), "xml")
#' @export
parse_response <- function(response, format = NULL, clean_dates = TRUE, rename = TRUE){

  if (is.null(format)){
    format <- response$service_type
  }

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
      if (stringr::str_detect(parsed_content, "\\<EOF>")) {
        ret <- parse_eof_csv(parsed_content)
      } else {
        ret <- parse_clean_csv(parsed_content)
      }
      if (clean_dates == TRUE){
        try({
          ret <- clean_date_columns(ret)}
          , TRUE)
      }
    }
    else if (response$data_item_type == "Legacy"){
      ret <- readr::read_delim(file = parsed_content, delim = ",", col_name = FALSE, na = "NA", skip = 1)
      ret <- droplevels(ret)
      ret <- ret[1:nrow(ret) - 1,]
      if (rename){
        if (ncol(ret) != length(get_column_names(response$data_item))){
          warning("Number of columns in csv doesn't match expected; leaving names as default")
        }
        else {
          names(ret) <- get_column_names(response$data_item)
        }
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

#' Parse a .csv response with a EOF tag left in
#'
#' Some .csv files returned from the API still have an EOF tag left at the bottom and contain 4 lines of nonsense.
#' This function is used to parse these files, whereas the \code{parse_clean_csv()} function is used to
#' parse .csv files without this tag and the junk lines.
#' @param content character; the original response object parsed as a single text string.
#' @return tibble; a tibble containing the data in the .csv file
#' @family parsers
parse_eof_csv <- function(content) {
  try_parse({
    end_ind <- stringr::str_locate(content, "\\<EOF>")
    parsed_content <- substr(content, 1, end_ind-1)
    readr::read_delim(file = content, delim = ",", skip = 4, na = "NA")
  },
  error_message = "Response could not be parsed using `parse_eof()` function.
                        Returning an empty tibble."
  )
}


#' Parse a 'clean' .csv response
#'
#' Some .csv files are returned without the EOF tag and with only 1 line before the data. This
#' function is used to parse these files, whereas the \code{parse_eof_csv()} function is used
#' to parse those files with the EOF tag and junk lines.
#' @param content character; the original response object parsed as a single text string.
#' @return tibble; a tibble containing the data in the .csv file
#' @family parsers
parse_clean_csv <- function(content) {
  try_parse({
    readr::read_delim(file = content, delim = ",", skip = 1, na = "NA")
  },
  error_message = "Response could not be parsed using `parse_clean_csv()` function.
                        Returning an empty tibble."
  )
}

#' Wrapper to the tryCatch version to be used for the parsing function
#'
#' This simple wrapper returns an empty tibble on error and returns a custom warning message.
#' @param expr expression; expression to be evaluated for errors
#' @param error_message character; character string to be displayed as a warning on error
#' @param ... extra parameters to be passed to the \code{tryCatch()} function.
#' @return evaluated expression on success or empty tibble on error
try_parse <- function(expr, error_message, ...) {
  tryCatch({
    expr
  }, error = function(e) {
    warning(error_message)
    tibble::tibble()
  },
  ...)
}
