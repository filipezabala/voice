#'  Time duration
#'
#' @description Get time duration from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @export
get_dur <- function(x){
  return(length(x@left)/x@samp.rate)
}
