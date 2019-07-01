
#' Get the correct function to create the API call depending on the data item
#' @param data_item character string; data item to be retrieved
#' @examples
#' get_function("TEMP")
#' @export
get_function <- function(data_item){
  if (nchar(data_item) == 5 & substr(data_item,1,1) == "B"){
    return(build_b_call)
  }
  else if (data_item %in% c("MessageDetailRetrieval", "MessageListRetrieval")){
    return(build_remit_call)
  }
  else if(data_item %in% c("TEMP", "BOD", "CDN", "SYSWARN", "DISBAD", "NETBSAD", "FREQ", "MID", "DEVINDOD", "NONBM", "QAS", "ROLSYSDEM",
                           "WINDFORPK", "WINDFORFUELHH","FUELINSTHHCUR", "FUELINST", "FUELHH", "INTERFUELHH", "NOU2T14D", "FOU2T14D",
                           "UOU2T14D", "NOU2T52W", "FOU2T52W", "UOU2T52W", "NOUY1", "NOUY2", "NOUY3", "NOUY4", "NOUY5", "ZOU2T14D",
                           "ZOU2T52W", "ZOUY1", "ZOUY2", "ZOUY3", "ZOUY4", "ZOUY5", "INDOITSDO", "MELIMBALNGC", "FORDAYDEM", "DEMMF2T14D",
                           "DEMMF2T52W", "SOSOP", "SOSOT", "PKDEMYESTTDYTOM", "INDPKDEMINFO", "SYSDEM", "INDTRIADDEMINFO", "PHYBMDATA",
                           "DYNBMDATA", "DERBMDATA", "DERSYSDATA", "DETSYSPRICES", "MKTDEPTHDATA", "LATESTACCEPTS", "HISTACCEPTS", "SYSMSG",
                           "BMUNITSEARCH", "SYSWARNTDYTOM", "HISTSYSWARN", "LOLPDRM", "DEMCI", "STORAW", "TRADINGUNIT")){
    return(build_legacy_call)
  }
  else{
    stop("Data item not valid.")
  }
}

#' TO DO: Get the required parameters for a data item
#' @param data_item string of the data item to get the parameters for
#' @return A list containing the named parameters required for that call
#' @export
get_parameters <- function(data_item){
  return(list(settlement_date = NULL, settlement_period = NULL))
}


#' Send an API request (basically a wrapper to httr:GET that adds a marker for the data item)
#'
#' @param url A string with the API request (usually generated from build_b_call())
#' @return A response() object
send_request <- function(url, data_item, config_options = list()) {
  response <- httr::GET(url, do.call(httr::config, config_options))
  if (nchar(data_item) == 5 & substr(data_item,1,1) == "B"){
    response$data_item_type <- "B Flow"
  }
  else if (data_item %in% c("MessageDetailRetrieval", "MessageListRetrieval")){
    response$data_item_type <- "Remit"
  }
  else if(data_item %in% c("TEMP", "BOD", "CDN", "SYSWARN", "DISBAD", "NETBSAD", "FREQ", "MID", "DEVINDOD", "NONBM", "QAS", "ROLSYSDEM",
                           "WINDFORPK", "WINDFORFUELHH","FUELINSTHHCUR", "FUELINST", "FUELHH", "INTERFUELHH", "NOU2T14D", "FOU2T14D",
                           "UOU2T14D", "NOU2T52W", "FOU2T52W", "UOU2T52W", "NOUY1", "NOUY2", "NOUY3", "NOUY4", "NOUY5", "ZOU2T14D",
                           "ZOU2T52W", "ZOUY1", "ZOUY2", "ZOUY3", "ZOUY4", "ZOUY5", "INDOITSDO", "MELIMBALNGC", "FORDAYDEM", "DEMMF2T14D",
                           "DEMMF2T52W", "SOSOP", "SOSOT", "PKDEMYESTTDYTOM", "INDPKDEMINFO", "SYSDEM", "INDTRIADDEMINFO", "PHYBMDATA",
                           "DYNBMDATA", "DERBMDATA", "DERSYSDATA", "DETSYSPRICES", "MKTDEPTHDATA", "LATESTACCEPTS", "HISTACCEPTS", "SYSMSG",
                           "BMUNITSEARCH", "SYSWARNTDYTOM", "HISTSYSWARN", "LOLPDRM", "DEMCI", "STORAW", "TRADINGUNIT")){
    response$data_item_type <- "Legacy"
  }
  return(response)
}


#' Parse the results of a call (specific for B flows)
#'
#' @param response A response() object returned from the API request
#' @param data_item the data item that was requested and returned in the response() object
#' @param format The format of the content of the response() object; either "csv" or "xml"
#' @return A tibble if format == "csv", otherwise a list
#' @examples
#' tibble_example <- parse_response(response, "csv") #returns a tibble
#' list_example <- parse_response(response, "xml") #returns a list
#' @export
parse_response <- function(response, format){
  parsed_content <- httr::content(response, "text")
  if (response$data_item_type == "B Flow" && format == "csv"){
    start_ind <- stringr::str_locate_all(parsed_content, "\\*")
    end_ind <- stringr::str_locate(parsed_content, "\\<EOF>")
    parsed_content <- substr(parsed_content, max(start_ind[[1]][,2]+1), end_ind-1)
    ret <- tibble::as_tibble(read.table(text = parsed_content, sep = ",", header = TRUE))
  }
  else if (response$data_item_type == "Legacy" && format == "csv"){
    start_ind <- stringr::str_locate(parsed_content, "\n")
    parsed_content <- substr(parsed_content, start_ind, nchar(parsed_content))
    ret <- tibble::as_tibble(read.table(text = parsed_content, sep = ",", header = FALSE, fill = TRUE))
  }
  else if (format == "xml"){
    ret <- as.list(xml2::read_xml(response))
  }
  else {
    stop("Invalid format specified")
  }
  return(ret)
}


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
  } else {
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

check_data_item <- function(data_item, type){
  if (type == "B Flow"){
    if (data_item %!in% c("B1720")){
      warning("Requested data item is not a valid B flow")
    }
  }
  else if (type == "Legacy"){
    if (data_item %!in% c("TEMP", "BOD", "CDN", "SYSWARN", "DISBAD", "NETBSAD", "FREQ", "MID", "DEVINDOD", "NONBM", "QAS", "ROLSYSDEM",
                          "WINDFORPK", "WINDFORFUELHH","FUELINSTHHCUR", "FUELINST", "FUELHH", "INTERFUELHH", "NOU2T14D", "FOU2T14D",
                          "UOU2T14D", "NOU2T52W", "FOU2T52W", "UOU2T52W", "NOUY1", "NOUY2", "NOUY3", "NOUY4", "NOUY5", "ZOU2T14D",
                          "ZOU2T52W", "ZOUY1", "ZOUY2", "ZOUY3", "ZOUY4", "ZOUY5", "INDOITSDO", "MELIMBALNGC", "FORDAYDEM", "DEMMF2T14D",
                          "DEMMF2T52W", "SOSOP", "SOSOT", "PKDEMYESTTDYTOM", "INDPKDEMINFO", "SYSDEM", "INDTRIADDEMINFO", "PHYBMDATA",
                          "DYNBMDATA", "DERBMDATA", "DERSYSDATA", "DETSYSPRICES", "MKTDEPTHDATA", "LATESTACCEPTS", "HISTACCEPTS", "SYSMSG",
                          "BMUNITSEARCH", "SYSWARNTDYTOM", "HISTSYSWARN", "LOLPDRM", "DEMCI", "STORAW", "TRADINGUNIT")){
      warning("Requested data item is not a valid legacy data item")
    }
  }
  else if (type == "REMIT"){
    if (data_item %!in% c("MessageDetailRetrieval", "MessageListRetrieval")){
      warning("Requested data item is not a valid REMIT data item")
    }
  }
  return(NULL)
}

set_proxy <- function(...){
  options(RCurlOptions = ...)
}
