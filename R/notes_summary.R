#' Returns summary measures of the spoken notes in semitones
#'
#' @param x Either a WAV file or a directory containing WAV files.
#' @param get.id Logical. Should the ID must be extracted from file name? Default: \code{FALSE}.
#' @param i ID position in file name. Default: \code{4}.
#' @export
notes_summary <- function(x, get.id = FALSE, i = 4, recursive = FALSE){
  ef <- voice::extract_features(x, features = 'f0', recursive = TRUE, round.to = 1)
  ef <- voice::id_file(ef, 'file_name', i = 4)
  ef$spn <- voice::notes(ef$F0, measure = 'spn')
  dur <- by(ef$spn, ef$id_file, voice::duration)
  get_note <- function(x){ as.character(x[,'note']) }
  note <- lapply(dur, get_note)
  nd <- lapply(dur, music::noteDistance)
  lapply(nd, summary)
}
