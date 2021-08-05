#' Gives the duration of sequences.
#' @param x A vector containing symbols and \code{NA}.
#' @param windowShift Window shift to duration in ms (default: 5.0).
#' @return A data frame with duration in number of lines/ocurrences (\code{dur_line}), milliseconds (\code{dur_ms}) and proportional (\code{dur_prop}).
#' @examples
#' library(voice)
#' duration(letters)
#' duration(c('a','a','a',letters,'z'))
#'
#' nts <- c('NA','NA','A3','A3','A3','A3','A#3','B3','B3','C4','C4','C4','C4',
#' 'C4','C4','C#4','C4','C4','C4','B3','A#3','NA','NA','NA','NA','NA','NA','NA',
#' 'NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','D4','D4','D4','C#4',
#' 'C#4','C#4','C4','C4','B3','B3','A#3','A#3','A3','A3','G3','G#3','G3','F#3')
#' duration(nts)
#' @export
duration <- function(x, windowShift = 5){
  if(!is.factor(x)){
    x <- factor(x, levels = unique(x))
  }
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
  if(d[1] == 0){
    pos <- c(pos, n)
  }

  note <- factor(x[pos], levels = levels(x))
  dur_ms <- dur_line*windowShift
  dur_prop <- dur_line/sum(dur_line)
  dur <- data.frame(note = note, dur_line = dur_line,
                    dur_ms = dur_ms, dur_prop = dur_prop)

  return(dur)
}
