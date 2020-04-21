
#' COVID-19 data for the Commonwealth of Virginia
#'
#' This data was produced by the Virginia Department of Health and archived by
#' the COVID Tracking Project (https://covidtracking.com/)
#'
#' @format
#' Data frame with 24 columns
#' \describe{
#' \item{date}{Date of the report}
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
#' data cumulative to that point.  Also, since we drop some columns that aren't
#' useful to us, we can't recompute this hash; it's here as a key allowing us to backtrack
#' where a row of data originally came from, if needed.}
#' \item{dateChecked}{Date and time that the COVID Tracking Project updated their
#' data from VDH.}
#' \item{death}{Cumulative number of COVID-19 deaths.}
#' \item{deathIncrease}{Number of new deaths for the day.}
#' \item{totalTestResults}{Cumulative number of test results.}
#' \item{totalTestResultsIncrease}{Total number of new tests performed that day.}
#' \item{negativeIncrease}{Number of new negative test results.}
#' \item{positiveIncrease}{Number of new positive test results.  This is also the
#' number of new confirmed cases.}
#' \item{fpos}{Fraction of positive tests on this day.}
#' \item{fposCumulative}{Cumulative fraction of positive tests.}
#' \item{vapop}{Total population.  This is presumed constant over the time period
#' being considered here.}
#' \item{ftest}{Fraction of the total population tested on this day.}
#' \item{ftestCuulative}{Total fraction of population tested.}
#' }
#'
#' @source
#' https://covidtracking.com/api/v1/states/VA/daily.csv
#'
"vacovdata"
