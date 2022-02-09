#' Tag a data frame with media information.
#'
#' @param x An Extended data frame to be tagged with media information. See details.
#' @param groupBy A variable to group the summary measures. Default: \code{groupBy = 1}, the first column.
#' @param mediaDir Directory containing media files. Currently accepts audio files.
#' @param tags Tags to be added to \code{x}. Default: \code{'feat_summary'}. See details.
#' @param subj.id Column containing the subject ID to be searched in mediaDir file names. Default: \code{NULL}, i.e., uses the first column.
#' @param media.id Column containing the media ID. Default: \code{NULL}, i.e., uses the first column.
#' @param subj.id.simplify Logical. Should subject id must be simplified? Default: \code{FALSE}.
#' @param ... See \code{?voice::extract_features}.
#' @details Except by \code{groupBy} and \code{wavPath}, all the parameters are shared with \code{voice::extract_features} and \code{voice::feat_summary}.
#' @references Zabala, F.J. (2022) to appear in...
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' # Extended dataset
#' E <- tibble(subject_id = c(1,1,1,2,2,2,3,3,3),
#' wav_path = path2wav)
#'
#' tag(E)
#' tag(E, 'subject_id')
#' @export
tag <- function(x,
                groupBy = 'wav_path',
                wavPath = unique(x$wav_path),
                tags = c('feat_summary'),
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

  # voice::feat_summary
  if('feat_summary' %in% tags){
    res <- voice::feat_summary(x = x,
                               groupBy = groupBy,
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

