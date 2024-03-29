# non-exported, utility functions

format_date <- function(dat){
  date_return <- as.Date(dat)
  return(format(date_return, format = "%Y-%m-%d"))
}

format_datetime <- function(dattime){
  datetime_return <- as.POSIXct(dattime)

  datetime_return <- format(datetime_return, format = "%Y-%m-%d %H:%M:%OS")
  return(datetime_return)
}

format_time <- function(time){
  time_return <- as.POSIXct(time, tryFormats = c("%H%M%OS",
                                                 "%H:%M:%OS",
                                                 "%H-%M-%OS"
  ))
  return(format(time_return, format = "%H:%M:%OS"))
}


format_month <- function(month){
  if (nchar(month) > 3){
    warning("month is longer than 3 values, provided value will be trimmed")
    month_return <- substr(month, 1, 3)
  }
  else {
    month_return <- month
  }
  return(month_return)
}

'%!in%' <- function(x,y)!('%in%'(x,y))

upper_case <- function(x){
  if (x %!in% c("MessageDetailRetrieval", "MessageListRetrieval")){
    ret <- toupper(x)
  }
  else {
    ret <- x
  }
  return(ret)
}



#' Check the the provided Settlement Period value is valid
#'
#' Currently accepted values for Settlement Period is 1-50 and *
#' @param period numeric/character; value to check. Must be numeric and between 1 and 50 or a character that's "*"
#' @return character; period as character
check_period <- function(period) {
  if (!is.null(period)) {
    if (period <= 0 | period > 50){
      if (period != "*"){
        stop("invalid period value")
      }
    }
  }
  as.character(period)
}

get_build_arguments <- function(params) {
  params <- params[!names(params) %in% c("data_item", "api_version")]
  params[!sapply(params, is.null)]
}

quiet_parse <- function(response, type = "text") {
  suppressWarnings(httr::content(response, type, col_types = readr::cols()))
}
