
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

You can use the build\_x\_call functions to create the appropriate URL for your API request.

``` r
## This creates an API request to retrieve the B1720 flow on 1st Jan 2018, Settlement Period 1
build_b_call(data_item = "B1720", api_key = "12345", settlement_date = '1 Jan 2018', settlement_period = "1")
#> [1] "https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2018-01-01&Period=1&ServiceType=csv"
```
