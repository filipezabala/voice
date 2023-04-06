#'  Enrich RTTM files
#'
#' @description Enrich Rich Transcription Time Marked (RTTM) files obtained from '\code{voice::read_rttm}'.
#' @param listRttm A list containing RTTM files.
#' @param silence.gap The silence gap (in seconds) between adjacent words in a keyword. Rows with \code{tdur <= silence.gap} are removed. (default: \code{0.5})
#' @param as.tibble Logical. Should it return a tibble?
#' @return A list containing either data frames or tibbles obtained from standard RTTM files. See 'voice::read_rttm'.
#' @references \url{https://www.nist.gov/system/files/documents/itl/iad/mig/KWS15-evalplan-v05.pdf}
#' @seealso \code{voice::read_rttm}
#' @examples
#' \donttest{
#' library(voice)
#'
#' url0 <- 'https://raw.githubusercontent.com/filipezabala/voiceAudios/main/rttm/sherlock0.rttm'
#' destfile0 <- paste0(tempdir(), '/sherlock0.rttm')
#' download.file(url0, destfile = destfile0)
#' url1 <- 'https://raw.githubusercontent.com/filipezabala/voiceAudios/main/rttm/sherlock1.rttm'
#' destfile1 <- paste0(tempdir(), '/sherlock1.rttm')
#' download.file(url0, destfile = destfile1)
#'
#' rttm <- voice::read_rttm(dirname(destfile0))
#' (er <- voice::enrich_rttm(rttm))
#' class(er)
#' lapply(er, class)
#' }
#' @export
enrich_rttm <- function(listRttm, silence.gap = 0.5, as.tibble = TRUE){
  fltr <- function(x){
    f <- cumsum(x$tdur > silence.gap)
    f[x$tdur <= silence.gap] <- NA
    f <- cbind(f,x)
    return(f)
  }
  rttm <- lapply(listRttm, fltr)
  rttm <- lapply(rttm, function(x){cbind(1:nrow(x), x)})

  colnames <- c('id', 'id_split', 'type', 'file', 'chnl', 'tbeg', 'tdur',
                'ortho', 'stype', 'name', 'conf', 'slat')
  rttm <- lapply(rttm, stats::setNames, colnames)

  # speakProp <- function(x,y){
  #   sp <- x/y
  # }

  if(as.tibble){
    rttm <- lapply(rttm, dplyr::as_tibble)
  }
  return(rttm)
}
