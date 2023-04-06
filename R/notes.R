#' Assign notes to frequencies
#'
#' @description Returns a vector of notes for equal-tempered scale, A4 = 440 Hz.
#' @param x Numeric vector of frequencies in Hz.
#' @param method Method of specifying musical pitch. (Default: \code{spn}, i.e., Scientific Pitch Notation).
#' @param moving.average Logical. Must apply moving average? (Default: \code{FALSE}).
#' @param k Integer width of the rolling window used if moving.average is TRUE. (Default: \code{11}).
#' @return A vector containing the notes for equal-tempered scale, A4 = 440 Hz. When `method = 'spn'` the vector is of class 'ordered factor'. When `method = 'octave'` the vector is of class 'factor'.  When `method = 'midi'` the vector is of class 'integer'.
#' @details The symbol '#' is being used to represent a sharp note, the higher
#' in pitch by one semitone on Scientific Pitch Notation (SPN).
#' @references \url{https://pages.mtu.edu/~suits/notefreqs.html}
#' @seealso \code{notes_freq}
#' @examples
#' library(voice)
#' notes(c(220,440,880))
#' notes(c(220,440,880), method = 'octave')
#' notes(c(220,440,880), method = 'midi')
#' @export
notes <- function(x, method = 'spn', moving.average = FALSE, k = 11){
  if(moving.average){
    x <- zoo::rollmean(x, k)
  }
  x <- as.matrix(x)
  freq <- voice::notes_freq()$freq
  distance <- diff(freq)
  lf <- length(freq)
  freqhalf <- c(freq[1] - distance[1]/2,
                freq[-lf] + distance/2,
                freq[lf]+distance[lf-1]/2)
  spn <- voice::notes_freq()$spn[findInterval(x, freqhalf)]
  if(method == 'spn'){
    return(spn)
  } else if(method == 'midi'){
    midi <- voice::notes_freq()$midi[match(spn, voice::notes_freq()$spn)]
    return(midi)
  } else if(method == 'octave'){
    lev <- c('C','C#','D','D#','E','F','F#','G','G#','A','A#','B')
    octa <- base::strsplit(as.character(spn), '[0-9]')
    octa <- factor(unlist(octa), levels = lev)
    return(octa)
  } else if(method == 'black'){
    black <- notes_freq()$black[match(spn, voice::notes_freq()$spn)]
    return(black)
  } else if(method == 'Black'){
    Black <- notes_freq()$Black[match(spn, voice::notes_freq()$spn)]
    return(Black)
  }
}
