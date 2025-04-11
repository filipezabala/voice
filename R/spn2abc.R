#' Convert SPN to ABC
#'
#' @description Convert SPN to standard octave.
#' @param x A vector containing a note in SPN (Scientific Pitch Notation).
#' @param to_lower Logical. Should the string be lower case? Default: \code{FALSE}.
#' @param spacing Logical. Should the strin return spaces between notes? Default: \code{TRUE}.
#' @param drop_rep_seq Logical. Should sequences of same note be replaced by one single note? Default: \code{FALSE}.
#' @examples
#' library(voice)
#' spn2octave('C4')
#' spn2octave('C5')
#' all.equal(octave('C4'), spn2octave('C4'))
#' spn2octave('C4', to_lower = TRUE)
#' spn2octave(c('C4','D#7','E2'))
#' spn2octave(c('C4','D#7','E2'), to_lower = TRUE)
#' spn2octave(c('C4','D#7','E2'), spacing = FALSE)
#' spn2octave(c('C4','D#7','E2'), to_lower = TRUE, spacing = FALSE)
#' @references https://en.wikipedia.org/wiki/Scientific_pitch_notation
#'
#' ://en.wikipedia.org/wiki/ABC_notation
#' @export

spn2abc <- function(x, to_lower = FALSE, spacing = TRUE){ #TODO: Program drop_rep_seq
  freqs <- c(voice::notes_freq()$spn.lo, voice::notes_freq()$spn.hi[108])
  lev <- c('C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B')
  octa <- base::strsplit(as.character(x), '[0-9]')
  if(to_lower){
    octa <- factor(unlist(tolower(octa)), levels = tolower(lev))
    if(spacing){
      return(octa)
    } else{
      return(paste0(octa, collapse = ''))
    }
  } else{
    octa <- factor(unlist(octa), levels = lev)
    if(spacing){
      return(octa)
    } else{
      return(paste0(octa, collapse = ''))
    }
  }
}
