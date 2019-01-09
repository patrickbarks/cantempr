
### load required libraries
library(curl)
library(tidyverse)


### download zip files containing station-specific text files
temp <- tempdir()
dl_path <- paste0(temp, "/Homog_monthly_mean_temp.zip")
zip_path <- "ftp://ccrp.tor.ec.gc.ca/pub/AHCCD/Homog_monthly_mean_temp.zip"
unzip_path <- paste0(temp, "/Homog_monthly_mean_temp/")
dir.create(unzip_path)

curl_download(zip_path, dl_path, quiet = FALSE)
unzip(dl_path, exdir = unzip_path)


### standardize column names
col_head <- c("Year", "Jan", "flag_Jan", "Feb", "flag_Feb", "Mar", "flag_Mar",
              "Apr", "flag_Apr", "May", "flag_May", "Jun", "flag_Jun", "Jul",
              "flag_Jul", "Aug", "flag_Aug", "Sep", "flag_Sep", "Oct",
              "flag_Oct", "Nov", "flag_Nov", "Dec", "flag_Dec", "Annual",
              "flag_Annual", "Winter", "flag_Winter", "Spring", "flag_Spring",
              "Summer", "flag_Summer", "Autumn", "flag_Autumn")


### read homogenized data and combine into single df
stn_file <- list.files(unzip_path)
stn_file_ids <- gsub("mm|\\.txt", "", stn_file)
stn_file_df <- data.frame(stn_file, stnid = stn_file_ids, stringsAsFactors = FALSE)

stn_dat <- read_csv("data-raw/Temperature_Stations.csv") %>%
  setNames(gsub(" ", "_", tolower(names(.)))) %>%
  left_join(stn_file_df, by = "stnid") %>%
  select(prov, station = station_name, stnid, stn_file, beg_yr, end_yr)

ReadFn <- function(file) {
  dat <- read.csv(paste0(unzip_path, file), skip = 4, col.names = col_head, stringsAsFactors = FALSE)
  dat$stnid <- gsub("mm|\\.txt", "", file)
  return(dat)
}

clim_full_l <- lapply(stn_file, ReadFn)
clim_full <- do.call(rbind.data.frame, clim_full_l)


### reshape to tidy format organized by period, year, and station
clim <- clim_full %>%
  as_tibble() %>%
  select(-starts_with("flag")) %>%
  select(year = Year, stnid, Jan:Autumn) %>%
  gather(interval, temp, Jan:Autumn) %>%
  left_join(select(stn_dat, prov, station, stnid), by = "stnid") %>%
  select(prov, station, stnid, year, interval, temp)

cantemp <- clim_full %>%
  as_tibble() %>%
  select(year = Year, stnid, starts_with("flag")) %>%
  setNames(gsub("flag_", "", names(.))) %>%
  gather(interval, flag, Jan:Autumn) %>%
  right_join(clim, by = c("year", "interval", "stnid")) %>%
  select(prov, station, stnid, year, interval, temp, flag) %>%
  mutate(temp = ifelse(flag == "M", NA, temp)) %>%
  as.data.frame()


### write to rda
usethis::use_data(cantemp, overwrite = TRUE, internal = TRUE)


