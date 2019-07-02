
<!-- README.md is generated from README.Rmd. Please edit that file -->
BMRSr
=====

Overview
--------

The goal of BMRSr is to provide wrapper functions to better make use of the Balancing Mechanism Reporting System API. The BMRS API allow access to a number of B flow, REMIT and Legacy data. This package contains functions to build the API requests, send them, retrieve the requested data and parse it.

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

### Build

These functions build the URL for the API request. The main function `build_call()` is the one you'll likely be calling, but all this does is call the appropriate `build_x_call()` function for the data\_item you've requested:

`build_call(data_item = "B1720", api_key = "12345", settlement_date = "1 Jan 2018", period = "1", service_type = "csv")` actually calls

``` r
build_b_call(data_item = "B1720", api_key = "12345", settlement_date = "1 Jan 2018", period = "1", service_type = "csv")
#> [1] "https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv"
```

### Send & Receive

This function (`send_request`) sends the provided URL to the API and returns a response() object with the added attribute of data\_item\_type (one of "B Flow", "Remit", or "Legacy"). Config options can also be supplied via the config\_options parameter as a named list, that will be passed to the httr::GET() function (implemented primarily for proxies and the like).

This function can be used with a premade url, however the user will also have to respecify the data item from the URL:

``` r
send_request("https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv", data_item = "B1720")
```

### Parse

This function (`parse_response()`) takes the response() object returned from the send\_request() function, and parses the response base on the service\_type parameter (whether it was "csv" or "xml"). CSVs return tibbles, and XMLs return lists.

``` r
parse_response(send_request("https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv", data_item = "B1720"), format  = "csv")
```

### Utility

These functions support the functionality of the previous 3 types. These functions include `get_function()` which returns the appropriate `build_x_call()` function needed for the `build_call()` function. `check_data_item` ensures that the request is for a valid data item.

### End-to-End

To do all of these steps (build the call, send and receive the data, and then parse it), use the `full_request()` function.

``` r
full_request(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "test"))
```
