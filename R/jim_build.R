# jim_build (wip:  version of build_b_call())
# Functions to build API calls


#' Create an API call for B-data flows
#'
#' @param data_item character string; the id of the B flow
#' @param api_key character string; api key retrieved from the Elexon portal
#'
#' settlement date (automatically cleaned by format_date)
#' @param settlement_date character string;
#' @param period character string; settlement period
#' @param year character string; year
#' @param month character string; month
#' @param week character string; week
#' @param process_type character string; process type
#' @param start_time character string; start time
#' @param end_time character string; end time
#' @param start_date character string; start date
#' @param end_date character string; end date
#' @param service_type character string; file format (csv or xml)
#'
#' version of the api to use (currently on v1)
#' @param api_version character string; 
#
#' @return list; created url for the call, service type and data item
#' @family call-building functions
#' @export
#' @examples
#' \dontrun{
#'     build_b_call(data_item = "B1730", 
#'     api_key = "12345", settlement_date = "14-12-2016")
#'
#'     build_b_call(data_item = "B1510", 
#'     api_key = "12345", start_date = "01 Jan 2019",
#'     start_time = "00:00:00", end_date = "02 Jan 2019", 
#'     end_time = "24:00:00", service_type = "csv")
#' }
#'
build_b_call <- function(data_item, api_key, 
        settlement_date = NULL, period = NULL,
        year = NULL, month = NULL, week = NULL, 
        process_type = NULL, start_time = NULL,
        end_time = NULL, start_date = NULL, end_date = NULL, 
        service_type = "csv", api_version = "v1") {

  request <- list()
  request$url <- paste0("https://api.bmreports.com/BMRS/", 
                       data_item, "/", api_version, "?APIKey=", api_key)

  check_data_item(data_item, "B Flow")

  if (!is.null(settlement_date)) {
    request$url <- paste0(request$url, "&SettlementDate=", 
                         format_date(settlement_date))
  }

  if (!is.null(period)){
    if (period <= 0 | period > 50){
      if (period != "*"){
      stop("invalid period value")
      }
    }
    request$url = paste0(request$url, "&Period=", as.character(period))
  }
  if (!is.null(process_type)){
    request$url = paste0(request$url, "&ProcessType", process_type)
  }
  if (!is.null(year)){
    request$url = paste0(request$url, "&Year=", year)
  }
  if (!is.null(month)){
    request$url = paste0(request$url, "&Month=", format_month(month))
  }
  if (!is.null(week)){
    request$url = paste0(request$url, "&Week=", week)
  }
  if (!is.null(start_date)){
    request$url = paste0(request$url, "&StartDate=", format_date(start_date))
  }
  if (!is.null(end_date)){
    request$url = paste0(request$url, "&EndDate=", format_date(end_date))
  }
  if (!is.null(start_time)){
    request$url = paste0(request$url, "&StartTime=", format_time(start_time))
  }
  if (!is.null(end_time)){
    request$url = paste0(request$url, "&EndTime=", format_time(end_time))
  }
  request$url = paste0(request$url, "&ServiceType=", service_type)
  request$service_type <- service_type
  request$data_item <- data_item
  return(request)
}

#' Create an API call for REMIT flows
#'
#' @param data_item character string; the id of the REMIT flow
#' @param api_key character string; api key retrieved from the Elexon portal
#' @param event_start character string; event start (automatically cleaned by format_date)
#' @param event_end character string; event end (automatically cleaned by format_date)
#' @param publication_from character string; publication from (automatically cleaned by format_date)
#' @param publication_to character string; publication to (automatically cleaned by format_date)
#' @param participant_id character string; participant id
#' @param asset_id character string; asset id
#' @param event_type character string; event type
#' @param fuel_type character string; fuel type
#' @param message_type character string; message type
#' @param message_id character string; message id
#' @param unavailability_type character string; unavailability type
#' @param active_flag character string; active flag
#' @param sequence_id character string; sequence id
#' @param service_type character string; file format (csv or xml)
#' @param api_version character string; version of the api to use (currently on v1)
#' @return list; created url for the call, service type and data item
#' @family call-building functions
#' @examples
#' build_remit_call(data_item = "MessageListRetrieval", api_key = "12345",
#' event_start = "14-12-2016", event_end = "15-12-2016")
#' build_remit_call(data_item = "MessageDetailRetrieval", api_key = "12345",
#' participant_id = 21, service_type = "xml")
#' @export

build_remit_call <- function(data_item, api_key, event_start = NULL, event_end = NULL, publication_from = NULL, publication_to = NULL,
                             participant_id = NULL, asset_id =  NULL, event_type = NULL, fuel_type = NULL, message_type = NULL, message_id = NULL,
                             unavailability_type =  NULL, active_flag = NULL, sequence_id = NULL, service_type = "xml", api_version = "v1"){
  request <- list()
  check_data_item(data_item, "REMIT")
  request$url = paste0("https://api.bmreports.com/BMRS/", data_item, "/", api_version, "?APIKey=", api_key)
  if (service_type == "csv"){
    warning("Remit files cannot be returned as .csv - file will be returned as xml")
    service_type <- "xml"
  }
  if (!is.null(event_start)) {
    request$url = paste0(request$url, "&EventStart=", format_date(event_start))
  }
  if (!is.null(event_end)) {
    request$url = paste0(request$url, "&EventEnd=", format_date(event_end))
  }
  if (!is.null(publication_from)) {
    request$url = paste0(request$url, "&PublicationFrom=", format_date(publication_from))
  }
  if (!is.null(publication_to)) {
    request$url = paste0(request$url, "&PublicationTo=", format_date(publication_to))
  }
  if (!is.null(participant_id)) {
    request$url = paste0(request$url, "&ParticipantID=", participant_id)
  }
  if (!is.null(asset_id)) {
    request$url = paste0(request$url, "&AssetID=", asset_id)
  }
  if (!is.null(event_type)) {
    request$url = paste0(request$url, "&EventType=", event_type)
  }
  if (!is.null(fuel_type)) {
    request$url = paste0(request$url, "&FuelType=", fuel_type)
  }
  if (!is.null(message_type)) {
    request$url = paste0(request$url, "&MessageType=", message_type)
  }
  if (!is.null(message_id)) {
    request$url = paste0(request$url, "&MessageID=", message_id)
  }
  if (!is.null(unavailability_type)) {
    request$url = paste0(request$url, "&UnavailabilityType=", unavailability_type)
  }
  if (!is.null(active_flag)) {
    request$url = paste0(request$url, "&ActiveFlag=", active_flag)
  }
  if (!is.null(sequence_id)) {
    request$url = paste0(request$url, "&SequenceId=", sequence_id)
  }
  if (!is.null(service_type)){
    request$url = paste0(request$url, "&ServiceType=", service_type)
  }
  request$service_type <- service_type
  request$data_item <- data_item
  return(request)
}


# ================
# my experiments
# ================
# 
  api_key  <- Sys.getenv("scripting_key")
  api_key
  data_item  <- "B1720"
  api_version  <- "v1" 
  SettlementDate  <-  "2019-10-13"
2019-10-13 

  Period="*"

#  request$url <- paste0("https://api.bmreports.com/BMRS/", 
                       data_item, "/", api_version, "?APIKey=", api_key)
                      
  the_url <- paste0("https://api.bmreports.com/BMRS/", 

                       data_item, "/", api_version, 
                       "?APIKey=", api_key, 
                       "&Period=",Period, 
                       "&ServiceType=", "csv",
                       "&SettlementDate=",SettlementDate)
  the_url

#"https://api.bmreports.com/BMRS/B1720/v1?APIKey=4rs1u6b3ror2wjg
&Period=*&SettlementDate=2020-10-10"
  #
res  <- httr::GET(the_url)
# HERE ...
r <- res %>% httr::content()


# more complicated
#
endpoint  <- paste0("https://api.bmreports.com/BMRS/B1720/v1")
settlement_date  <-  "14-12-2016"
settlement_date  <-  "2020-10-10"
api_key  <- api_key

the_url  <- paste0(endpoint,"?APIKey=", api_key, 
                   "&settlement_date=",settlement_date) 


the_url
# Status 200
res  <- httr::GET(the_url)
res


# ERROR
# use params
params  <- list( api_key= api_key,
                settlement_date= settlement_date)
unlist(params)
res  <- httr::GET(endpoint, params)
res


## from his web page, bottom
endpoint  <- paste0("https://api.bmreports.com/BMRS/B1720/v1?")
params  <- list( API_key= api_key,
                Period=27,
                ServiceType="csv",
                SettlementDate= settlement_date)

unlist(params)  
library(magrittr)
res  <- httr::GET(endpoint, query = params)
# res %>% jsonlite::fromJSON()
res %>% httr::content(as="text")

# another one?
# gen_data <- full_request(data_item = "FUELINST",
#                          api_key = api,
#                          from_datetime = "2019-07-01 00:00:00",
#                          to_datetime = "2019-07-03 00:00:00",
#                          service_type = "csv")
# 
params  <- list(API_key= api_key,
                 data_item="FUELINST",
                         from_datetime = "2019-07-01 00:00:00",
                         to_datetime = "2019-07-03 00:00:00",
                         service_type= "csv")
res  <- httr::GET(endpoint, query=params)
res
