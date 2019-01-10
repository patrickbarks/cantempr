#' Fetch homogenized temperature data for 338 Canadian climate stations
#'
#' Fetch a tidy \code{data.frame} with homogenized temperatures for 338 Canadian
#' climate stations, optionally subset to a given interval (monthly, seasonal,
#' or annual).
#'
#' @param interval The interval of interest. One of \code{"monthly"} (monthly
#'   intervals), \code{"seasonal"} (seasonal intervals), \code{"annual"} (annual
#'   intervals), or \code{"all"} (all intervals combined).
#'
#' @return A \code{data.frame} with homogenized temperature data for 338
#'   Canadian climate stations, averaged at the specified \code{interval}.
#'   Columns include:
#'
#' \describe{
#' \item{prov}{Two-letter abbreviation for province}
#' \item{station}{Name of climate station}
#' \item{stnid}{Climate station identifier}
#' \item{year}{Observation year}
#' \item{period}{Observation period (either a month, season, or "Annual", as
#' specified in argument \code{interval})}
#' \item{temp}{Observed mean temperature in degrees celcius}
#' \item{flag}{Flag giving information about temperature data (\code{M}: missing
#' value, \code{E}: estimated during archiving process, \code{a}: adjusted for
#' homogeneity, \code{NA}: original value)}
#' }
#'
#' @author Patrick M. Barks <patrick.barks@@gmail.com>
#'
#' @references
#' Vincent, L. A., X. L. Wang, E. J. Milewska, H. Wan, F. Yang, and V. Swail
#' (2012). A second generation of homogenized Canadian monthly surface air
#' temperature for climate trend analysis. Journal of Geophysical Research
#' 117(D18110). \url{https://doi.org/10.1029/2012JD017859}
#'
#' @examples
#' # temperatures for monthly intervals
#' clim_month <- cantemp_fetch(interval = "monthly")
#'
#' # temperatures for seasonal intervals
#' clim_season <- cantemp_fetch(interval = "seasonal")
#'
#' # temperatures for annual intervals
#' clim_annual <- cantemp_fetch(interval = "annual")
#'
#' # temperatures for all intervals
#' clim_all <- cantemp_fetch(interval = "all")
#'
#' @export
cantemp_fetch <- function(interval = "annual") {

  if (!interval %in% c("monthly", "seasonal", "annual", "all")) {
    stop("Argument interval must be one 'monthly', 'seasonal', 'annual', or 'all'")
  }

  dat <- cantemp

  seasons <- c("Winter", "Spring", "Summer", "Autumn")
  months <- month.abb

  if (interval == "monthly") {
    dat <- dat[!dat$interval %in% c("Annual", seasons),]
  } else if (interval == "seasonal") {
    dat <- dat[!dat$interval %in% c("Annual", months),]
  } else if (interval == "annual") {
    dat <- dat[!dat$interval %in% c(seasons, months),]
  }

  # reset rownames
  rownames(dat) <- seq_len(nrow(dat))

  return(dat)
}

