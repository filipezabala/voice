#' Convert SPN to ABC
#'
#' @description Convert SPN to standard octave.
#' @param x A vector containing a note in SPN (Scientific Pitch Notation).
#' @param to_lower Logical. Should the string be lower case? Default: \code{FALSE}.
#' @param spacing Logical. Should the strin return spaces between notes? Default: \code{TRUE}.
#' @examples
#' library(voice)
#' spn2abc('C4')
#' spn2abc('C5')
#' spn2abc('C4', to_lower = TRUE)
#' spn2abc(c('C4','D#7','E2'))
#' spn2abc(c('C4','D#7','E2'), to_lower = TRUE)
#' spn2abc(c('C4','D#7','E2'), spacing = FALSE)
#' spn2abc(c('C4','D#7','E2'), to_lower = TRUE, spacing = FALSE)
#' @references https://en.wikipedia.org/wiki/Scientific_pitch_notation
#'
#' https://en.wikipedia.org/wiki/ABC_notation
#' @export

#TODO: Program drop_rep_seq, #' @param drop_rep_seq Logical. Should sequences of same note be replaced by one single note? Default: \code{FALSE}.
spn2abc <- function(x, to_lower = FALSE, spacing = TRUE){
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
