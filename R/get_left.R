#'  Get left channel
#'
#' @description Get left channel from WAV file.
#' @param x Wave object from `tuneR::readWave`.
#' @export
get_left <- function(x){
  return(x@left)
}
