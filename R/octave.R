#' Convert SPN to standard octave
#'
#' @description Convert SPN to standard octave.
#' @param x A vector containing a note in SPN (Scientific Pitch Notation).
#' @param to_lower Logical. Should the string be lower case? Default: \code{FALSE}.
#' @param spacing Logical. Should the strin return spaces between notes? Default: \code{TRUE}.
#' @examples
#' library(voice)
#' octave('C4')
#' octave('C5')
#' all.equal(octave('C4'), octave('C4'))
#' octave('C4', to_lower = TRUE)
#' octave(c('C4','D#7','E2'))
#' octave(c('C4','D#7','E2'), to_lower = TRUE)
#' octave(c('C4','D#7','E2'), spacing = FALSE)
#' octave(c('C4','D#7','E2'), to_lower = TRUE, spacing = FALSE)
#' @export
octave <- function(x, to_lower = FALSE, spacing = TRUE){
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
