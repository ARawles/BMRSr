
<!-- README.md is generated from README.Rmd. Please edit that file -->
BMRSr
=====

[![Travis build status](https://travis-ci.org/ARawles/BMRSr.svg?branch=master)](https://travis-ci.org/ARawles/BMRSr) [![Coverage status](https://codecov.io/gh/ARawles/BMRSr/branch/master/graph/badge.svg)](https://codecov.io/github/ARawles/BMRSr?branch=master)

Overview
--------

The goal of BMRSr is to provide wrapper functions to make use of the [Balancing Mechanism Reporting System API](https://www.elexon.co.uk/wp-content/uploads/2017/06/bmrs_api_data_push_user_guide_v1.1.pdf) easier for R users. The BMRS API allows access to a number of B flows, REMIT and Legacy data. This R package contains functions to build the API requests, send them, retrieve the requested data and parse it.

Installation
------------

You can install the released version of BMRSr from [GitHub](https://github.com/ARawles/BMRSr) with:

``` r
devtools::install_github("BMRSr")
```

You'll also need an API key. You can get this by registering on the [ELEXON portal](https://www.elexonportal.co.uk).

Usage
-----

BMRSr contains functions that can be split into 4 main categories:

-   Build
-   Send & Receive
-   Parse
-   Utility

### End-to-End

To perform a complete API request (build the call, send and receive the data, and then parse it), use the `full_request()` function.

``` r
full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "csv")
```

### Build

These functions build the URL for the API request. The main function `build_call()` is the one you'll likely be calling, but all this does is call the appropriate `build_x_call()` function for the data item you've requested. For example:

``` r
build_call(data_item = "B1720", api_key = "12345", settlement_date = "1 Jan 2018", period = "1", service_type = "csv")
#> $url
#> [1] "https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv"
#> 
#> $service_type
#> [1] "csv"
#> 
#> $data_item
#> [1] "B1720"
```

actually calls

``` r
build_b_call(data_item = "B1720", api_key = "12345", settlement_date = "1 Jan 2018", period = "1", service_type = "csv")
#> $url
#> [1] "https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv"
#> 
#> $service_type
#> [1] "csv"
#> 
#> $data_item
#> [1] "B1720"
```

These functions return a list of three items:

-   the url as a character string (`$url`)
-   the service type/return format (`$service_type`)
-   the data item (`$data_item`)

The input parameters you provide will be checked against those that are valid for the data item you are requesting, however there is no check on whether you have provided (at least) the required parameters for the data item.

To see all the allowed input parameters for each type (not each data item), use `?build_[type]_call`.

### Send & Receive

This function - `send_request()` - sends the provided URL to the API and returns a response() object with the added attribute of data\_item\_type (one of "B Flow", "Remit", or "Legacy"). Config options can also be supplied via the config\_options parameter as a named list, that will be passed to the `httr::GET()` function (implemented primarily for proxies and the like).

This function can be used with a premade url, however the user will also have to respecify the data item from the URL:

``` r
send_request("https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv", data_item = "B1720")
```

### Parse

This function - `parse_response()` - takes the response() object returned from the send\_request() function, and parses the response base on the service\_type parameter (whether it was "csv" or "xml"). CSVs return tibbles, and XMLs return lists. The returned CSVs from many of the calls contain unnecessary or incorrect data, so this parsing function will remove that data before returning a corrected response.

``` r
parse_response(send_request("https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv", data_item = "B1720"), format  = "csv")
```

### Utility

These functions support the functionality of the previous 3 types:

-   `get_function()` which returns the appropriate `build_x_call()` function needed for the `build_call()` function.
-   `check_data_item()` ensures that the request is for a valid data item.
-   `get_parameters()` returns a list with the allowed input parameters for the supplied data item.
-   `clean_data_columns()` reformats date/time/datetime columns based on their column names.
-   `get_data_items()` returns all valid data items.
-   `get_column_names()` retrieves the column headings for a particular data item (Legacy only as B flow responses already have column headings).

Full example
------------

Here's a full example, using the package to return generation by fuel type data

``` r

api <- "your_api_key_goes_here"


#We're requesting the FUELINST data item here.
#A full list of all the data items can be returned using the get_data_items() function

#Find out which parameters we need to provide for the data item we've chosen...
get_parameters("FUELINST")
#> [1] "from_datetime" "to_datetime"
```

``` r
full_request(data_item = "FUELINST", api_key = api,
             from_datetime = "2019-08-27 00:00:00",
             to_datetime = "2019-08-28 00:00:00",
             service_type = "csv")
```
