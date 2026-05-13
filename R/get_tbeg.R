#'  Time beginning
#'
#' @description Get time beginning from a data frame in RTTM standard.
#' @param x A data frame in RTTM standard. See 'voice::read_rttm'.
#' @return Numeric vector containing the time beginning in seconds.
#' @examples
#' library(voice)
#'
#' url0 <- 'https://raw.githubusercontent.com/filipezabala/voiceAudios/main/rttm/sherlock0.rttm'
#' download.file(url0, destfile = paste0(tempdir(), '/sherlock0.rttm'))
#'
#' rttm <- voice::read_rttm(tempdir())
#' (gtb <- voice::get_tbeg(rttm$sherlock0.rttm))
#' class(gtb)
#' @export
get_tbeg <- function(x){
  return(x$tbeg)
}
