context("Dates, time and datetimes formats")

testthat("Date format correct", {
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "12 Jun 2018"), "&SettlementDate=2018-06-12")
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "12 06 2018"), "&SettlementDate=2018-06-12")
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "12/06/2018"), "&SettlementDate=2018-06-12")
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "12-Jun-2018"), "&SettlementDate=2018-06-12")
  expect_match(build_call(data_item = "B1730", api_key = "test", settlement_date = "12/06/18"), "&SettlementDate=2018-06-12")
})

testhat("Time format correct",{
  expect_match(build_call(data_item = "B1710", api_key = "test", end_time = "125055", "&EndTime=12:50:55"))
  expect_match(build_call(data_item = "B1710", api_key = "test", end_time = "12:50:55", "&EndTime=12:50:55"))
  expect_match(build_call(data_item = "B1710", api_key = "test", end_time = "12-50-55", "&EndTime=12:50:55"))
})

testhat("Datetime format correct", {
  expect_match(build_call(data_item = "FREQ", api_key = "test", from_datetime = "12 Jun 2018 12:50:55"), "&FromDateTime=2018-06-1212:50:55")
  expect_match(build_call(data_item = "FREQ", api_key = "test", from_datetime = "12-Jun-2018 125055"), "&FromDateTime=2018-06-1212:50:55")
  expect_match(build_call(data_item = "FREQ", api_key = "test", from_datetime = "12Jun2018 125055"), "&FromDateTime=2018-06-1212:50:55")
})

testthat("Month format warning", {
  expect_warning(build_call(data_item = "B1790", api_key = "test", month = "March"))
})
