#'  Get left channel
#'
#' @description Get left channel from WAV file.
#' @param fromWav A directory/folder containing WAV files.
#' @export
get_left <- function(x){
  return(x@left)
}
