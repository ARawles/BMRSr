context("Parsing function accuracy")


test_that("Error codes", {
  resp <- httr:::response()
  resp$status_code <- 201
 expect_error(parse_response(resp))

})
