
#' Get the correct function to create the API call depending on the data item
#' @param data_item character string; data item to be retrieved
#' @examples
#' get_function("TEMP")
#' @return function
#' @export
get_function <- function(data_item){
  if (get_data_item_type(data_item) == "B Flow"){
    return(build_b_call)
  }
  else if (get_data_item_type(data_item) == "REMIT"){
    return(build_remit_call)
  }
  else if(get_data_item_type(data_item) == "Legacy"){
    return(build_legacy_call)
  }
}


#' Get the data item type of a data item
#' @param data_item character string; data item to be retrieved
#' @examples
#' get_data_item_type("TEMP")
#' @export
get_data_item_type <- function(data_item){

  type <- get_data_item_type_list[[data_item]]

  if (!is.null(type)){
    return(type)
  } else {
    stop("Data item not valid.")
  }
}

#' Get the required parameters for a data item
#' @param data_item character; the data item to get the parameters for
#' @return A list containing the named parameters required for that call
#' @examples
#' get_parameters("TEMP")
#' @export
get_parameters <- function(data_item){
  return(get_parameters_list[[upper_case(data_item)]])
}



#' Check the data item to ensure that it is a valid request
#' @param data_item character; the data item to check
#' @param type character; the type of data_item - one of "B Flow", "Legacy", or "REMIT" or "any" for any type
#' @param silent boolean; whether to show a warning if not a valid data item
#' @return boolean: returns true if data_item is valid, false if it is not
#' @examples
#' check_data_item("B1720", "B Flow") #valid
#' check_data_item("B1720", "Legacy") #invalid - incorrect type
#' check_data_item("B1111", "REMIT") #invalid - incorrect data item and type
#' @export
check_data_item <- function(data_item, type = "any", silent = FALSE){
  if (type %in% c("B Flow", "Legacy", "REMIT", "any")){
    if (data_item %!in% get_data_items(type)){
      if (!silent){
        warning(paste0("Requested data item is not a valid ", type, " flow"))
      }
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

#' Get a vector containing all of the permissible data items
#' @param type character; parameter to return only data items of a specific type ("Legacy", "B Flow", "REMIT", or "any")
#' @return vector; data items as character string
#' @examples
#' get_data_items()
#' @export
get_data_items <- function(type = "any") {
  if (!type %in% c("Legacy", "B Flow", "REMIT", "any")){
    stop("Invalid type supplied")
  } else {
    if (type == "any") {
      ret <- names(get_data_item_type_list)
    } else {
      ret <- names(get_data_item_type_list[which(get_data_item_type_list == type, useNames = FALSE)])
    }

  }
  return(ret)
}

#' Get the column names for a returned CSV Legacy dataset
#' @param data_item character string; data item for the dataset
#' @return vector; a vector of character strings with the column headings
#' @examples
#' get_column_names("TEMP")
#' @export
get_column_names <- function(data_item){
  if (!check_data_item(upper_case(data_item), type = "Legacy", silent = TRUE)){
    stop("Not a valid Legacy data item")
  }

  return(get_column_names_list[[data_item]])
}

#' Reformat date, time, and datetime columns
#' @param x tibble/df; dataset with the columns to be formatted
#' @return tibble/df; dataset with reformatted columns (if any needed reformatting)
#' @examples
#' generation_dataset_unclean <- as.data.frame(
#' apply(generation_dataset_example, 2, as.character)
#' ) #Create a version of the example generation dataset with character columns
#' clean_date_columns(generation_dataset_unclean)
#' @export
clean_date_columns <- function(x){
  for (i in 1:ncol(x)){
    if (stringr::str_detect(names(x)[i], "date") == TRUE & stringr::str_detect(names(x)[i], "date_time") == FALSE){
      x[,i] <- as.Date(sapply(x[,i], as.character), tryFormats =  c("%Y%m%d", "%Y-%m-%d"))
    }
    else if(stringr::str_detect(names(x)[i], "date") == TRUE & stringr::str_detect(names(x)[i], "date_time") == TRUE){
      x[,i] <- as.POSIXct(sapply(x[,i], as.character), format = "%Y-%m-%d %H:%M:%OS")
    }
    else if (stringr::str_detect(names(x)[i], "date") == FALSE & stringr::str_detect(names(x)[i], "time") == TRUE){
      x[,i] <- as.POSIXct(sapply(x[,i], as.character), tryFormats = c("%H:%M:%OS", "%Y%m%d%H%M%OS", "%Y-%m-%d %H:%M:%OS"))
    }
  }
  return(x)
}

#' Fixes parameters provided in the `build_x_call()` functions
#'
#' @param param object; parameter to fix
#' @param before function; function to fix the parameter. `param` will be passed as the first argument to this function.
#' Default NULL does nothing
#' @param ... additional arguments passed to the `before` function
#' @export
#' @return modified `param` object (if `before` isn't NULL)
fix_parameter <- function(param, before = NULL, ...) {
  # If it's null, just return it because we're assigning this to a list, it won't be added anyway
  if (is.null(param)) {
    return(param)
  }

  if (!is.null(before)) {
    param <- do.call(before, args = list(param, ...))
  }
  param
}

check_period <- function(period) {
  if (!is.null(period)) {
    if (period <= 0 | period > 50){
      if (period != "*"){
        stop("invalid period value")
      }
    }
  }
  period
}
