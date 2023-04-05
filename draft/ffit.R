#' Discrete Fourier Series fit
#'
#' @param \code{y} Numeric data.
#' @param \code{low.xlim} First x position. Default: \code{1}.
#' @param \code{up.xlim} Last x position. Default: \code{length(y)}
#' @return \code{fit.order} Model order. Default: \code{10}
#' @examples
#' library(ffit)
#' # Senoid
#' set.seed(123)
#' t0 <- 1:(5*24*60)
#' y <- ts(15 + 0.001*t0 + 10*sin(2*pi*t0/(length(t0)/5)) + rnorm(length(t0)), freq=length(t0)/5)
#' plot(y, type='l')
#' fit <- ffit(y)
#' plot(ft2, lwd = 3, col = 'red', xlim = range(1:length(y)), main = paste0('Fit order ', fit$fit.order))
#' points(1:length(y), y, pch = '.')
#'
#' # Random data
#' n <- 1000
#' set.seed(4321)
#' y2 <- cumsum(rnorm(n))
#' (fit <- ffit(y2, fit.order = 100))
#' plot(ft, lwd = 3, col = 'red', xlim = range(1:n), main = paste0('Fit order ', fit$fit.order))
#' points(1:n, y2, pch = '.')
#' @export
ffit <- function(y, fit.order = 10, low.xlim = 1, up.xlim = length(y)){
  n <- length(y)
  x <- seq(low.xlim, up.xlim, length.out = n)
  beta <- 2*pi/(up.xlim-low.xlim)

  # Left Riemann mean
  a0 <- mean(y[-n], na.rm = TRUE)

  ak <- vector(length = fit.order)
  bk <- vector(length = fit.order)

  # Progress bar
  pb <- progress::progress_bar$new(
    format = "  progress [:bar] :percent em :elapsed",
    total = fit.order, clear = FALSE, width = 60)

  for(i in 1:fit.order){
    ak[i] <- 2*mean(y[-n]*cos(i*beta*x[-n]), na.rm = TRUE)
    bk[i] <- 2*mean(y[-n]*sin(i*beta*x[-n]), na.rm = TRUE)

    # Updating progress bar
    pb$tick()
  }
  ff <- list(a0 = a0, ak = ak, bk = bk, beta = beta,
             n = n, fit.order = fit.order, param = 2*fit.order+1,
             compress = 1 - (2*fit.order+1)/n)
  return(ff)
}
