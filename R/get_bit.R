#'  Get bit
#'
#' @description Get bit from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @export
get_bit <- function(x){
  return(x@bit)
}
