context("Return accuracy")


test_that("Returns list", {

  expect_true(is.list(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "xml")))
  expect_true(is.list(full_request(data_item = "MessageListRetrieval", api_key = "test", event_start = "12 Jun 2018", service_type = "csv")))
  expect_true(is.list(full_request(data_item = "MessageListRetrieval", api_key = "test", event_start = "12 Jun 2018", service_type = "xml")))
  expect_true(is.list(full_request(data_item = "TEMP", api_key = "test", from_date = "12 Jun 2018", service_type = "xml")))
})

test_that("Returns tibble", {
  expect_true(tibble::is_tibble(full_request(data_item = "TEMP", api_key = "test", from_date = "12 Jun 2018", service_type = "csv")))
  expect_true(tibble::is_tibble(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "csv")))
})


test_that("Returns response()",{
  expect_true(is(full_request(data_item = "TEMP", api_key = "test", from_date = "10 Jun 2018", to_date = "11 Jun 2018", parse = FALSE)) == "response")
})
