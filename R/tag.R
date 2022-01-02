#' Tag a data frame with media information.
#'
#' @param x An Extended data frame to be tagged with media information. See details.
#' @param mediaDir Directory containing media files. Currently accepts audio files.
#' @param tags Tags to be added to \code{x}. Default: \code{'feat_summary'}. See details.
#' @param subj.id Column containing the subject ID to be searched in mediaDir file names. Default: \code{NULL}, i.e., uses the first column.
#' @param media.id Column containing the media ID. Default: \code{NULL}, i.e., uses the first column.
#' @param subj.id.simplify Logical. Should subject id must be simplified? Default: \code{FALSE}.
#' @param ... See \code{?voice::extract_features}.
#' @details Parameter \code{tags} admits c('feat_summary', 'audio_time'). An Extended data frame E must contain subject and media data. See references.
#' @references Zabala (2022) to appear in...
#' @export
tag <- function(x, mediaDir,
                tags = c('feat_summary'),
                subj.id = NULL,
                media.id = NULL,
                subj.id.simplify = FALSE,
                filesRange = NULL,
                features = c('f0'),
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

  # checking subj.id
  if(is.null(subj.id)){
    subj.id <- 1
  }

  # checking media.id
  if(is.null(media.id)){
    media.id <- 2
  }

  # filename without extension (analyze df>tbl>df. strsplit via tidyverse?)
  x <- as.data.frame(x)
  ss <- unlist(strsplit(x[,media.id], '.[Mm][Pp]3$|.[Ww][Aa][Vv]$'))
  x <- dplyr::bind_cols(x, file_name = ss)
  x <- dplyr::as_tibble(x)

  # subj.id.simplify
  if(subj.id.simplify){
    x[,subj.id] <- as.character(cumsum(!duplicated(x[,subj.id])))
  }

  # voice::feat_summary
  if('feat_summary' %in% tags){
    fs <- voice::feat_summary(mediaDir, mc.cores = mc.cores,
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
                              full.names = full.names,
                              recursive = recursive,
                              check.mono = check.mono,
                              stereo2mono = stereo2mono,
                              overwrite = overwrite,
                              freq = freq,
                              round.to = round.to)
    x <- dplyr::left_join(x, fs, by = 'file_name')
  }

  # voice::audio_time
  if('audio_time' %in% tags){
    at <- voice::audio_time(mediaDir, filesRange = filesRange,
                            recursive = recursive)
    x <- dplyr::left_join(x, at, by = 'file_name')
  }

  return(x)

  # # voice::spoken_prop
  # st <- spoken_time(mediaDir, get.id = TRUE, recursive = TRUE)
  # x <- left_join(x, st, by = 'filename')
  # x <- mutate(x, tag_spoken_prop = tag_spoken_time/tag_audio_time)
  #
  #
  # # voice::notes_summary
  # notes_summary(mediaDir, get.id = TRUE, i = i)
}

