#' Assign musical notes
#'
#' @description Assign musical notes in Scientific Pitch Notation or other variant. See \code{voice::notes()}. The notes are cut considering f0 to ensure alignment.
#' @param fmt Either F0 or formant frequency (in Hz). Default: \code{fmt = 0}.
#' @param min_points Minimum number of points for audio section. Default: \code{min_points = 4}.
#' @param min_percentile Minimum percentile value of gain to be included on the average of \code{fmt}. Default: \code{min_percentile = 0.75}.
#' @param max_na_prop Maximum proportion os NAs on gain sector. Default: \code{max_na_prop = 1}.
#' @examples
#' library(voice)
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#' # Media dataset
#' M <- extract_features(path2wav)
#' assign_notes(M, fmt = 0) # f0
#' assign_notes(M, fmt = 1) # f1
#' assign_notes(M, fmt = 2) # f2
assign_notes <- function(x, fmt = 0,
                         min_points = 4,
                         min_percentile = 0.75,
                         max_na_prop = 1){
  # writing f0/formant name
  fmt_vec <- paste0('f', fmt)

  # cutting audio by f0 to garantee same number of notes along f0/formants
  fmt_list <- voice::cut_audio(x[,fmt_vec], x[,'f0'])
  gain_list <- voice::cut_audio(x[,'gain'], x[,'f0'])

  # filtering min_points in f0/formant
  fmt_min_points <- sapply(fmt_list, length)
  fmt_list <- fmt_list[fmt_min_points >= min_points]
  gain_list <- gain_list[fmt_min_points >= min_points]
  fmt_min_points <- fmt_min_points[fmt_min_points >= min_points]

  # filtering gain == NA
  gain_na_prop <- sapply(lapply(gain_list, is.na), mean)
  fmt_list <- fmt_list[gain_na_prop < max_na_prop]
  gain_list <- gain_list[gain_na_prop < max_na_prop]
  fmt_min_points <- fmt_min_points[gain_na_prop < max_na_prop]
  gain_na_prop <- gain_na_prop[gain_na_prop < max_na_prop]

  # filtering min_percentile in gain
  gain_min_percentile <- lapply(gain_list, quantile, min_percentile, na.rm = TRUE)
  gain_min_percentile <- gain_min_percentile[fmt_min_points >= min_points]

  # calculating median
  l <- length(gain_list)
  notes12et <- vector('list', length = l)
  for(i in 1:l){
    fltr_gain <- gain_list[[i]] > gain_min_percentile[[i]]
    notes12et[[i]] <- voice::notes(median(fmt_list[[i]][fltr_gain], na.rm = TRUE))
  }

  return(unlist(notes12et))
}
