#' @importFrom rlang .data
NULL

#' Get the correct function to create the API call depending on the data item
#' @param data_item character string; data item to be retrieved
#' @examples
#' get_function("TEMP")
#' @return function
#' @export
get_function <- function(data_item){

  switch(get_data_item_type(data_item),
         "B Flow" = build_b_call,
         "REMIT" = build_remit_call,
         "Legacy" = build_legacy_call)
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
check_data_item <- function(data_item, type = c("any", "B Flow", "Legacy", "REMIT"), silent = FALSE){
  type <- match.arg(type)
  if (data_item %!in% get_data_items(type)){
    if (!silent){
      warning(paste0("Requested data item is not a valid ", type, " flow"))
    }
    ret <- FALSE
  } else {
    ret <- TRUE
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

#' Check the data item to ensure that it is valid for the version specified
#'
#' Currently, "B1610" is the only data item that no longer supports v1 and equally is the only data item that supports v2.
#'
#' @param data_item character; the data item to check
#' @param version character/numeric; the API version, either as a number (e.g. `1`) or as a case-insensitive string (e.g. "v1" or "V2"). Default is 1.
#' @param silent boolean; whether to show a warning if that version is not valid for the provided
#' data item. Default is TRUE.
#' @return boolean; returns `TRUE` if data_item is valid for the provided version, `FALSE` if it is not
#' @export
#' @examples
#' check_data_item_version("B1610", 1)
#' check_data_item_version("B1710", 1)
check_data_item_version <- function(data_item, version = 1, silent = TRUE) {
  if (is.character(version)) {
     version <- as.numeric(stringr::str_extract(version, "\\d"))
  }
  if (data_item == "B1610" & version == 1) {
    if (!silent) {
      warning(paste0("Data item (", data_item, ") is not valid for provided version (", version, ")"), call. = FALSE)
      FALSE
    } else {
      FALSE
    }
  } else {
    TRUE
  }
}

