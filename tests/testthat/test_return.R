context("Return accuracy")


test_that("Returns list", {
  expect_true(tibble::is_tibble(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "csv")))
  expect_true(is.list(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "xml")))
})

test_that("Errors/warnings due to incorrect format", {
  expect_error(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "test"))
  expect_warning(full_request(data_item = "MessageDetailRetrieval", api_key = "test", event_start = "12 Jun 2018", event_end = "13 Jun 2018", service_type = "csv"))
})

