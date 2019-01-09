context("cantemp_fetch")

test_that("cantemp_fetch works correctly", {

  clim_monthly <- cantemp_fetch("monthly")
  expect_is(clim_monthly, "data.frame")
  expect_true(all(clim_monthly$interval %in% month.abb))

  clim_seasonal <- cantemp_fetch("seasonal")
  expect_is(clim_seasonal, "data.frame")
  seasons <- c("Winter", "Spring", "Summer", "Autumn")
  expect_true(all(clim_seasonal$interval %in% seasons))

  clim_annual <- cantemp_fetch("annual")
  expect_is(clim_annual, "data.frame")
  expect_true(all(clim_annual$interval == "Annual"))

  clim <- cantemp_fetch("all")
  expect_is(clim, "data.frame")
  expect_true(length(unique(clim$interval)) == 17)
})


test_that("cantemp_fetch fails gracefully", {

  expect_error(cantemp_fetch("blagh"))
})

