context("Return accuracy")


test_that("Returns list", {
  expect_true(tibble::is_tibble(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "csv")))
  expect_true(is.list(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "xml")))
})


