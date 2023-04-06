#' Read RTTM files
#'
#' @description Read Rich Transcription Time Marked (RTTM) files in \code{fromRttm} directory.
#' @param fromRttm A directory/folder containing RTTM files.
#' @return A list containing data frames obtained from standard RTTM files. See 'Details'.
#' @details The Rich Transcription Time Marked (RTTM) files are space-delimited text files containing one turn per line defined by NIST - National Institute of Standards and Technology. Each line containing ten fields:
#'
#' \code{type} Type: segment type; should always by SPEAKER.
#'
#' \code{file} File ID: file name; basename of the recording minus extension (e.g., rec1_a).
#'
#' \code{chnl} Channel ID: channel (1-indexed) that turn is on; should always be 1.
#'
#' \code{tbeg} Turn Onset -- onset of turn in seconds from beginning of recording.
#'
#' \code{tdur} Turn Duration -- duration of turn in seconds.
#'
#' \code{ortho} Orthography Field -- should always by <NA>.
#'
#' \code{stype} Speaker Type -- should always be <NA>.
#'
#' \code{name} Speaker Name -- name of speaker of turn; should be unique within scope of each file.
#'
#' \code{conf} Confidence Score -- system confidence (probability) that information is correct; should always be <NA>.
#'
#' \code{slat} Signal Lookahead Time -- should always be <NA>.
#' @references \url{https://www.nist.gov/system/files/documents/itl/iad/mig/KWS15-evalplan-v05.pdf}
#' @seealso \code{voice::enrich_rttm}
#' @examples
#' library(voice)
#'
#' url0 <- 'https://raw.githubusercontent.com/filipezabala/voiceAudios/main/rttm/sherlock0.rttm'
#' download.file(url0, destfile = paste0(tempdir(), '/sherlock0.rttm'))
#' url1 <- 'https://raw.githubusercontent.com/filipezabala/voiceAudios/main/rttm/sherlock1.rttm'
#' download.file(url0, destfile = paste0(tempdir(), '/sherlock1.rttm'))
#'
#' (rttm <- voice::read_rttm(tempdir()))
#' class(rttm)
#' lapply(rttm, class)
#' @export
read_rttm <- function(fromRttm){
  rttmFiles <- list.files(fromRttm, pattern = "[[:punct:]][rR][tT][tT][mM]$",
                          full.names = TRUE)
  if(length(rttmFiles)==0){
    cat('EMPTY DIRECTORY?')
  } else{
    rttm <- lapply(rttmFiles, utils::read.table)
    colnames <- c('type', 'file', 'chnl', 'tbeg', 'tdur',
                  'ortho', 'stype', 'name', 'conf', 'slat')
    rttm <- lapply(rttm, stats::setNames, colnames)
    names(rttm) <- basename(rttmFiles)

    return(rttm)
  }
}
