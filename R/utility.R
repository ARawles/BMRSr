
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
#' @param data_item character; the data item to get the parameters for
#' @return A list containing the named parameters required for that call
#' @export
get_parameters <- function(data_item){
  return(get_parameters_list[[upper_case(data_item)]])
}



#' Check the data item to ensure that it is a valid request
#' @param data_item character; the data item to check
#' @param type character; the type of data_item - one of "B Flow", "Legacy", or "REMIT"
#' @return boolean: returns true if data_item is valid, false if it is not
#' @export
check_data_item <- function(data_item, type){
  if (type == "B Flow"){
    if (data_item %!in% c("B1720", "B1730", "B1740", "B1750", "B1760",
                          "B1770", "B1780", "B1790", "B1810", "B1820", "B1830",
                          "B0610", "B0620", "B0630", "B0640", "B0650", "B0810",
                          "B1410", "B1420", "B1430", "B1440", "B1610", "B1620",
                          "B1630", "B0910", "B1320", "B1330", "B0710", "B0720", "B1010",
                          "B1020", "B1030", "B1510", "B1520", "B1530", "B1540")){
      warning("Requested data item is not a valid B flow")
      ret <- FALSE
    }
    else {
      ret <- TRUE
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
      ret <- FALSE
    }
    else {
      ret <- TRUE
    }
  }
  else if (type == "REMIT"){
    if (data_item %!in% c("MessageDetailRetrieval", "MessageListRetrieval")){
      warning("Requested data item is not a valid REMIT data item")
      ret <- FALSE
    }
    else {
      ret <- TRUE
    }
  }
  else {
    stop("type parameter is not valid")
  }
  return(ret)
}