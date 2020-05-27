#' Extract measurements from observations
#'
#' Extract measurements of growth rates and sample prevalences from observed data.
#' The observations are relatively noisy, so windowed smoothing is used.
#'
#' @param obsdata Data frame of observations.  Date in column date
#' daily normalized observations in column given in the \code{col} argument
#' @param winsize Window size for smoothing
#' @param poscol Name of the column holding the positive observations
#' @param totcol Name of the column holding the total observations
#' @param iscumul Flag indicating whether poscol and totcol are cumulative
#' @name obstools
NULL

#' @describeIn obstools Measure growth rate from observations
#' @export
fitgr <- function(obsdata, winsize=7, poscol='pos', totcol='tot', iscumul=TRUE)
{
  date <- obsdata[['date']]
  fpos <- smoothprev(obsdata, winsize, poscol, totcol, iscumul)

  ## Now find the growth rate in positive fraction
  dlfpos <- c(NA_real_, diff(log(fpos)))
  deltat <- c(NA_real_, as.numeric(diff(date)))

  kobs <- dlfpos / deltat
  kpop <- kobs / (1-fpos)

  data.frame(date=date, kobs=kobs, kpop=kpop)

}

#' @describeIn obstools Measure sample prevalence with smoothing
#' @export
smoothprev <- function(obsdata, winsize=7, poscol='pos', totcol='tot', iscumul=TRUE)
{
  if(iscumul) {
    pos <- obsdata[[poscol]]
    tot <- obsdata[[totcol]]
  }
  else {
    pos <- cumsum(obsdata[[poscol]])
    tot <- cumsum(obsdata[[totcol]])
  }

  ## Find the lagged index
  idx <- seq_along(pos) - winsize
  idx <- ifelse(idx < 1, 1, idx)

  npos <- pos - pos[idx]
  ntot <- tot - tot[idx]

  npos/ntot
}
