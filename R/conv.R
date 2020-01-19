#' Convolute vectors.
#'
#' @param x A vector or time series.
#' @param compact Percentage of remaining points after compactation. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param drop.zeros Logical. Drop repeated zeros or compress to 1 zero per null set?
#' @return A vector of convoluted values with length near to \code{compact.to*length(x)}.
#' @examples
#' conv(1:100, compact.to = 0.2)
#' (v0 <- c(1:5,rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
#' conv(v0, 0.1)
#' conv(v0, 0.2)
#' conv(v0, 0.5)
#' conv(v0, drop.zeros = F)
#'
#' (v0 <- c(rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
#' conv(v0)
#'
#' (v0 <- c(rep(0,10),1:20, rep(0,4)))
#' conv(v0)
#' plot(v0); points(as.numeric(names(conv(v0))), conv(v0), type = 'l')
#'
#' (v0 <- c(1:10,rep(0,99),1:66, rep(0,2)))
#' conv(v0)
#' conv(v0, 1, T)
#' @seealso \code{rm0}
#' @export

conv <- function(x, compact.to = 0.1, drop.zeros = T){

  lx <- length(x)

  # original vector
  if(compact.to == 1 & !drop.zeros){
    return(x)
  }

  # dropping zeros
  if(drop.zeros){
    v <- rm0(x)
  }

  # not dropping zeros
  if(!drop.zeros){
    v <- x
  }

  lv <- length(v)

  # compacting
  f <- rep(1:ceiling(compact.to*lv), each = 1/compact.to)[1:lv]
  s <- split(v,f)
  m <- lapply(s, median)
  names(m) <- seq(1, max(x), length.out = length(m))
  return(unlist(m))
}
