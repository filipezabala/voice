#'  Time duration
#'
#' @description Get time duration from a data frame in RTTM standard.
#' @param x A data frame in RTTM standard. See 'voice::read_rttm'.
#' @return A numeric vector containing the time duration in seconds.
#' @examples
#' library(voice)
#'
#' url0 <- 'https://raw.githubusercontent.com/filipezabala/voiceAudios/main/rttm/sherlock0.rttm'
#' download.file(url0, destfile = paste0(tempdir(), '/sherlock0.rttm'))
#'
#' rttm <- voice::read_rttm(tempdir())
#' (gtd <- voice::get_tdur(rttm$sherlock0.rttm))
#' class(gtd)
#' @export
get_tdur <- function(x){
  return(x$tdur)
}
