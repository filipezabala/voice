#' Tag a data frame with media information.
#'
#' @param x A data frame to be tagged with media information.
#' @param mediaDir Directory containing media files. Currently accepts audio files.
#' @param subj.id Column containing the subject ID to be searched in mediaDir file names. Default: \coe{NULL}, i.e., uses the first column.
#' @param media.id Column containing the media ID. Default: \coe{NULL}, i.e., uses the first column.
#' @param mc.cores Number of cores to be used
#' @export
tag <- function(x, mediaDir, subj.id = NULL, media.id = NULL,
                mc.cores = 1, subj.id.simplify = FALSE,
                filesRange = NULL, features = 'f0',
                extraFeatures = FALSE,
                gender = "u",
                windowShift = 5,
                numFormants = 8,
                numcep = 12,
                dcttype = c("t2", "t1", "t3", "t4"),
                fbtype = c("mel", "htkmel", "fcmel", "bark"),
                resolution = 40,
                usecmp = FALSE,
                full.names = TRUE,
                recursive = FALSE,
                check.mono = TRUE,
                stereo2mono = TRUE,
                overwrite = FALSE,
                freq = 44100,
                round.to = 4){

  if(is.null(subj.id)){
    subj.id <- 1
  }

  if(is.null(media.id)){
    media.id <- 2
  }

  # filename without extension (analyze df>tbl>df. strsplit via tidyverse?)
  x <- as.data.frame(x)
  ss <- unlist(strsplit(x[,media.id], '.[Mm][Pp]3$|.[Ww][Aa][Vv]$'))
  x <- dplyr::bind_cols(x, file_name = ss)
  x <- dplyr::as_tibble(x)

  # voice::feat_summary
  fs <- voice::feat_summary(mediaDir, mc.cores = mc.cores,
                            filesRange = filesRange,
                            features = features,
                            extraFeatures = extraFeatures,
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

  if(subj.id.simplify){
    x[,subj.id] <- as.character(cumsum(!duplicated(x[,subj.id])))
  }

  return(x)

  # # voice::audio_time
  # at <- audio_time(mediaDir, get.id = TRUE)
  # x <- left_join(x, at, by = 'filename')
  #
  # # voice::spoken_prop
  # st <- spoken_time(mediaDir, get.id = TRUE, recursive = TRUE)
  # x <- left_join(x, st, by = 'filename')
  # x <- mutate(x, tag_spoken_prop = tag_spoken_time/tag_audio_time)
  #
  #
  # # voice::notes_summary
  # notes_summary(mediaDir, get.id = TRUE, i = i)
}

