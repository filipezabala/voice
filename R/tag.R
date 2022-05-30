#' Tag a data frame with media information.
#'
#' @param x An Extended data frame to be tagged with media information. See references.
#' @param groupBy A variable to group the summary measures. The argument must be a character vector. Default: \code{groupBy = 'wav_path'}.
#' @param wavPath A vector containing the path(s) to WAV files. May be both as \code{dirname} or \code{basename} formats.
#' @param wavPathName A string containing the WAV path name. Default: \code{wavPathName = 'wav_path'}
#' @param tags Tags to be added to \code{x}. Default: \code{'feat_summary'}. See details.
#' @param sortByGroupBy Logical. Should the function sort the Extended data frame \code{x} by \code{gropuBy}? Default: \code{sortByGroupBy = TRUE}.
#' @param ... See \code{?voice::extract_features}.
#' @details \code{filesRange} should only be used when all the WAV files are in the same folder.
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
#' Et <- tag(E, features = c('f0', 'formants', 'df', 'pf', 'rf', 'rcf', 'rpf'),
#' groupBy = 'subject_id')
#' Et
#' str(Et)
#'
#' # multicore (must not work on Windows)
#' tag(E, mc.cores = parallel::detectCores(), groupBy = 'subject_id')
#' @export
tag <- function(x,
                groupBy = 'wav_path',
                wavPath = unique(x$wav_path),
                wavPathName = 'wav_path',
                tags = c('feat_summary'),
                sortByGroupBy = TRUE,
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
                round.to = 4,
                verbose = TRUE){

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
