#' Piano plot
#'
#' @description Piano plot showing the notes in Scientific Pitch Notation.
#' @param dat Data frame or tibble containing the desired frequencies to be plotted.
#' @param num_fmt Number of the desired formant (includes f0 for simplicity). Default: \code{num_fmt = 0}.
#' @param log_freq Logical. Must plot log(frequency)?
#' @param base Logarithm base. Default: \code{exp(1)}.
#' @param color Must the graph be colored overall or by slice? Default: \code{slice}.
#' @examples
#' library(voice)
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#' # Media dataset
#' M <- extract_features(path2wav[1])
#' piano_plot(M, 0)
#' piano_plot(M, 0, color = 'overall')
#' @references https://en.wikipedia.org/wiki/12_equal_temperament
#'
#' https://en.wikipedia.org/wiki/Scientific_pitch_notation
#' @export
piano_plot <- function(dat,
                       num_fmt = 0,
                       log_freq = TRUE,
                       base = exp(1),
                       color = 'slice'){

  # Apply log
  if(log_freq == TRUE){
    lg <- function(x){
      l <- log(x, base = base)
      return(l)
    }
    dat <- dat %>%
      dplyr::mutate(dplyr::across(dplyr::starts_with("f"), lg))
  }

  # Preparing data
  x <- dplyr::pull(dat[,'section_seq_file'])
  fmt_vec <- paste0('f', num_fmt)

  # Dropping first and last NAs
  not_na <- !is.na(dat[,fmt_vec])
  not_na_cum <- apply(not_na, 2, cumsum)
  beg <- which(rowSums(not_na_cum) != 0)[1]
  wh <- which(rowSums(apply(not_na_cum, 2, diff)) != 0)
  end <- wh[length(wh)]+2

  # Non NA
  f0_cut <- voice::cut_audio(dat$f0)
  cs_f0 <- cumsum(!is.na(dat$f0))
  x_cut <- which(as.logical(diff(cs_f0)))+1
  gain_cut <- voice::cut_audio(dat$gain, dat$f0)
  df_long <- tibble::tibble(x_cut, f0_cut = unlist(f0_cut), gain_cut = unlist(gain_cut))

  # gain_color function
  gain_color <- function(x){
    r <- x + abs(min(x, na.rm = TRUE)) + 0.1
    r <- scale(r)
    return(r)
  }
  # Colors by gain/amplitude (overall)
  if(color == 'overall'){
    col_gain <- gain_color(dat$gain)
    # col_gain <- dat$gain + abs(min(dat$gain, na.rm = TRUE)) + 0.1
  }
  # Colors by gain/amplitude (using gain_cut)
  if(color == 'slice'){
    col_gain <- dat$gain
    col_gain[!not_na] <- 0
    col_gain[not_na] <- unlist(lapply(gain_cut, gain_color))
  }

  freqs_lab <- 'Frequency'
  if(log_freq == TRUE){
    freqs_lab <- 'log Frequency'
  }
  # Background figure
  fig <- ggplot2::ggplot(dat, ggplot2::aes(x = x)) +
    ggplot2::xlab('Sample') +
    ggplot2::ylab(freqs_lab) +
    ggplot2::ggtitle(paste0(freqs_lab, ' and notes in SPN'))

  # Adding f0
  if(sum(num_fmt == 0)){
    fig <- fig +
      ggplot2::geom_line(ggplot2::aes(y = .data$f0, col = col_gain), data = dat) +
      # ggplot2::geom_line(ggplot2::aes(y = f0), data = dat) +
      # ggplot2::geom_point(ggplot2::aes(color = df_long$gain_cut)) +
      ggplot2::scale_colour_gradient(low = "blue", high = "red") +
      ggplot2::xlim(beg-10, end)
    # fig
  }

  # Add ingf1
  if(sum(num_fmt == 1)){
    fig <- fig +
      ggplot2::geom_line(ggplot2::aes(y = .data$f1, col = col_gain), data = dat) +
      ggplot2::scale_colour_gradient(low = "blue", high = "red") +
      ggplot2::xlim(beg-10, end)
  }

  # Adding f2
  if(sum(num_fmt == 2)){
    fig <- fig +
      ggplot2::geom_line(ggplot2::aes(y = .data$f2, col = col_gain), data = dat) +
      ggplot2::scale_colour_gradient(low = "blue", high = "red") +
      ggplot2::xlim(beg-10, end)
  }

  # Adding frequency limits
  freqs <- c(voice::notes_freq()$spn.lo,
             voice::notes_freq()$spn.hi[108])
  if(log_freq == TRUE){
    freqs <- log(freqs, base = base)
  }
  fltr <- freqs >= min(dat[,fmt_vec], na.rm = TRUE) &
    freqs <= max(dat[,fmt_vec], na.rm = TRUE)

  fig <- fig +
    ggplot2::geom_hline(yintercept = freqs[fltr], col = 'grey') +
    ggplot2::annotate('text', x = beg-10,
                      y = log(voice::notes_freq()$freq[fltr], base=base),
                      label = voice::notes_freq()$spn[fltr])

  return(fig)
}
