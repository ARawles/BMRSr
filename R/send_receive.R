#' Send an API request (basically a wrapper to httr:GET that adds a marker for the data item)
#'
#' @param url character string; url string for the API request (usually generated from build_b_call())
#' @param data_item character string; data item (used to append a data_item_type attribute to the response() object)
#' @param config_options list; a named list of config options to be passed to httr::GET
#' @return A response() object
#' @export
send_request <- function(url, data_item, config_options = list()) {
  response <- httr::GET(url, do.call(httr::config, config_options))
  if (data_item %in% c("B1720", "B1730", "B1740", "B1750", "B1760",
                       "B1770", "B1780", "B1790", "B1810", "B1820", "B1830",
                       "B0610", "B0620", "B0630", "B0640", "B0650", "B0810",
                       "B1410", "B1420", "B1430", "B1440", "B1610", "B1620",
                       "B1630", "B0910", "B1320", "B1330", "B0710", "B0720", "B1010",
                       "B1020", "B1030", "B1510", "B1520", "B1530", "B1540")){
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
  response$data_item <- data_item
  return(response)
}






