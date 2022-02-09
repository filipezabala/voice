#' Returns summary measures of voice::extract_features
#'
#' @param x An Extended data frame to be tagged with media information. See details.
#' @param groupBy A variable to group the summary measures. The argument must be a character vector. Default: \code{groupBy = 'wav_path'}.
#' @details Except by \code{groupBy} and \code{wavPath}, all the parameters are shared with \code{voice::extract_features}.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' # creating Extended synthetic data
#' E <- tibble(subject_id = c(1,1,1,2,2,2,3,3,3),
#' wav_path = path2wav)
#'
#' # minimal usage
#' feat_summary(E)
#'
#' # canonical data
#' feat_summary(E, 'subject_id')
#' @export
feat_summary <- function(x,
                         groupBy = 'wav_path',
                         wavPath = unique(x$wav_path),
                         filesRange = NULL,
                         features = 'f0',
                         gender = 'u',
                         windowShift = 5,
                         numFormants = 8,
                         numcep = 12,
                         dcttype = c('t2', 't1', 't3', 't4'),
                         fbtype = c('mel', 'htkmel', 'fcmel', 'bark'),
                         resolution = 40,
                         usecmp = FALSE,
                         mc.cores = 1,
                         full.names = TRUE,
                         recursive = FALSE,
                         check.mono = TRUE,
                         stereo2mono = TRUE,
                         overwrite = FALSE,
                         freq = 44100,
                         round.to = 4){

  M <- voice::extract_features(wavPath,
                               filesRange = filesRange,
                               features = features,
                               gender = gender,
                               windowShift = windowShift,
                               numFormants = numFormants,
                               numcep = numcep,
                               dcttype = dcttype,
                               fbtype = fbtype,
                               resolution = resolution,
                               usecmp = usecmp,
                               mc.cores = mc.cores,
                               full.names = full.names,
                               recursive = recursive,
                               check.mono = check.mono,
                               stereo2mono = stereo2mono,
                               overwrite = overwrite,
                               freq = freq,
                               round.to = round.to)

  # full vector of features
  # featFull <- colnames(M[,-(1:3)])

  # Variation Coefficient function
  vc <- function(x, na.rm = TRUE){
    return(sd(x, na.rm = na.rm)/mean(x, na.rm = na.rm))
  }

  # left join
  M <- dplyr::left_join(x, M, by = 'wav_path')
  # M <- M %>%
  #   dplyr::select(slice_seq:wav_path, all_of(featFull))

  # group by
  # gb <- dplyr::pull(M[, groupBy])
  Mg <- M %>%
    dplyr::group_by(.data[[groupBy]])

  # Mean
  M_mean <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), mean, na.rm = TRUE)
  colnames(M_mean)[-1] <- paste0(colnames(M_mean)[-1], '_tag_mean')

  # (Sample) Standard Deviation
  M_sd <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), sd, na.rm = TRUE)
  colnames(M_sd)[-1] <- paste0(colnames(M_sd)[-1], '_tag_sd')

  # (Sample) Variation Coefficient
  M_vc <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), vc, na.rm = TRUE)
  colnames(M_vc)[-1] <- paste0(colnames(M_vc)[-1], '_tag_vc')

  # Median
  M_median <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), median, na.rm = TRUE)
  colnames(M_median)[-1] <- paste0(colnames(M_median)[-1], '_tag_median')

  # InterQuartile Range
  M_iqr <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), IQR, na.rm = TRUE)
  colnames(M_iqr)[-1] <- paste0(colnames(M_iqr)[-1], '_tag_iqr')

  # Median Absolute Deviation
  M_mad <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), mad, na.rm = TRUE)
  colnames(M_mad)[-1] <- paste0(colnames(M_mad)[-1], '_tag_mad')

  # left_join
  M_summ <- dplyr::left_join(M_mean, M_sd, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_vc, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_median, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_iqr, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_mad, by = groupBy)

  return(M_summ)
}
