context("Return accuracy")


test_that("Returns list", {
  expect_true(tibble::is_tibble(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "csv", get_params = list(proxy = "proxysg", proxyport = 8080))))
  expect_true(is.list(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "xml", get_params = list(proxy = "proxysg", proxyport = 8080))))
})

test_that("Errors do to incorrect format", {
  expect_error(full_request(data_item = "B1720", api_key = "test", settlement_date = "12 Jun 2018", period = "1", service_type = "test", get_params = list(proxy = "proxysg", proxyport = 8080)))
})

