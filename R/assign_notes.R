#' Assign musical notes
#'
#' @description Assign musical notes in Scientific Pitch Notation or other variant. See \code{voice::notes()}. The notes are cut considering f0 to ensure alignment.
#' @param x Media dataset from voice::extract_features().
#' @param fmt Either F0 or formant frequency (in Hz). Default: \code{fmt = 0}.
#' @param min_points Minimum number of points for audio section. Default: \code{min_points = 4}.
#' @param min_percentile Minimum percentile value of gain to be included on the average of \code{fmt}. Default: \code{min_percentile = 0.75}.
#' @param max_na_prop Maximum proportion os NAs on gain sector. Default: \code{max_na_prop = 1}.
#' @importFrom stats median
#' @importFrom stats quantile
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
#' @export
assign_notes <- function(x, fmt = 0, min_points = 4,
                         min_percentile = 0.75, max_na_prop = 1) {

  # writing f0/formant name
  fmt_vec <- paste0('f', fmt)

  # cutting audio by f0 to guarantee same number of notes along f0/formants
  fmt_list <- tryCatch(cut_audio(x[, fmt_vec], x[, 'f0']),
                       error = function(e) stop("Error in voice::cut_audio for formant: ", e$message))
  gain_list <- tryCatch(cut_audio(x[, 'gain'], x[, 'f0']),
                        error = function(e) stop("Error in voice::cut_audio for gain: ", e$message))

  # filtering min_points in f0/formant
  fmt_min_points <- sapply(fmt_list, length)
  valid_points_idx <- fmt_min_points >= min_points
  fmt_list <- fmt_list[valid_points_idx]
  gain_list <- gain_list[valid_points_idx]
  fmt_min_points <- fmt_min_points[valid_points_idx]

  # filtering gain == NA
  gain_na_prop <- sapply(lapply(gain_list, is.na), mean)
  valid_na_idx <- gain_na_prop < max_na_prop
  fmt_list <- fmt_list[valid_na_idx]
  gain_list <- gain_list[valid_na_idx]
  fmt_min_points <- fmt_min_points[valid_na_idx]
  gain_na_prop <- gain_na_prop[valid_na_idx]

  # filtering min_percentile in gain
  gain_min_percentile <- lapply(gain_list, quantile, min_percentile, na.rm = TRUE)
  gain_min_percentile <- gain_min_percentile[fmt_min_points >= min_points]

  # calculating median
  l <- length(gain_list)
  notes12et <- vector('list', length = l)
  for (i in 1:l) {
    fltr_gain <- gain_list[[i]] > gain_min_percentile[[i]]
    notes12et[[i]] <- tryCatch(notes(median(fmt_list[[i]][fltr_gain], na.rm = TRUE)),
                               error = function(e) warning(paste("Error in voice::notes for segment", i, ":", e$message), immediate. = TRUE))
  }

  return(unlist(notes12et))
}
