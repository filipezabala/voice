#' Tag a data frame with media information
#'
#' @param x An Extended data frame to be tagged with media information. See references.
#' @param groupBy A variable to group the summary measures. The argument must be a character vector. (Default: \code{groupBy = 'wav_path'}).
#' @param wavPath A vector containing the path(s) to WAV files. May be both as \code{dirname} or \code{basename} formats.
#' @param wavPathName A string containing the WAV path name. (Default: \code{wavPathName = 'wav_path'}).
#' @param tags Tags to be added to \code{x}. See Details. (Default: \code{'feat_summary'}).
#' @param sortByGroupBy Logical. Should the function sort the Extended data frame \code{x} by \code{gropuBy}? (Default: \code{sortByGroupBy = TRUE}).
#' @param filesRange The desired range of directory files. Should only be used when all the WAV files are in the same folder. (Default: \code{NULL}, i.e., all files).
#' @param features Vector of features to be extracted. (Default: \code{'f0'}).
#' @param sex \code{= <code>} set sex specific parameters where <code> = \code{'f'}[emale], \code{'m'}[ale] or \code{'u'}[nknown] (default: \code{'u'}). Used as 'gender' by \code{wrassp::ksvF0}, \code{wrassp::forest} and \code{wrassp::mhsF0}.
#' @param windowShift \code{= <dur>} set analysis window shift to <dur>ation in ms (default: 5.0). Used by \code{wrassp::ksvF0}, \code{wrassp::forest}, \code{wrassp::mhsF0}, \code{wrassp::zcrana}, \code{wrassp::rfcana}, \code{wrassp::acfana}, \code{wrassp::cepstrum}, \code{wrassp::dftSpectrum}, \code{wrassp::cssSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param numFormants \code{= <num>} <num>ber of formants (Default: \code{8}). Used by \code{wrassp::forest}.
#' @param numcep Number of Mel-frequency cepstral coefficients (cepstra) to return (Default: \code{12}). Used by \code{tuneR::melfcc}.
#' @param dcttype Type of DCT used. \code{'t1'} or \code{'t2'}, \code{'t3'} for HTK \code{'t4'} for feacalc (Default: \code{'t2'}). Used by \code{tuneR::melfcc}.
#' @param fbtype Auditory frequency scale to use: \code{'mel'}, \code{'bark'}, \code{'htkmel'}, \code{'fcmel'} (Default: \code{'mel'}). Used by \code{tuneR::melfcc}.
#' @param resolution \code{= <freq>} set FFT length to the smallest value which results in a frequency resolution of <freq> Hz or better (Default: \code{40.0}). Used by \code{wrassp::cssSpectrum}, \code{wrassp::dftSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param usecmp Logical. Apply equal-loudness weighting and cube-root compression (PLP instead of LPC) (Default: \code{FALSE}). Used by \code{tuneR::melfcc}.
#' @param mc.cores Number of cores to be used in parallel processing. (Default: \code{1})
#' @param full.names Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (Default: \code{TRUE}) Used by \code{base::list.files}.
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
#' E
#'
#' # minimal usage
#' tag(E)
#'
#' # canonical data
#' tag(E, groupBy = 'subject_id')
#'
#' # limiting filesRange
#' tag(E, filesRange = 3:6)
#'
#' # more features
#' Et <- tag(E, features = c('f0', 'fmt', 'rf', 'rcf', 'rpf', 'rfc', 'mfcc'),
#' groupBy = 'subject_id')
#' Et
#' str(Et)
#' @export
tag <- function(x,
                groupBy = 'wav_path',
                wavPath = unique(x$wav_path),
                wavPathName = 'wav_path',
                tags = c('feat_summary'),
                sortByGroupBy = TRUE,
                filesRange = NULL,
                features = 'f0',
                sex = 'u',
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
                round.to = 4,
                verbose = FALSE){

  # sort by groupBy
  if(sortByGroupBy){
    x <- dplyr::arrange(x, groupBy)
  }

  # voice::feat_summary
  if('feat_summary' %in% tags){
    res <- voice::feat_summary(x = x,
                               groupBy = groupBy,
                               wavPath = wavPath,
                               wavPathName = wavPathName,
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
  }

  # # voice::audio_time
  # if('audio_time' %in% tags){
  #   at <- voice::audio_time(wavPath, filesRange = filesRange,
  #                           recursive = recursive)
  #   if(exists('res')){
  #     res <- dplyr::left_join(res, at, by = groupBy)
  #   } else {
  #     res <- at
  #   }
  # }

  # # voice::spoken_prop
  # st <- spoken_time(wavPath, get.id = TRUE, recursive = TRUE)
  # x <- left_join(x, st, by = 'filename')
  # x <- mutate(x, tag_spoken_prop = tag_spoken_time/tag_audio_time)
  #
  #
  # # voice::notes_summary
  # notes_summary(wavPath, get.id = TRUE, i = i)

  return(res)
}
