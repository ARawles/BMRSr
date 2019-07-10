context("Util function accuracy")

test_that("Invalid data items/types",{
  expect_error(get_function("B1111"))
  expect_error(check_data_item("B1720", "test"))
  expect_error(get_column_names("B1111"))
})



