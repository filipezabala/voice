#' Tag a data frame with media information.
#'
#' @param x A data frame to be tagged with media information.
#' @param mediaDir Directory containing media files. Currently accepts audio files.
#' @param id Column containing the ID to be searched in mediaDir file names. Default: \coe{NULL}, i.e., uses the first column.
#' @param i ID position in \code{col}. Default: \code{4}.
#' @export
tag <- function(x, mediaDir, subj.id = NULL, media.id = NULL, i = 4){

  if(is.null(subj.id)){
    subj.id <- 1
  }

  if(is.null(media.id)){
    media.id <- 2
  }

  # filename without
  x <- as.data.frame(x)
  ss <- unlist(strsplit(x[,media.id], '.[Mm][Pp]3$|.[Ww][Aa][Vv]$'))
  x <- dplyr::bind_cols(x, file_name = ss)
  x <- dplyr::as_tibble(x)

  # voice::feat_summary
  fs <- voice::feat_summary(mediaDir)
  x <- dplyr::left_join(x, fs, by = 'file_name')

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

