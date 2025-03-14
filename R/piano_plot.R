#' Piano plot
#'
#' @description Piano plot showing the notes in Scientific Pitch Notation.
#' @param data Data frame or tibble containing the desired frequencies to be plotted.
#' @param num_fmt Number of the desired formant (includes f0 for simplicity). Default: \code{num_fmt = 0}.
#' @examples
#' library(voice)
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#' # Media dataset
#' M <- extract_features(path2wav)
#' piano_plot(M, 0)
#' piano_plot(M, 0:2)
#' @references https://en.wikipedia.org/wiki/12_equal_temperament
#'
#' https://en.wikipedia.org/wiki/Scientific_pitch_notation
#' @export
piano_plot <- function(data, num_fmt = 0){

  # Preparing data
  x <- dplyr::pull(data[,'section_seq_file'])
  fmt_vec <- paste0('f', num_fmt)

  # Dropping first and last NAs
  not_na <- apply(!is.na(data[,fmt_vec]), 2, cumsum)
  beg <- which(rowSums(not_na) != 0)[1]
  wh <- which(rowSums(apply(not_na, 2, diff)) != 0)
  end <- wh[length(wh)]+2

  # Colors by gain/amplitude
  col_gain <- data$gain + abs(min(data$gain, na.rm = TRUE)) + 0.1

  # Non NA
  f0_cut <- voice::cut_audio(data$f0)
  cs_f0 <- cumsum(!is.na(data$f0))
  x_cut <- which(as.logical(diff(cs_f0)))+1
  gain_cut <- voice::cut_audio(data$gain, data$f0)
  df_long <- tibble::tibble(x_cut, f0_cut = unlist(f0_cut), gain_cut = unlist(gain_cut))

  # Base figure
  fig <- ggplot2::ggplot(data, ggplot2::aes(x = x)) +
    ggplot2::xlab('Sample') +
    ggplot2::ylab('Frequency') +
    ggplot2::ggtitle('Frequencies and notes in SPN')

  # Adding f0
  if(sum(num_fmt == 0)){
    fig <- fig +
      ggplot2::geom_line(ggplot2::aes(y = f0, col = col_gain), data = data) +
      # ggplot2::geom_line(ggplot2::aes(y = f0), data = data) +
      # ggplot2::geom_point(ggplot2::aes(color = df_long$gain_cut)) +
      ggplot2::scale_colour_gradient(low = "blue", high = "red") +
      ggplot2::xlim(beg-10, end)
    # fig
  }

  # Add ingf1
  if(sum(num_fmt == 1)){
    fig <- fig +
      ggplot2::geom_line(ggplot2::aes(y = f1, col = col_gain), data = data) +
      ggplot2::scale_colour_gradient(low = "blue", high = "red") +
      ggplot2::xlim(beg-10, end)
  }

  # Adding f2
  if(sum(num_fmt == 2)){
    fig <- fig +
      ggplot2::geom_line(ggplot2::aes(y = f2, col = col_gain), data = data) +
      ggplot2::scale_colour_gradient(low = "blue", high = "red") +
      ggplot2::xlim(beg-10, end)
  }

  # Adding frequency limits
  freqs <- c(voice::notes_freq()$spn.lo,
             voice::notes_freq()$spn.hi[108])
  fltr <- freqs >= min(data[,fmt], na.rm = TRUE) &
    freqs <= max(data[,fmt], na.rm = TRUE)

  fig <- fig +
    ggplot2::geom_hline(yintercept = freqs[fltr], col = 'grey') +
    ggplot2::annotate('text', x = beg-10, y = voice::notes_freq()$freq[fltr],
                      label = voice::notes_freq()$spn[fltr])

  return(fig)
}
