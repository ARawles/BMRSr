#Sys.setenv("http_proxy"="proxysg:8080")
#Sys.setenv("https_proxy"="proxysg:8080")


#' Create an API call for B-data flows
#'
#' @param data_item character string; the id of the B flow
#' @param api_key character string; api key retreived from the Elexon portal
#' @param ... other values (all character strings) to be passed to the function as API parameters
#' @return string; created url for the call
#' @examples
#' build_b_call(data_item = "B1730", api_key = "12345", settlement_date = "14-12-2016")

build_b_call <- function(data_item, api_key, settlement_date = NULL, settlement_period = NULL,
                         year = NULL, month = NULL, week = NULL, process_type = NULL, start_time = NULL,
                         end_time = NULL, start_date = NULL, end_date = NULL, service_type = "csv", version = "v1") {
  url = paste0("https://api.bmreports.com/BMRS/", data_item, "/", version, "?APIKey=", api_key)
  if (!is.null(settlement_date)) {
    url = paste0(url, "&SettlementDate=", format_date(settlement_date))
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


#' Create B flow API call and retrieve the results
#'
#' @inheritParams build_b_call
#' @return A response() object
#' @examples
#' get_b(data_item = "B1730", api_key = "12345", settlement_date = "14-12-2016)

get_b <- function(data_item, api_key, settlement_date = NULL, settlement_period = NULL,
                  year = NULL, month = NULL, week = NULL, process_type = NULL, start_time = NULL,
                  end_time = NULL, start_date = NULL, end_date = NULL, service_type = "csv", version = "v1"){
  url <- build_b_call(data_item, api_key, settlement_date, settlement_period,
                      year, month, week, process_type, start_time,
                      end_time, start_date, end_date, service_type, version)
  results <- httr::GET(url)
  return(results)
}

parse_response <- function(response, format){
  parsed_content <- httr::content(response, "text")
  if (format == "csv"){
    start_ind <- stringr::str_locate_all(parsed_content, "\\*")
    end_ind <- stringr::str_locate(parsed_content, "\\<EOF>")
    parsed_content <- substr(parsed_content, max(start_ind[[1]][,2]+1), end_ind-1)
    ret <- as_tibble(read.table(text = parsed_content, sep = ",", header = TRUE))
  }
  else if (format == "xml"){
    ret <- as_list(read_xml(response))
  }
  else {
    stop("Invalid format specified")
  }
  return(ret)
}

  # structure(
  #   list(
  #     request = url,
  #     response = results$status_code,
  #     content = parsed
  #   ),
  #   class = "BMRS_api"
  # )




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
