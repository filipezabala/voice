#' Returns summary measures of voice::extract_features
#'
#' @param x An Extended data frame to be tagged with media information. See references.
#' @param groupBy A variable to group the summary measures. The argument must be a character vector. Default: \code{groupBy = 'wav_path'}.
#' @param wavPath A vector containing the path(s) to WAV files. May be both as \code{dirname} or \code{basename} formats.
#' @param wavPathName A string containing the WAV path name. Default: \code{wavPathName = 'wav_path'}
#' @param tags Tags to be added to \code{x}. Default: \code{'feat_summary'}. See details.
#' @param ... See \code{?voice::extract_features}.
#' @references Zabala, F.J. (2022) to appear in...
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' # creating Extended synthetic data
#' E <- dplyr::tibble(subject_id = c(1,1,1,2,2,2,3,3,3),
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
                         wavPathName = 'wav_path',
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
                         check.mono = FALSE,
                         stereo2mono = FALSE,
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

  # normalizing dirnames
  if(file_test('-f', dplyr::pull(M[, wavPathName])[1])){
    M[,wavPathName] <- normalizePath(dirname(dplyr::pull(M[, wavPathName])))
  } else{
    M[,wavPathName] <- normalizePath(dplyr::pull(M[, wavPathName]))
  }

  x <- dplyr::as_tibble(x)
  if(file_test('-f', dplyr::pull(x[, wavPathName])[1])){
    x[,wavPathName] <- normalizePath(dirname(dplyr::pull(x[, wavPathName])))
  } else{
    x[,wavPathName] <- normalizePath(dplyr::pull(x[, wavPathName]))
  }

  # full vector of features
  featFull <- colnames(M[,-(1:3)])

  # Variation Coefficient function
  vc <- function(x, na.rm = TRUE){
    return(sd(x, na.rm = na.rm)/mean(x, na.rm = na.rm))
  }

  # left join
  M <- dplyr::left_join(M, x, by = wavPathName)
  # cn <- wavPathName
  # M <- M %>%
  #   dplyr::select(slice_seq:slice_seq_file, tidyselect::all_of(featFull)) %>%
    # dplyr::rename(!!wavPathName := tidyselect::ends_with('.y'))

  # group by
  Mg <- M %>%
    dplyr::group_by(.data[[groupBy]])

  # Mean
  M_mean <- Mg %>%
    dplyr::summarise_at(dplyr::vars(all_of(featFull)), mean, na.rm = TRUE)
  colnames(M_mean)[-1] <- paste0(colnames(M_mean)[-1], '_tag_mean')

  # (Sample) Standard Deviation
  M_sd <- Mg %>%
    dplyr::summarise_at(dplyr::vars(all_of(featFull)), sd, na.rm = TRUE)
  colnames(M_sd)[-1] <- paste0(colnames(M_sd)[-1], '_tag_sd')

  # (Sample) Variation Coefficient
  M_vc <- Mg %>%
    dplyr::summarise_at(dplyr::vars(all_of(featFull)), vc, na.rm = TRUE)
  colnames(M_vc)[-1] <- paste0(colnames(M_vc)[-1], '_tag_vc')

  # Median
  M_median <- Mg %>%
    dplyr::summarise_at(dplyr::vars(all_of(featFull)), median, na.rm = TRUE)
  colnames(M_median)[-1] <- paste0(colnames(M_median)[-1], '_tag_median')

  # InterQuartile Range
  M_iqr <- Mg %>%
    dplyr::summarise_at(dplyr::vars(all_of(featFull)), IQR, na.rm = TRUE)
  colnames(M_iqr)[-1] <- paste0(colnames(M_iqr)[-1], '_tag_iqr')

  # Median Absolute Deviation
  M_mad <- Mg %>%
    dplyr::summarise_at(dplyr::vars(all_of(featFull)), mad, na.rm = TRUE)
  colnames(M_mad)[-1] <- paste0(colnames(M_mad)[-1], '_tag_mad')

  # left_join
  M_summ <- dplyr::left_join(M_mean, M_sd, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_vc, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_median, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_iqr, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_mad, by = groupBy)

  return(M_summ)
}
