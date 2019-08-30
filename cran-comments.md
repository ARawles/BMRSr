## Test environments
* local Windows 7 x64 install, R 3.5.1
* local Windows 10 x64 install, R 3.6.1
* ubuntu 16.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes*

*This is the first submission so there may be 1 note.

## Downstream dependencies

There are currently no downstream dependencies

## Changes from previous submission on 29/08/2019

* Edited description field in DESCRIPTION to not begin 'This package...'
* Wrapped references to 'BMRS API' and 'Balancing Mechanism Reporting Service API' in DESCRIPTION file in single quotes
* Added examples to
    + `send_request()`
    + `get_parameters()`
    + `get_data_items()`
    + `check_data_item()`
    + `get_column_names()`
    + `clean_date_columns()`
* Added additional examples to
    + `build_b_call()`
    + `build_remit_call()`
    + `build_legacy_call()`
    + `build_call()`
* Changed dontrun in `full_request()` example to donttest as the example will return a response but no data as the API key is incorrect
* Corrected example in `get_data_item_type()` documentation
* Reformatted example in `parse_response()` to be runnable (and removed dontrun)

