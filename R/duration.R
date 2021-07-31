#' Gives the duration of sequences in number of lines and miliseconds.
#' @param x A vector containing symbols and \code{NA}.
#' @param windowShift \code{= <dur>} set analysis window shift to <dur>ation in ms (default: 5.0).
#' @return A tibble with frequencies for equal-tempered scale, A4 = 440 Hz.
#' @examples
#' library(voice)
#' duration(letters)
#' duration(c('a','a','a',letters,'z'))
#'
#' nts <- c('NA','NA','A3','A3','A3','A3','A#3','B3','B3','C4','C4','C4','C4','
#' C4','C4','C#4','C4','C4','C4','B3','A#3','NA','NA','NA','NA','NA','NA','NA',
#' 'NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','D4','D4','D4','C#4',
#' 'C#4','C#4','C4','C4','B3','B3','A#3','A#3','A3','A3','G3','G#3','G3','F#3',
#' 'F#3','G3','NA','F#3','F#3','F#3','F#3','F#3','G3','F#3','F#3','F#3','F#3',
#' 'F3','F3','F3','F3','E3','E3','E3','D#3','D#3','D#3','D#3','D#3','D3','D3',
#' 'D#3','D#3','D#3','D#3','D#3','D3','D#3','D3','D3','D3','D#3','D3','D#3','D#3',
#' 'D#3','D#3')
#' duration(nts)
#' @export
duration <- function(x, windowShift = 5){
  if(sum(is.na(x))){
    x <- factor(x, levels = c(levels(x), NA), exclude = NULL)
  }
  n <- length(x)
  m <- match(x,x)
  d <- diff(m)
  dur_line <- as.numeric(table(cumsum(abs(d))))

  if(x[1] != x[2]){
    dur_line <- c(1, dur_line)
  } else {
    dur_line[1] <- dur_line[1]+1
    }

  pos <- m[d != 0]
  if(sum(d == 0)){
    pos <- c(pos, n)
  }

  dur_ms <- dur_line*windowShift
  dur <- data.frame(note = x[pos], dur_line = dur_line, dur_ms = dur_ms)
  return(dur)
}
