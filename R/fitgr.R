#' Extract measurements from observations
#'
#' Extract measurements of growth rates and sample prevalences from observed data.
#' The observations are relatively noisy, so windowed smoothing is used.
#'
#' If \code{smooth} is set, the smoothing is done \emph{before} the growth rate
#' bias correction is applied.
#'
#' @param obsdata Data frame of observations.  Date in column date
#' daily normalized observations in column given in the \code{col} argument
#' @param winsize Window size calculating rates and positive fractions
#' @param poscol Name of the column holding the positive observations
#' @param totcol Name of the column holding the total observations
#' @param iscumul Flag indicating whether poscol and totcol are cumulative
#' @param ksmooth Smoothing length in days for growth rates.  Zero means no smoothing.
#' @name obstools
NULL

#' @describeIn obstools Measure growth rate from observations
#' @export
fitgr <- function(obsdata, winsize=7, poscol='pos', totcol='tot',
                  iscumul=TRUE, ksmooth=7)
{
  date <- obsdata[['date']]
  fpos <- smoothprev(obsdata, winsize, poscol, totcol, iscumul)

  ## Days with no tests will have NaN values, so we need to drop them.  Also,
  ## days with a positive test fraction of 0 are going to create NaN values,
  ## so drop them too
  valid <- !is.na(fpos) & fpos > 0
  fpos <- fpos[valid]
  date <- date[valid]

  idx <- seq_along(fpos)
  lagidx <- idx - winsize
  lagidx <- ifelse(lagidx < 1, 1, lagidx)

  ## Fit a growth rate to each window
  gr <- function(i) {
    istrt <- lagidx[i]
    istop <- idx[i]
    n <- istop-istrt+1
    if(n <= 1) {
      ## Can't fit a single point.  Call this growth rate NA
      NA_real_
    }
    else if(n == 2) {
      ## Can't fit two points either.  Return the slope of the log between the
      ## two times
      (log(fpos[istop]) - log(fpos[istrt])) / as.numeric(date[istop] - date[istrt])
    }
    else {
      fp <- fpos[istrt:istop]
      dd <- date[istrt:istop]
      fit <- glm(fp~dd, family=quasipoisson(link='log'))
      fit$coefficients[['dd']]
    }
  }

  ## Now find the growth rate in positive fraction
  kobs <- sapply(idx, gr)

  ## Apply smoothing to kobs, if requested.
  if(ksmooth > 0) {
    sp <- ksmooth / length(kobs)
    i <- as.numeric(date-date[1])
    sf <- loess(kobs~i, span=sp)
    valid <- !is.na(kobs)
    kobs[valid] <- predict(sf)
  }

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

