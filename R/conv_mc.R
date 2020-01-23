#' Convolute vectors multicore.
#'
#' @param \code{y} A numeric vector, matrix or data frame.
#' @param \code{compact.to} Percentage of remaining points after compactation. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param \code{mc.cores} The number of cores to mclapply.
#' @return A list of x and y convoluted values with length near to \code{compact.to*length(y)}.
#' @examples
#' library(voice)
#' # Same result of conv if x is a vector
#' conv_mc(1:100, compact.to = 0.2, drop.zeros = T)
#' conv(1:100, compact.to = 0.2, drop.zeros = T)
#'
#' library(tidyverse)
#' dat.num <- dat %>%
#' select(f0:mhs1)
#' cm1 <- conv_mc(dat.num, compact.to = 0.1, drop.zeros = T)
#' lapply(cm1$f0, length)
#' @seealso \code{rm0}, \code{conv}, \code{conv_df}
#' @export
conv_mc <- function(y, compact.to, drop.zeros, mc.cores = detectCores()){

  if(is.vector(y)){
    cm <- voice::conv(y, compact.to = compact.to, drop.zeros = drop.zeros)
  }

  if(is.matrix(y) | is.data.frame(y)){
    cm <- mclapply(y, voice::conv, compact.to = compact.to,
                   drop.zeros = drop.zeros, mc.cores = mc.cores)
  }

  return(cm)
}

