#' Is a database of the extended type?
#'
#' @param x A data frame to be evaluated.
#' @param subj.id Column containing the subject ID. Default: \coe{NULL}, i.e., uses the first column.
#' @export
is_ext <- function(x, subj.id = NULL){
  if(is.null(subj.id)){
    subj.id <- 1
  }
  # checking subject duplicates
  dupl <- nrow(unique(x[,subj.id])) < nrow(x)

  # checking if there is a media column
  rand.check <- sort(sample(1:nrow(x), 1000))
  pattern <- lapply(x[rand.check,], grep, pattern = '.[Ww][Aa][Vv]$|.[Mm][Pp]3$')
  l <- lapply(pattern, length)
  media.col <- which(l != 0)
  if(length(media.col) > 0 & dupl){
    ie <- TRUE
  } else {
    ie <- FALSE
  }
  return(list(is_extended = ie, probable_media_col = media.col))
}
