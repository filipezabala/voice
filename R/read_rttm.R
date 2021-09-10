#'  Read RTTM files
#'
#' @description Read Rich Transcription Time Marked (RTTM) files in \code{fromRttm} directory.
#' @param fromRttm A directory/folder containing RTTM files.
#' @details The Rich Transcription Time Marked (RTTM) files are space-delimited text files containing one turn per line defined National Institute of Standards and Technology. Each line containing ten fields: '\n'
#' \code{type} Type: segment type; should always by SPEAKER. '\n'
#' \code{file} File ID: file name; basename of the recording minus extension (e.g., rec1_a). '\n'
#' \code{chnl} Channel ID: channel (1-indexed) that turn is on; should always be 1. '\n'
#' \code{tbeg} Turn Onset -- onset of turn in seconds from beginning of recording. '\n'
#' \code{tdur} Turn Duration -- duration of turn in seconds.'\n'
#' \code{ortho} Orthography Field -- should always by <NA>.'\n'
#' \code{stype} Speaker Type -- should always be <NA>.'\n'
#' \code{name} Speaker Name -- name of speaker of turn; should be unique within scope of each file.'\n'
#' \code{conf} Confidence Score -- system confidence (probability) that information is correct; should always be <NA>.'\n'
#' \code{slat} Signal Lookahead Time -- should always be <NA>.'\n'
#' @references https://www.nist.gov/system/files/documents/itl/iad/mig/KWS15-evalplan-v05.pdf
#' @seealso \code{voice::enrich_rttm}
#' @examples
#' library(voice)
#' download.file...
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
    return(rttm)
  }
}
