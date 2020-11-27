
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
  get_parameters_list[[upper_case(data_item)]]
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
  ret
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
  ret
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

  get_column_names_list[[data_item]]
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


#' Convert a parameter name to a different format
#'
#' The names of the parameters that are used in the R functions do not perfectly correspond with the parameter name expected by the API. This
#' function converts an argument parameter name (e.g. `settlement_date`) to the URL argument name (e.g. `SettlementDate`) or the other way around
#' @param parameter character; name of the parameter provided to the relevant `build()` function
#' @param from character; one of "argument" or "url" depending on whether `parameter` is in the argument or URL format
#' @param to character; one of "argument" or "url"
#' @return character; name of the parameter used in the URL request or `build()` function. If no match is found, `character(0)`
#' @export
change_parameter_name <- function(parameter, from = c("argument", "url"), to = c("url", "argument")) {
  from <- match.arg(from)
  to <- match.arg(to)
  from_col <- rlang::sym(paste0(from, "_name"))
  to_col <- rlang::sym(paste0(to, "_name"))
  results <- dplyr::filter(parameter_name_map,  {{ from_col }} == parameter)
  dplyr::pull(results, {{ to_col }})
}

#' Get the cleaning function required for a parameter
#'
#' Before a parameter can be added to a request, it often needs to be cleaned. This function returns the appropriate function for a parameter.
#' Parameters can be supplied with their name used in the `build()` functions ("argument") or in the URL
#' @param character; name of the parameter. Either the parameter as it's passed to the `build()` functions or the name of the parameter in the URL
#' depending on the value of `format`
#' @param format character; what format is `parameter` in? One of "argument" (default) or "url"
#' @return character; name of the cleaning function
#' @export
get_cleaning_function <- function(parameter, format = c("argument", "url")) {
  format <- match.arg(format)
  if (format == "url") {
    parameter <- change_parameter_name(parameter, from = "url", to = "argument")
  }
  dplyr::filter(parameter_clean_functions_map, name == parameter)[["function"]]
}
