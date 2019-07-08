#' Parse the results of a call (specific for B flows)
#'
#' @param response A response() object returned from the API request
#' @param format character string; format of the content of the response() object; either "csv" or "xml"
#' @return A tibble if format == "csv", otherwise a list
#' @examples
#' \dontrun{
#' tibble_example <- parse_response(response, "csv") #returns a tibble
#' list_example <- parse_response(response, "xml") #returns a list
#' }
#' @export
parse_response <- function(response, format){
  parsed_content <- httr::content(response, "text")
  if (response$data_item_type == "B Flow" && format == "csv"){
    start_ind <- stringr::str_locate_all(parsed_content, "\\*")
    end_ind <- stringr::str_locate(parsed_content, "\\<EOF>")
    parsed_content <- substr(parsed_content, max(start_ind[[1]][,2]+1), end_ind-1)
    ret <- tibble::as_tibble(utils::read.table(text = parsed_content, sep = ",", header = TRUE))
    ret <- clean_date_columns(ret)
  }
  else if (response$data_item_type == "Legacy" && format == "csv"){
    start_ind <- stringr::str_locate(parsed_content, "\n")
    parsed_content <- substr(parsed_content, start_ind, nchar(parsed_content))
    ret <- tibble::as_tibble(utils::read.table(text = parsed_content, sep = ",", header = FALSE, fill = TRUE))
    ret <- droplevels(ret)
    ret <- ret[1:nrow(ret) - 1,]
    ret <- clean_date_columns(ret)
    if (ncol(ret) != length(get_column_names(response$data_item))){
      warning("Number of columns in csv doesn't match expected; leaving names as default")
    }
    else {
      names(ret) <- get_column_names(response$data_item)
    }
  }
  else if (format == "xml"){
    ret <- as.list(xml2::read_xml(response))
  }
  else {
    stop("Invalid format specified")
  }
  return(ret)
}
