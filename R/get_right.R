#'  Get right channel
#'
#' @description Get right channel from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @export
get_right <- function(x){
  return(x@right)
}
