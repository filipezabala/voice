#' Cut audio vectors
#'
#' @description Cut vectors
#' @param x A vector containing the feature to be cut by \code{byvar}.
#' @param byvar A vector containing the variable to cut by.
#' @examples
#' library(voice)
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#' # Media dataset
#' M <- extract_features(path2wav)
#' cut_audio(M$f0)
#' cut_audio(M$gain, M$f0)
#' @export
cut_audio <- function(x, byvar = x){
    # 1. NA, https://stackoverflow.com/questions/74674411/split-vector-by-each-na-in-r
    i <- !is.na(byvar)
    splitx <- split(x[i], cumsum(!i)[i])
    return(splitx)
}
