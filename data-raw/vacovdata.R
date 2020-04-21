## process vacovdata dataset

apiurl <- 'https://covidtracking.com/api/v1/states/VA/daily.csv'
coltype <- 'cciiiiiiiiiicciiiinciiiii'
vacovdata <- readr::read_csv(apiurl, col_types = coltype)
vacovdata$date <- lubridate::ymd(vacovdata$date)
vacovdata$dateChecked <- lubridate::ymd_hms(vacovdata$dateChecked)

usethis::use_data(vacovdata, overwrite=TRUE)
