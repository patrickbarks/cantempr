context("cantemp_meta")

test_that("cantemp_meta works correctly", {

  meta <- cantemp_meta()
  expect_is(meta, "data.frame")
  expect_true(nrow(meta) == 338)
})

