#' Returns a vector of notes for equal-tempered scale, A4 = 440 Hz.
#' @param x A vector of frequencies in Hz.
#' @param method Method of specifying musical pitch. (default: \code{spn}, i.e., Scientific Pitch Notation).
#' @details The symbol '#' is being used to represent a sharp note, the higher
#' in pitch by one semitone on Scientific Pitch Notation (SPN)
#' @references https://pages.mtu.edu/~suits/notefreqs.html
#' @seealso \code{notes_freq}
#' @examples
#' library(voice)
#' notes(c(220,440,880))
#' notes(c(220,440,880), method = 'octave')
#' @export
notes <- function(x, method = 'spn'){
  x <- as.matrix(x)
  freq <- voice::notes_freq()$frequency
  freqhalf <- c(freq[1], freq + c(diff(freq)/2,0))
  note <- voice::notes_freq()$spn[findInterval(x, freqhalf)]
  if(method == 'spn'){
    return(note)
  } else if(method == 'midi'){
    midi <- voice::notes_freq()$midi[match(note, voice::notes_freq()$spn)]
    return(midi)
  } else if(method == 'octave'){
    lev <- c('C','C#','D','D#','E','F','F#','G','G#','A','A#','B')
    octa <- base::strsplit(as.character(note), '[0-9]')
    octa <- factor(unlist(octa), levels = lev)
    return(octa)
  }
}
