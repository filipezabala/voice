#'  Get sample rate
#'
#' @description Get sample rate from WAV file.
#' @param fromWav A directory/folder containing WAV files.
#' @export
get_samp.rate <- function(x){
  return(x@samp.rate)
}
