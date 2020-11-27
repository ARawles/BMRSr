# non-exported, utility functions

format_date <- function(dat){
  date_return <- as.Date(dat, tryFormats = c("%d-%m-%Y", "%d-%b-%Y",
                                             "%d/%m/%Y", "%d/%b/%Y",
                                             "%d %m %Y", "%d %b %Y", "%d %B %Y"))
  return(format(date_return, format = "%Y-%m-%d"))
}

format_datetime <- function(dattime){
  datetime_return <- as.POSIXct(dattime, tryFormats = c("%Y-%m-%d %H:%M:%OS",
                                                        "%Y/%m/%d %H:%M:%OS",
                                                        "%d-%m-%Y %H:%M:%OS",
                                                        "%d-%b-%Y %H:%M:%OS",
                                                        "%d/%m/%Y %H:%M:%OS",
                                                        "%d/%b/%Y %H:%M:%OS",
                                                        "%d/%m/%y %H:%M:%OS",
                                                        "%d %m %Y %H:%M:%OS",
                                                        "%d %b %Y %H:%M:%OS",
                                                        "%d %B %Y %H:%M:%OS",
                                                        "%Y-%m-%d %H%M%OS",
                                                        "%Y/%m/%d %H%M%OS",
                                                        "%d-%m-%Y %H%M%OS",
                                                        "%d-%b-%Y %H%M%OS",
                                                        "%d/%m/%Y %H%M%OS",
                                                        "%d/%b/%Y %H%M%OS",
                                                        "%d %m %Y %H%M%OS",
                                                        "%d %b %Y %H%M%OS",
                                                        "%d %B %Y %H%M%OS",
                                                        "%Y%m%d%H%M%OS",
                                                        "%Y%b%d%H%M%OS",
                                                        "%d%m%Y%H%M%OS",
                                                        "%d%b%Y%H%M%OS",
                                                        "%d%B%Y%H%M%OS"
  ))

  datetime_return <- format(datetime_return, format = "%Y-%m-%d%%20%H:%M:%OS")
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

#' Fixes parameters provided in the `build_x_call()` functions
#'
#' @param param list; named list with the parameter name and value (e.g. `list(settlement_date = "01/01/2020")`)
#' @param before function; function to fix the parameter. `param` will be passed as the first argument to this function.
#' Default NULL does nothing
#' @param ... additional arguments passed to the `before` function
#' @return modified `param` object (if `before` isn't NULL)
fix_parameter <- function(param, before = NULL, ...) {
  if (is.null(names(param))) {
    stop("param must be a named list.")
  }
  if (is.null(before)) {
      before <- get_cleaning_function(names(param))
  }

  if (!is.null(before)) {
    param <- do.call(before, args = list(unlist(param), ...))
  } else {
    param <- unname(unlist(param))
  }
  param
}

fix_all_parameters <- function(params = list()) {
  param_values  <- purrr::map2(params, names(params),
                              ~ fix_parameter(rlang::list2(!!.y := .x)))
  names(param_values) <- unlist(purrr::map(names(param_values), ~change_parameter_name(.x)))
  param_values
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
