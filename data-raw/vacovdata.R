## process vacovdata dataset

apiurl <- 'https://covidtracking.com/api/v1/states/VA/daily.csv'
coltype <- 'cciiiiiiiiiicccciiiiiiiiiii'
newdata <- readr::read_csv(apiurl, col_types = coltype)
newdata$date <- lubridate::ymd(newdata$date)
newdata$dateChecked <- lubridate::ymd_hms(newdata$dateChecked)

## On May 2nd the state started reporting "unique tests performed" alongside
## total tests performed, and this caused a break in the time series.  (The number
## of tests performed that day shows as negative.)  To correct this, we add back
## the discrepancy between total and unique tests.  Daily increments get it added
## on May 2nd only.  Cumulative totals get it added on May 2nd and all days thereafter.
## The practical upshot is that cumulative totals are the sum of total tests up through
## May 2nd and unique tests thereafter.
may2disc <- 112450 - 101344
may2exact <- newdata$date == as.Date('2020-05-02')
may2post <- newdata$date >= as.Date('2020-05-02')

newdata$negative[may2post] <- newdata$negative[may2post] + may2disc
newdata$totalTestResults[may2post] <- newdata$totalTestResults[may2post] + may2disc
newdata$negativeIncrease[may2exact] <- newdata$negativeIncrease[may2exact] + may2disc
newdata$totalTestResultsIncrease[may2exact] <- newdata$totalTestResultsIncrease[may2exact] + may2disc

## check to make sure that no data has been dropped from the original dataset
dropped <- dplyr::anti_join(vacovdata::vacovdata, newdata, by='date')
if(nrow(dropped) != 0) {
  stop(nrow(dropped), ' days dropped from new dataset.')
}

## Check whether any key statistics have changed from what we have.
selvars <- c('date',
             'positive','negative',
             'totalTestResults', 'totalTestResultsIncrease')
newdchk <- newdata[,selvars]
olddchk <- vacovdata::vacovdata[, selvars]
chk <- dplyr::left_join(olddchk, newdchk, by='date')
chk$totalTestResultsIncrease.x[is.na(chk$totalTestResultsIncrease.x)] <- 0
chk$totalTestResultsIncrease.y[is.na(chk$totalTestResultsIncrease.y)] <- 0

dateok <-
  chk$positive.x == chk$positive.y &
  chk$negative.x == chk$negative.y &
  chk$totalTestResults.x == chk$totalTestResults.y &
  chk$totalTestResultsIncrease.x == chk$totalTestResultsIncrease.y
if(all(dateok)) {
  update <- TRUE
} else {
  baddates <- chk$date[!dateok]
  warning(length(baddates), ' dates had data discrepancies.  Check `baddates` for dates.  Package data will not be updated.')

  ## Allow user to override the block on updating, if they have determined that the
  ## data is ok.
  if(exists('ACCEPT_DISCREPANCY') && ACCEPT_DISCREPANCY) {
    update <- TRUE
    ACCEPT_DISCREPANCY <- FALSE
    warning('ACCEPT_DISCREPANCY is set; package data will be updated.')
  } else {
    update <- FALSE
  }
}


if(update) {
  vacovdata <- dplyr::select(newdata,
                             date, positive, negative, pending,
                             positiveIncrease, negativeIncrease,
                             hospitalizedCurrently, hospitalizedCumulative,
                             inIcuCurrently, inIcuCumulative,
                             onVentilatorCurrently, onVentilatorCumulative,
                             recovered, hash, dateChecked,
                             death, deathIncrease,
                             totalTestResults, totalTestResultsIncrease)

    ## Positive test fractions
  vacovdata$fpos <- vacovdata$positiveIncrease / vacovdata$totalTestResultsIncrease
  vacovdata$fposCumulative <- vacovdata$positive / vacovdata$totalTestResults

  ## population and new test fraction
  vacovdata$vapop <- 8517685
  vacovdata$ftest <- vacovdata$totalTestResultsIncrease / vacovdata$vapop
  vacovdata$ftestCumulative <- vacovdata$totalTestResults / vacovdata$vapop

  ## put in date order
  vacovdata <- dplyr::arrange(vacovdata, date)

  usethis::use_data(vacovdata, overwrite=TRUE)
}

