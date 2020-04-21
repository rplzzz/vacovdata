
#' COVID-19 data for the Commonwealth of Virginia
#'
#' This data was produced by the Virginia Department of Health and archived by
#' the COVID Tracking Project (https://covidtracking.com/)
#'
#' @format
#' Data frame with 25 columns
#' \describe{
#' \item{date}{Date of the report}
#' \item{state}{The state, which is always 'VA' in this dataset.  The column is
#' retained for compatibility with other datasets from the COVID Tracking Project.}
#' \item{positive}{Cumulative number of positive tests.}
#' \item{negative}{Cumulative number of negative tests.}
#' \item{pending}{Number of pending tests.  This data is very spotty.}
#' \item{hospitalizedCurrently}{Number of COVID-19 patients in hospitals.}
#' \item{hospitalizedCumulative}{Cumulative number of COVID-19 hospitalizations.
#' This column seems to have a lot of missing data.}
#' \item{inIcuCurrently}{Current number of COVID-19 patients in ICU.}
#' \item{inIcUCumulative}{Cumulative number of COVID-19 ICU cases.}
#' \item{onVentilatorCurrently}{Number of COVID-19 cases currently reported as
#' being on a Ventilator.}
#' \item{onVentilatorCumulative}{Cumulative number of COVID-19 ventilator cases.}
#' \item{recovered}{Number of COVID-19 cases reported as recovered.  It isn't
#' exactly clear who is counted in this total, hospitalized cases or all confirmed cases.}
#' \item{hash}{A hash of the data (probably SHA-1, but this isn't specified).  It
#' isn't clear whether this is computed on the single row of data, or on all of the
#' data cumulative to that point.}
#' \item{dateChecked}{Date and time that the COVID Tracking Project updated their
#' data from VDH.}
#' \item{death}{Cumulative number of COVID-19 deaths.}
#' \item{hospitalized}{(REDUNDANT) Cumulative number hospitalized.}
#' \item{total}{(REDUNDANT) Cumulative tests plus pending tests.}
#' \item{totalTestResults}{Cumulative number of test results.}
#' \item{posNeg}{Cumulative number of positive and negative test results.  This
#' seems to be always equal to the totalTestResults.}
#' \item{fips}{FIPS code.  Always '51', since this is all Virginia data.}
#' \item{deathIncrease}{Number of new deaths for the day.}
#' \item{hospitalizedIncrease}{Increase in hospitalizations day over day.  This
#' doesn't appear to be corrected for discharges (so it's not "new cases"), and
#' it has spurious values on days following days when the hospitalization data was
#' missing.}
#' \item{negativeIncrease}{Number of new negative test results.}
#' \item{positiveIncrease}{Number of new positive test results.  This is also the
#' number of new confirmed cases.}
#' \item{totalTestResultsIncrease}{Total number of new tests performed that day.}
#' }
#'
#' @source
#' https://covidtracking.com/api/v1/states/VA/daily.csv
#'
"vacovdata"
