#'  Get sample rate
#'
#' @description Get sample rate from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @export
get_samp.rate <- function(x){
  return(x@samp.rate)
}
