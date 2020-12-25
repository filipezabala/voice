#' Convolute vectors.
#'
#' @param y A vector or time series.
#' @param compact.to Proportion of remaining points after compactation, between (including) 0 and 1. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param drop.zeros Logical. Drop repeated zeros? Default: \code{'FALSE'}.
#' @param to.data.frame Logical. Convert to data frame? Default: \code{'FALSE'}.
#' @param round.off Number of decimal places of the convoluted vector. Default: \code{'NULL'}.
#' @return A list of convoluted \code{x} and \code{y} values with length near to \code{compact.to*length(y)}.
#' @examples
#' (c1 <- conv(1:100, compact.to = 0.2, drop.zeros = TRUE))
#' length(c1$y)
#' plot(1:100, type = 'l')
#' points(c1$x, c1$y, col='red')
#'
#' (v2 <- c(1:5, rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
#' length(v2)
#' conv(v2, 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
#' conv(v2, 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
#' conv(v2, 0.2, drop.zeros = TRUE)
#' conv(v2, 0.2, drop.zeros = FALSE)
#'
#' (v3 <- c(rep(0,10), 1:20, rep(0,3)))
#' (c3 <- conv(v3, 1/3, drop.zeros = FALSE, to.data.frame = FALSE))
#' lapply(c3, length)
#' plot(v3, type = 'l')
#' points(c3$x, c3$y, col = 'red')
#'
#' (v4 <- c(rnorm(1:100)))
#' (c4 <- conv(v4, 1/4, round.off = 3))
#' @seealso \code{rm0}, \code{conv_mc}, \code{conv_df}
#' @export
conv <- function(y, compact.to, drop.zeros = FALSE, to.data.frame = FALSE,
                 round.off = NULL){

  ifelse(drop.zeros, v <- voice::rm0(y), v <- y)
  lv <- length(v)

  # interpolating
  cv <- stats::approx(v, n = ceiling(compact.to*lv))
  if(!is.null(round.off)){
    cv <- lapply(cv, round, round.off)
  }
  if(to.data.frame){
    cv <- do.call(cbind, cv)
  }
  return(cv)
}
