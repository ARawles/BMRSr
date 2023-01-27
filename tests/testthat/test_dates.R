context("Dates, time and datetimes formats")

test_that("Date format correct", {
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "2018/06/12")$url, "&SettlementDate=2018-06-12", fixed = TRUE)
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "2018-06-12")$url, "&SettlementDate=2018-06-12", fixed = TRUE)
  expect_error(build_call(data_item = "B1730", api_key = "test", settlement_date = "2018-Jun-12"))
  expect_error(build_call(data_item = "B1730", api_key = "test", settlement_date = "2018 06 12"))
})

test_that("Time format correct",{
  expect_match(build_call(data_item = "B1010", api_key = "test", end_time = "125055")$url, "&EndTime=12%3A50%3A55", fixed = TRUE)
  expect_match(build_call(data_item = "B1010", api_key = "test", end_time = "12:50:55")$url, "&EndTime=12%3A50%3A55", fixed = TRUE)
  expect_match(build_call(data_item = "B1010", api_key = "test", end_time = "12-50-55")$url, "&EndTime=12%3A50%3A55", fixed = TRUE)
})

test_that("Datetime format correct", {
  expect_match(build_call(data_item = "FREQ", api_key = "test", from_datetime = "2018-06-12 12:50:55")$url, "FromDateTime=2018-06-12%2012%3A50%3A55", fixed = TRUE)
  expect_error(build_call(data_item = "FREQ", api_key = "test", from_datetime = "2018 Jun 12 12:50:55"))
  expect_error(build_call(data_item = "FREQ", api_key = "test", from_datetime = "2018-Jun-12 125055"))
})

test_that("Month format warning", {
  expect_warning(build_call(data_item = "B1790", api_key = "test", month = "March"))
})
