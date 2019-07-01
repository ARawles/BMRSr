
<!-- README.md is generated from README.Rmd. Please edit that file -->
BMRSr
=====

The goal of BMRSr is to provide wrapper functions to better make use of the Balancing Mechanism Reporting System API.

Installation
------------

You can install the released version of BMRSr from [GitHub](https://github.com/ARawles/BMRSr) with:

``` r
devtools::install_github("BMRSr")
```

Example
-------

You can use the full\_request function to do a complete API request and return the results as a tibble or list

``` r
## This creates an API request to retrieve the B1720 flow on 1st Jan 2018, Settlement Period 1, and returns the results as a tibble
full_request(data_item = "B1720", api_key = "12345", settlement_date = '1 Jan 2018', period = "1", service_type = "csv")
```

You can also use the functions to create the API calls without retrieving the results

``` r
## This builds and returns the URL to retrieve the B1720 flow
build_call(data_item = "B1720", api_key = "12345", settlement_date = "1 Jan 2018", period = "1", service_type = "csv")
#> [1] "https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv"

## This builds and returns the URL to retreive the REMIT flow
build_call(data_item = "MessageListRetrieval", api_key = "12345", publication_from = "1 Jan 2018", publication_to = "10 Jan 2018", service_type = "xml")
#> [1] "https://api.bmreports.com/BMRS/MessageListRetrieval/v1?APIKey=12345&PublicationFrom=2018-01-01&PublicationTo=2018-01-10&ServiceType=xml"

## This builds and returns the URL to retreive the temperature data
build_call(data_item = "TEMP", api_key = "12345", from_date = "1 Jan 2018", to_date = "10 Jan 2018", service_type = "csv")
#> [1] "https://api.bmreports.com/BMRS/TEMP/v1?APIKey=12345&FromDate=2018-01-01&ToDate=2018-01-10&ServiceType=csv"
```
