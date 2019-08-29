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
* Implented a try statement into the column cleaning function to no longer error and stop if column conversion fails

# BMRSr 0.1.1.9019

* Fixed some incorrect column names returned by `get_column_names()`

# BMRSr 0.1.1.9016

* settlement_period and period parameters now accept "*" value to return all Settlement Periods
