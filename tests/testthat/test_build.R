context("Build accuracy")


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
  expect_type(build_call(data_item = "B1030", api_key = "test"), "character")
  expect_type(build_b_call(data_item = "B1030", api_key = "test"), "character")
  expect_type(build_remit_call(data_item = "MessageDetailRetrieval", api_key = "test"), "character")
  expect_type(build_legacy_call(data_item = "FLOW", api_key = "test"), "character")
})


test_that("Invalid REMIT format", {
  expect_warning(build_call(data_item = "MessageDetailRetrieval", api_key = "test", message_id = "1", service_type = "csv"))
})
