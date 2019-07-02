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






