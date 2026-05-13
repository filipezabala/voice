#' Features summary
#'
#' @description Returns summary measures of 'voice::extract_features'.
#' @param x An Extended data frame to be tagged with media information.
#' @param groupBy A variable to group the summary measures. The argument must be a character vector. (Default: \code{groupBy = 'wav_path'}).
#' @param wavPath A vector containing the path(s) to WAV files. May be both as \code{dirname} or \code{basename} formats.
#' @param wavPathName A string containing the WAV path name. (Default: \code{wavPathName = 'wav_path'}).
#' @param features Vector of features to be extracted. (Default: \code{'f0'}).
#' @param filesRange The desired range of directory files (default: \code{NULL}, i.e., all files). Should only be used when all the WAV files are in the same folder.
#' @param sex \code{= <code>} set sex specific parameters where <code> = \code{'f'}[emale], \code{'m'}[ale] or \code{'u'}[nknown] (Default: \code{'u'}). Used as 'gender' by \code{wrassp::ksvF0}, \code{wrassp::forest} and \code{wrassp::mhsF0}.
#' @param windowShift \code{= <dur>} set analysis window shift to <dur>ation in ms (Default: \code{5.0}). Used by \code{wrassp::ksvF0}, \code{wrassp::forest}, \code{wrassp::mhsF0}, \code{wrassp::zcrana}, \code{wrassp::rfcana}, \code{wrassp::acfana}, \code{wrassp::cepstrum}, \code{wrassp::dftSpectrum}, \code{wrassp::cssSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param numFormants \code{= <num>} <num>ber of formants (Default: \code{8}). Used by \code{wrassp::forest}.
#' @param numcep Number of Mel-frequency cepstral coefficients (cepstra) to return (Default: \code{12}). Used by \code{tuneR::melfcc}.
#' @param dcttype Type of DCT used. \code{'t1'} or \code{'t2'}, \code{'t3'} for HTK \code{'t4'} for feacalc (Default: \code{'t2'}). Used by \code{tuneR::melfcc}.
#' @param fbtype Auditory frequency scale to use: \code{'mel'}, \code{'bark'}, \code{'htkmel'}, \code{'fcmel'} (Default: \code{'mel'}). Used by \code{tuneR::melfcc}.
#' @param resolution \code{= <freq>} set FFT length to the smallest value which results in a frequency resolution of <freq> Hz or better (Default: \code{40.0}). Used by \code{wrassp::cssSpectrum}, \code{wrassp::dftSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param usecmp Logical. Apply equal-loudness weighting and cube-root compression (PLP instead of LPC) (Default: \code{FALSE}). Used by \code{tuneR::melfcc}.
#' @param mc.cores Number of cores to be used in parallel processing. (Default: \code{1})
#' @param full.names Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (Default: \code{TRUE}). Used by \code{base::list.files}.
#' @param recursive Logical. Should the listing recursively into directories? (Default: \code{FALSE}) Used by \code{base::list.files}.
#' @param check.mono Logical. Check if the WAV file is mono. (Default: \code{TRUE})
#' @param stereo2mono (Experimental) Logical. Should files be converted from stereo to mono? (Default: \code{TRUE})
#' @param overwrite (Experimental) Logical. Should converted files be overwritten? If not, the file gets the suffix \code{_mono}. (Default: \code{FALSE})
#' @param freq Frequency in Hz to write the converted files when \code{stereo2mono=TRUE}. (Default: \code{44100})
#' @param round.to Number of decimal places to round to. (Default: \code{NULL})
#' @param verbose Logical. Should the running status be showed? (Default: \code{FALSE})
#' @return A tibble data frame containing summarized numeric columns using (1) mean, (2) standard deviation, (3) variation coefficient, (4) median, (5) interquartile range and (6) median absolute deviation.
#' @details \code{filesRange} should only be used when all the WAV files are in the same folder.
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#'
#' # creating Extended synthetic data
#' E <- dplyr::tibble(subject_id = c(1,1,1,2,2,2,3,3,3),
#' wav_path = path2wav)
#'
#' # minimal usage
#' feat_summary(E)
#'
#' # canonical data
#' feat_summary(E, groupBy = 'subject_id')
#' @export
feat_summary <- function(x,
                         groupBy = 'wav_path',
                         wavPath = unique(x$wav_path),
                         wavPathName = 'wav_path',
                         features = 'f0',
                         filesRange = NULL,
                         sex = 'u',
                         windowShift = 10,
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
                         round.to = 4,
                         verbose = FALSE){

  M <- voice::extract_features(wavPath,
                               filesRange = filesRange,
                               features = features,
                               sex = sex,
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
                               round.to = round.to,
                               verbose = verbose)

  # full vector of features
  featFull <- colnames(M[,-(1:3)])

  # normalizing dirnames @ Media
  M_path_name <- normalizePath(dirname(dplyr::pull(M[, wavPathName])))
  M_base_name <- basename(dplyr::pull(M[, wavPathName]))
  M[, wavPathName] <- paste0(M_path_name, '/', M_base_name)

  # normalizing dirnames @ Extended
  x <- dplyr::as_tibble(x)
  if(utils::file_test('-f', dplyr::pull(x[, wavPathName])[1])){
    x_path_name <- normalizePath(dirname(dplyr::pull(x[, wavPathName])))
    x_base_name <- basename(dplyr::pull(x[, wavPathName]))
    x[, wavPathName] <- paste0(x_path_name, '/', x_base_name)
    M <- dplyr::left_join(M, x, wavPathName)
  } else{
    x[, wavPathName] <- normalizePath(dplyr::pull(x[, wavPathName]))
    wav_path_full <- dir(as.data.frame(x)[, wavPathName], full.names = TRUE)
    x_full <- dplyr::tibble(wav_path = dirname(wav_path_full),
                            wav_path_full = wav_path_full) # generalize wavPathName!
    x_full <- dplyr::left_join(x_full, x, by = 'wav_path')
    x_full <- dplyr::transmute(x_full, subject_id = subject_id, wav_path = wav_path_full)
    M <- dplyr::left_join(M, x_full, wavPathName)
  }

  # Variation Coefficient function
  vc <- function(x, na.rm = TRUE){
    return(stats::sd(x, na.rm = na.rm)/mean(x, na.rm = na.rm))
  }

  # complement of featFull
  compFeatFull <- setdiff(colnames(M), featFull)

  # tyding up
  M <- dplyr::select(M, tidyselect::all_of(compFeatFull), tidyselect::all_of(featFull))
  # dplyr::rename(!!wavPathName := tidyselect::ends_with('.y'))

  # group by
  Mg <- M %>%
    dplyr::group_by(.data[[groupBy]])

  # Mean
  M_mean <- Mg %>%
    dplyr::summarise_at(dplyr::vars(tidyselect::all_of(featFull)), mean, na.rm = TRUE)
  colnames(M_mean)[-1] <- paste0(colnames(M_mean)[-1], '_tag_mean')

  # (Sample) Standard Deviation
  M_sd <- Mg %>%
    dplyr::summarise_at(dplyr::vars(tidyselect::all_of(featFull)), stats::sd, na.rm = TRUE)
  colnames(M_sd)[-1] <- paste0(colnames(M_sd)[-1], '_tag_sd')

  # (Sample) Variation Coefficient
  M_vc <- Mg %>%
    dplyr::summarise_at(dplyr::vars(tidyselect::all_of(featFull)), vc, na.rm = TRUE)
  colnames(M_vc)[-1] <- paste0(colnames(M_vc)[-1], '_tag_vc')

  # Median
  M_median <- Mg %>%
    dplyr::summarise_at(dplyr::vars(tidyselect::all_of(featFull)), stats::median, na.rm = TRUE)
  colnames(M_median)[-1] <- paste0(colnames(M_median)[-1], '_tag_median')

  # InterQuartile Range
  M_iqr <- Mg %>%
    dplyr::summarise_at(dplyr::vars(tidyselect::all_of(featFull)), stats::IQR, na.rm = TRUE)
  colnames(M_iqr)[-1] <- paste0(colnames(M_iqr)[-1], '_tag_iqr')

  # Median Absolute Deviation
  M_mad <- Mg %>%
    dplyr::summarise_at(dplyr::vars(tidyselect::all_of(featFull)), stats::mad, na.rm = TRUE)
  colnames(M_mad)[-1] <- paste0(colnames(M_mad)[-1], '_tag_mad')

  # left_join
  M_summ <- dplyr::left_join(M_mean, M_sd, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_vc, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_median, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_iqr, by = groupBy)
  M_summ <- dplyr::left_join(M_summ, M_mad, by = groupBy)

  return(M_summ)
}
