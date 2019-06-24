library(httr)
library(xml2)
library(stringr)
source("useful_functions.R")


Sys.setenv("http_proxy"="proxysg:8080")
Sys.setenv("https_proxy"="proxysg:8080")


build_b_call <- function(data_item, api_key, settlement_date = NULL, settlement_period = NULL,
                         year = NULL, month = NULL, week = NULL, process_type = NULL, start_time = NULL,
                         end_time = NULL, start_date = NULL, end_date = NULL, service_type = "csv", version = "v1") {
  url = paste0("https://api.bmreports.com/BMRS/", data_item, "/", version, "?APIKey=", api_key)
  if (!is.null(settlement_date)) {
    url = paste0(url, "&SettlementDate=", settlement_date)
  }
  if (!is.null(settlement_period)){
    url = paste0(url, "&Period=", settlement_period)
  }
  if (!is.null(process_type)){
    url = paste0(url, "&ProcessType", process_type)
  }
  if (!is.null(year)){
    url = paste0(url, "&Year=", year)
  }
  if (!is.null(month)){
    url = paste0(url, "&Month=", month)
  }
  if (!is.null(week)){
    url = paste0(url, "&Week=", week)
  }
  if (!is.null(start_date)){
    url = paste0(url, "&StartDate=", start_date)
  }
  if (!is.null(end_date)){
    url = paste0(url, "&EndDate=", end_date)
  }
  if (!is.null(start_time)){
    url = paste0(url, "&StartTime=", start_time)
  }
  if (!is.null(end_time)){
    url = paste0(url, "&EndTime=", end_time)
  }
  url = paste0(url, "&ServiceType=", service_type)
  return(url)
}


get_b <- function(data_item, api_key, settlement_date = NULL, settlement_period = NULL,
                  year = NULL, month = NULL, week = NULL, process_type = NULL, start_time = NULL,
                  end_time = NULL, start_date = NULL, end_date = NULL, service_type = "csv", version = "v1"){
  url <- build_b_call(data_item, api_key, settlement_date, settlement_period,
                      year, month, week, process_type, start_time,
                      end_time, start_date, end_date, service_type, version)
  results <- GET(url)
  if (service_type == "csv"){
    parsed <- content(results)
  } else if (service_type == "xml") {
    parsed <- read_xml(results)
  }


  structure(
    list(
      request = url,
      response = results$status_code,
      content = parsed
    ),
    class = "BMRS_api"
  )
}


print.BMRS_api <- function(x,...){
  xml_children(x$content)
}



#fields (B Flows):
    #version
    #key
    #settlement date
    #settlement period
    #service type
    #year
    #month
    #week
    #process type
    #service type
    #start time
    #end time
    #start date
    #end date

#fields (remit):
    #version
    #key
    #messageId
    #participantId
    #SequenceId
    #ActiveFlag
    #type
    #from date
    #to date
    #settlement date
    #settlement period
    #BM Unit id
    #BM Unit type
    #Lead Party Name
    #NGC BM Unit Name
    #from cleared date
    #to cleared date
    #isTwoDayWindow
    #from datetime
    #to datetime
    #balancing service volume
    #zone identifier
    #start time
    #trade type
