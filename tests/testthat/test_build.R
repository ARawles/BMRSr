context("Build accuracy")


test_that("Typical Request", {
# "https://api.bmreports.com/BMRS/B1720/v1?APIKey=4rs1u6b3ror2wjg&Period=*&SettlementDate=2019-10-13"

  api_key  <- "12345"
  data_item  <- "B1720"
  api_version  <- "v1"
  settlement_date  <-  "13-10-2019" #DD-MM-YYYY
  period <- "*"

  request  <- build_b_call(data_item = data_item,
             api_version = api_version,
             settlement_date = settlement_date,
             period = period,
             api_key = api_key)

  expect_true(is.list(request))
  expect_true(length(request) == 3)
  expect_equal(request$url, "https://api.bmreports.com/BMRS/B1720/v1?APIKey=12345&SettlementDate=2019-10-13&Period=%2A&ServiceType=csv")
             }
)

test_that("Invalid data items", {
  expect_warning(build_b_call(data_item = "test", api_key = "test"))
  expect_warning(build_remit_call(data_item = "test", api_key = "test"))
  expect_warning(build_legacy_call(data_item = "test", api_key = "test"))
})


test_that("Missing arguments", {
  expect_error(build_call())
  expect_error(build_b_call())
  expect_error(build_remit_call())
  expect_error(build_legacy_call())
})

test_that("Build output", {

  expect_true(is.list(build_call(data_item = "B1030", api_key = "test")))
  expect_true(is.list(build_b_call(data_item = "B1030", api_key = "test")))
  expect_true(is.list(build_remit_call(data_item = "MessageDetailRetrieval", api_key = "test")))
  expect_true(is.list(build_legacy_call(data_item = "TEMP", api_key = "test")))



  expect_true(build_call(data_item = "B1720", api_key = "test", settlement_date = "10 Jun 2018", period = 10)$url == "https://api.bmreports.com/BMRS/B1720/v1?APIKey=test&SettlementDate=2018-06-10&Period=10&ServiceType=csv")
})


test_that("Invalid service type", {
  expect_warning(build_call(data_item = "MessageDetailRetrieval", api_key = "test", message_id = "1", service_type = "csv"))
  expect_error(build_call(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "test"))
})

test_that("Incorrect parameters", {
  expect_error(build_call(data_item = "B1720", api_key = "test", from_date = "1 Jun 2018"))
  expect_error(build_call(data_item = "MessageDetailRetrieval", api_key = "test", settlement_date = "12 Jun 2018"))
  expect_error(build_call(data_item = "TEMP", api_key = "test", message_id = "1"))
  expect_error(build_call(data_item = "B1720", api_key = "test", period = 60))
})
