#' Is a database of the extended type?
#'
#' @param x A data frame to be evaluated.
#' @param subj.id Column containing the subject ID. Default: \code{NULL}, i.e., uses the first column.
#' @export
is_can <- function(x, subj.id = subj.id){
  # checking subject duplicates
  dupl <- nrow(unique(x[,subj.id])) < nrow(x)
  if(!dupl){
    ic <- TRUE
  } else{
    ic <- FALSE
  }
  return(ic)
}
