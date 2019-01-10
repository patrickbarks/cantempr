context("cantemp_barcode")

test_that("cantemp_barcode works correctly", {

  temp_annual <- cantemp_fetch("annual")
  temp1 <- subset(temp_annual, station == "CALGARY")

  p <- cantemp_barcode(temp1)
  expect_is(p, "ggplot")
})

