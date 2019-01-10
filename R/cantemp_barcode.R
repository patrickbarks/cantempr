#' Create a barcode plot from a time-series of temperature data
#'
#' Create a barcode plot from a time-series of temperature data.
#'
#' @param data A \code{data.frame} returned by \code{\link{cantemp_fetch}},
#'   subset to a single climate station
#' @param scale_col_low Color for low end of temperature gradient (see
#'   \code{\link[ggplot2]{scale_fill_gradient2}})
#' @param scale_col_mid Color for middle of temperature gradient (see
#'   \code{\link[ggplot2]{scale_fill_gradient2}})
#' @param scale_col_high Color for high end of temperature gradient (see
#'   \code{\link[ggplot2]{scale_fill_gradient2}})
#' @param scale_col_na Color for missing values of temperature (see
#'   \code{\link[ggplot2]{scale_fill_gradient2}})
#' @param scale_name Name to print above color scale
#' @param scale_breaks Number of breaks in color scale
#' @param scale_digits Number of digits in color scale temperature labels
#' @param x_breaks Breaks for the x-axis (see 'breaks' argument of
#'   \code{\link[ggplot2]{scale_x_continuous}})
#'
#' @return A barcode plot
#'
#' @author Patrick M. Barks <patrick.barks@@gmail.com>
#'
#' @examples
#' temp_annual <- cantemp_fetch(interval = "annual")
#' temp_toronto <- subset(temp_annual, station == "TORONTO")
#'
#' cantemp_barcode(temp_toronto)
#'
#' @import ggplot2
#' @export
cantemp_barcode <- function(data,
                            scale_col_low = "#053061",
                            scale_col_mid = "white",
                            scale_col_high = "#67001f",
                            scale_col_na = "grey50",
                            scale_name = NULL,
                            scale_breaks = 5,
                            scale_digits = 1,
                            x_breaks = waiver()) {

  ggplot(data, aes_string("year", 1, fill = "temp")) +
    geom_tile() +
    scale_x_continuous(expand = c(0, 0), breaks = x_breaks) +
    scale_y_continuous(expand = c(0.02, 0)) +
    scale_fill_gradient2(low = scale_col_low,
                         mid = scale_col_mid,
                         high = scale_col_high,
                         na.value = scale_col_na,
                         midpoint = mean(data$temp, na.rm = TRUE),
                         name = scale_name,
                         breaks = function(x) seq(x[1], x[2], length.out = scale_breaks),
                         labels = function(x) paste(formatC(x, format = "f", digits = scale_digits), "\u00B0C")) +
    theme_void() +
    theme(axis.text.x = element_text(), legend.margin = margin(0, 0, 0, 5))
}

