#' Interpolate vectors
#'
#' @description Interpolate vactors, compressing to \code{compact.to} fraction. May remove zeros.
#' @param y A vector or time series.
#' @param compact.to Proportion of remaining points after compaction, between (including) 0 and 1. If equals to 1 and keep.zeros = TRUE, the original vector is presented.
#' @param drop.zeros Logical. Drop repeated zeros? Default: \code{FALSE}.
#' @param to.data.frame Logical. Convert to data frame? Default: \code{FALSE}.
#' @param round.off Number of decimal places of the interpolated \code{y} Default: \code{NULL}.
#' @param weight Vector of weights with same length of \code{y}. Default: \code{NULL}.
#' @return A list of interpolated \code{x} and \code{y} values with length near to \code{compact.to*length(y)}.
#' @examples
#' library(voice)
#'
#' v1 <- 1:100
#' (c1 <- interp(v1, compact.to = 0.2))
#' length(c1$y)
#' plot(1:100, type = 'l')
#' points(c1$x, c1$y, col='red')
#'
#' # with weight
#' (c2 <- interp(v1, compact.to = 0.2, weight = rev(v1)))
#' plot(c1$y)
#' points(c2$y, col = 'red')
#'
#' (v2 <- c(1:5, rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
#' length(v2)
#' interp(v2, 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
#' interp(v2, 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
#' interp(v2, 0.2, drop.zeros = TRUE)
#' interp(v2, 0.2, drop.zeros = FALSE)
#'
#' (v3 <- c(rep(0,10), 1:20, rep(0,3)))
#' (c3 <- interp(v3, 1/3, drop.zeros = FALSE, to.data.frame = FALSE))
#' lapply(c3, length)
#' plot(v3, type = 'l')
#' points(c3$x, c3$y, col = 'red')
#'
#' (v4 <- c(rnorm(1:100)))
#' (c4 <- interp(v4, 1/4, round.off = 3))
#' @seealso \code{rm0}, \code{interp_mc}, \code{interp_df}
#' @export
interp <- function(y, compact.to, drop.zeros = FALSE, to.data.frame = FALSE,
                   round.off = NULL, weight = NULL){

  ifelse(drop.zeros, v <- voice::rm0(y), v <- y)
  lv <- length(v)

  # build weight
  if(!is.null(weight)){
    w <- ceiling(weight)
    v <- rep(v, w)
  }

  # interpolating
  cv <- stats::approx(v, n = ceiling(compact.to*lv), rule = 2)

  # round.off
  if(!is.null(round.off)){
    cv <- lapply(cv, round, round.off)
  }

  # data frame
  if(to.data.frame){
    cv <- do.call(cbind, cv)
  }
  return(cv)
}
