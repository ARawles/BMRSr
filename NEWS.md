# BMRSr 1.0.3

* Added better error handling around the sending and parsing of requests as per CRAN policies

# BMRSr 1.0.2.9000

* Fixed issue where EOF files were showing warnings when being parsed because the EOF wasn't being removed.
* Added check of data item to ensure that the data item is present for the provided version

# BMRSr 1.0.2

* Third CRAN release
* Changes documented in 1.0.1 - 1.0.2 updates

# BMRSr 1.0.1.9003

* Added automatic cleaning of all parameters passed to the `build()` functions
* Added `rlang` and `purrr` dependencies

# BMRSr 1.0.1.9002

* Expanded changes from `build_b_call()` to other `build` functions
* Allowed for additional arbitrary parameters to the build calls (with warnings or without)

# BMRSr 1.0.1.9001 

*  Changes to build_b_call() function
*  Collect query parameters using list input_query
*  Use httr::modify_url() to build query
*  Shorten long lines
*  Added test 'Typical Request' to test_that
*  Other cosmetic changes

# BMRSr 1.0.1.9000

* Changes to the API return values mean that the returned .csv files do not always have the same structure (#15).
    + This bred a change to the parser to be more dynamic and allow for the different structures.
    + This initial change has been made but further changes will need to be made to account for more file structures.

# BMRSr 1.0.1

* New CRAN release
* Bug fixes documented in versions 1.0.0 - 1.0.1
* New documentation website hosted at [bmrsr.arawles.co.uk](https://bmrsr.arawles.co.uk)
* Updated links to BMRS documentation

# BMRSr 1.0.0.9004

* Restructured the getting data items/data items types functions to pull from a single paired list of data items and types

# BMRSr 1.0.0.9002/3

* Fixed lingering typo issues

# BMRSr 1.0.0.9001

* Added `rename` parameter to `parse_response()` to avoid attempting to rename columns
* Fixed typo in `get_data_items()` list (DISBSAD was incorrectly spelt DISBAD) (#13)

# BMRSr 1.0.0

* Minor changes to prepare for CRAN publication

# BMRSr 0.1.3

* Added NEWS.md
* Included packages used in example in README.md in Suggests
* Updated documentation of included dataset to include description of every column
* Fixed versioning scheme
* Changed license to GPL (>= 2)

# BMRSr 0.1.2.001

* Fixed column types in example dataset (previously as characters, now as date/datetime depending on column)
* Added a new utility function `get_data_item_type()` to return the data item type ("B Flow", "REMIT" or "Legacy") of a data item
* Updated README to update changes
* Added first vignette - Using_BMRSr - which describes an end-to-end process and gives an in-depth example of how to use the package.
* Implemented a try statement into the column cleaning function to no longer error and stop if column conversion fails

# BMRSr 0.1.1.9019

* Fixed some incorrect column names returned by `get_column_names()`

# BMRSr 0.1.1.9016

* settlement_period and period parameters now accept "*" value to return all Settlement Periods
