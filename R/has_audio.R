#' Indicates if an ID has associated audio files
#'
#' @param x A data frame to be tagged with media information.
#' @param mediaDir Directory containing media files. Currently accepts audio files with WAV and MP3 formats.
#' @param id Column containing the ID to be searched in mediaDir file names. Default: \code{NULL}, i.e., uses the first column.
#' @param get.id Logical. Should id_file be x id?
#' @param i ID position in \code{col}. Default: \code{4}.
#' @param to.int Logical. Should tag_has_audio be converted to integer?
#' @export
has_audio <- function(x, mediaDir, id = NULL, get.id = FALSE,
                      i = 4, to.int = TRUE){
  if(is.null(id)){
    id <- 1
  }
  audioFiles <- dir(mediaDir, pattern = '.[Ww][Aa][Vv]$|.[Mm][Pp]3$')
  if(length(audioFiles) > 0){
    ss <- strsplit(audioFiles, '[_.]')
    geti <- function(x){
      as.integer(x[i])
      }
    id.label <- sapply(ss, geti)
  }
  x <- as.data.frame(x)
  ha <- x[,id] %in% id.label
  if(get.id){
    if(to.int){
      ha_df <- dplyr::bind_cols(id_file = x[,id], tag_has_audio = as.integer(ha))
      return(ha_df)
    } else{
      ha_df <- dplyr::bind_cols(id_file = x[,id], tag_has_audio = ha)
      return(ha_df)
    }
  } else{
    if(to.int){
      return(as.integer(ha))
    } else{
      return(ha)
    }
  }
}
