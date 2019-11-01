context("Util function accuracy")

test_that("Invalid data items/types",{
  expect_error(get_function("B1111"))
  expect_error(check_data_item("B1720", "test"))
  expect_warning(check_data_item("TEMP", "B Flow"))
  expect_error(get_column_names("B1111"))
  expect_error(get_data_items("something"))
})

test_that("Non-succesful response codes",{
  expect_error(parse_response(send_request(request = list(url = "https://api.bmreports.com/BMRS/B1770/v1?APIKey=test&ettlementDate=2018-06-01&Period=10&ServiceType=csv",data_item = "B1770")), format = "csv"))
  expect_error(parse_response(send_request(request = list(url = "https://api.bmreports.com/BMRS/B1770/v1?APIKey=test&ettlementDate=2018-06-01&Period=10&ServiceType=csv",data_item = "B1770")), format = "error"))
})

test_that("Successful column renaming", {
  expect_length(get_column_names("TEMP"), 6)
})

test_that("Successful date column conversion", {
  expect_true(is(clean_date_columns(tibble::tribble(~settlement_date, ~test_value,
                             "20190901", 10))$settlement_date)[1] == "Date")
  expect_true(is(clean_date_columns(tibble::tribble(~settlement_time, ~test_value,
                                                    "12:00:00", 10))$settlement_time)[1] == "POSIXct")
  expect_true(is(clean_date_columns(tibble::tribble(~settlement_date_time, ~test_value,
                                                    "20190910 12:00:00", 10))$settlement_date_time)[1] == "POSIXct")
})


