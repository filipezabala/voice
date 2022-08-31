#' Convolute vectors using multicore.
#'
#' @param y A numeric vector, matrix or data frame.
#' @param compact.to Percentage of remaining points after compression. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param drop.zeros Logical. Drop repeated zeros? Default: \code{FALSE}.
#' @param to.data.frame Logical. Convert to data frame? Default: \code{FALSE}.
#' @param round.off Number of decimal places of the convoluted vector. Default: \code{NULL}.
#' @param weight Vector of weights with same length of \code{y}. Default: \code{NULL}.
#' @param mc.cores The number of cores to mclapply. Default: \code{1}.
#' @return A list of x and y convoluted values with length near to \code{compact.to*length(y)}.
#' @importFrom dplyr select
#' @importFrom dplyr %>%
#' @examples
#' library(voice)
#' # Same result of conv() function if x is a vector
#' conv(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
#' conv_mc(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
#'
#' conv(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
#' conv_mc(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' \donttest{
#' # getting all features
#' M <- extract_features(dirname(path2wav), features = c('f0','formants',
#' 'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'),
#' mc.cores = 1, verbose = FALSE)
#'
#' M.num <- M[,-(1:3)]
#' nrow(M.num)
#' cm1 <- conv_mc(M.num, compact.to = 0.1, drop.zeros = TRUE,
#' to.data.frame = FALSE, mc.cores = 1)
#' names(cm1)
#' lapply(cm1$f0, length)
#' }
#' @seealso \code{rm0}, \code{conv}, \code{conv_df}
#' @export
conv_mc <- function(y, compact.to, drop.zeros = FALSE, to.data.frame = FALSE,
                    round.off = NULL, weight = NULL,
                    mc.cores = 1){
  if(is.vector(y)){
    cm <- voice::conv(y, compact.to = compact.to, drop.zeros = drop.zeros,
                      to.data.frame = to.data.frame, round.off = round.off,
                      weight = weight)
  }
  if(is.matrix(y) | is.data.frame(y)){
    cm <- parallel::mclapply(y, voice::conv, compact.to = compact.to,
                             drop.zeros = drop.zeros,
                             to.data.frame = to.data.frame,
                             round.off = round.off, weight = weight,
                             mc.cores = mc.cores)
  }
  return(cm)
}
