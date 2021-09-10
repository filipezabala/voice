#'  Enrich RTTM files
#'
#' @param listRttm A list containing RTTM files.
#' @param silence.gap The silence gap (in seconds) between adjacent words in a keyword. Rows with \code{tdur <= silence.gap} are removed. (default: \code{0.5})
#' @description Enrich Rich Transcription Time Marked (RTTM) files obtained from \code{voice::read_rttm}.
#' @references https://www.nist.gov/system/files/documents/itl/iad/mig/KWS15-evalplan-v05.pdf
#' @seealso \code{voice::read_rttm}
#' @examples
#' library(voice)
#' download.file...
#' @export
enrich_rttm <- function(listRttm, silence.gap = 0.5){
  fltr <- function(x){
    f <- cumsum(x$tdur > silence.gap)
    f[x$tdur <= silence.gap] <- NA
    f <- cbind(f,x)
    return(f)
  }
  rttm <- lapply(listRttm, fltr)
  rttm <- lapply(rttm, function(x){cbind(1:nrow(x), x)})

  colnames <- c('id', 'id.split', 'type', 'file', 'chnl', 'tbeg', 'tdur',
                'ortho', 'stype', 'name', 'conf', 'slat')
  rttm <- lapply(rttm, stats::setNames, colnames)
  return(rttm)
}
