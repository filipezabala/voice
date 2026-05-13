#' Interpolate vectors using multicore
#'
#' @param y A numeric vector, matrix or data frame.
#' @param compact.to Proportion of remaining points after compression. If equals to 1 and keep.zeros = TRUE, the original vector is presented.
#' @param drop.zeros Logical. Drop repeated zeros? Default: \code{FALSE}.
#' @param to.data.frame Logical. Convert to data frame? Default: \code{FALSE}.
#' @param round.off Number of decimal places of the interpolated \code{y}. Default: \code{NULL}.
#' @param weight Vector of weights with same length of \code{y}. Default: \code{NULL}.
#' @param mc.cores The number of cores to mclapply. Default: \code{1}.
#' @return A list of x and y convoluted values with length near to \code{compact.to*length(y)}.
#' @importFrom dplyr select
#' @importFrom dplyr %>%
#' @examples
#' library(voice)
#' # Same result of interp() function if x is a vector
#' interp(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
#' interp_mc(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
#'
#' interp(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
#' interp_mc(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#'
#' \donttest{
#' # getting Media data frame
#' M <- voice::extract_features(dirname(path2wav), mc.cores = 1, verbose = FALSE)
#'
#' M.num <- M[,-(1:3)]
#' nrow(M.num)
#' cm1 <- interp_mc(M.num, compact.to = 0.1, drop.zeros = TRUE,
#' to.data.frame = FALSE, mc.cores = 1)
#' names(cm1)
#' lapply(cm1$f0, length)
#' }
#' @seealso \code{rm0}, \code{interp}, \code{interp_df}
#' @export
interp_mc <- function(y, compact.to, drop.zeros = FALSE, to.data.frame = FALSE,
                      round.off = NULL, weight = NULL,
                      mc.cores = 1){
  if(is.vector(y)){
    cm <- voice::interp(y, compact.to = compact.to, drop.zeros = drop.zeros,
                        to.data.frame = to.data.frame, round.off = round.off,
                        weight = weight)
  }
  if(is.matrix(y) | is.data.frame(y)){
    cm <- parallel::mclapply(y, voice::interp, compact.to = compact.to,
                             drop.zeros = drop.zeros,
                             to.data.frame = to.data.frame,
                             round.off = round.off, weight = weight,
                             mc.cores = mc.cores)
  }
  return(cm)
}
