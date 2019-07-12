context("Util function accuracy")

test_that("Invalid data items/types",{
  expect_error(get_function("B1111"))
  expect_error(check_data_item("B1720", "test"))
  expect_error(get_column_names("B1111"))
})

test_that("Non-succesful response codes",{
  expect_error(parse_response(send_request(request = list(url = "https://api.bmreports.com/BMRS/B1770/v1?APIKey=test&ettlementDate=2018-06-01&Period=10&ServiceType=csv",data_item = "B1770")), format = "csv"))
  expect_error(parse_response(send_request(request = list(url = "https://api.bmreports.com/BMRS/B1770/v1?APIKey=test&ettlementDate=2018-06-01&Period=10&ServiceType=csv",data_item = "B1770")), format = "error"))
})


