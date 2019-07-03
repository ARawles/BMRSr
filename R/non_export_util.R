# non-exported, utility functions

format_date <- function(dat){
  date_return <- as.Date(dat, tryFormats = c("%d-%m-%Y", "%d-%b-%Y", "%d-%m-%y",
                                             "%d/%m/%Y", "%d/%b/%Y", "%d/%m/%y",
                                             "%d %m %Y", "%d %b %Y", "%d %B %Y"))
  return(format(date_return, format = "%Y-%m-%d"))
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
