#' Convolute vectors using multicore.
#'
#' @param \code{y} A numeric vector, matrix or data frame.
#' @param \code{compact.to} Percentage of remaining points after compression. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param \code{drop.zeros} Logical. Drop repeated zeros? Default: \code{'FALSE'}.
#' @param \code{to.data.frame} Logical. Convert to data frame? Default: \code{'FALSE'}.
#' @param \code{round.off} Number of decimal places of the convoluted vector. Default: \code{'NULL'}.
#' @param \code{mc.cores} The number of cores to mclapply. Default: \code{'parallel::detectCores()'}.
#' @return A list of x and y convoluted values with length near to \code{compact.to*length(y)}.
#' @examples
#' library(voice)
#' # Same result of conv() function if x is a vector
#' conv(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
#' conv_mc(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
#'
#' conv(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = T)
#' conv_mc(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = T)
#'
#' dat.num <- dat %>%
#' select(f0:mhs1)
#' nrow(dat.num)
#' cm1 <- conv_mc(dat.num, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
#' names(cm1)
#' lapply(cm1$f0, length)
#' @seealso \code{rm0}, \code{conv}, \code{conv_df}
#' @export
conv_mc <- function(y, compact.to, drop.zeros = F, to.data.frame = F,
                    round.off = NULL, mc.cores = parallel::detectCores()){
  if(is.vector(y)){
    cm <- voice::conv(y, compact.to = compact.to, drop.zeros = drop.zeros,
                      to.data.frame = to.data.frame, round.off = round.off)
  }
  if(is.matrix(y) | is.data.frame(y)){
    cm <- parallel::mclapply(y, voice::conv, compact.to = compact.to,
                             drop.zeros = drop.zeros,
                             to.data.frame = to.data.frame,
                             round.off = round.off, mc.cores = mc.cores)
  }
  return(cm)
}
