#' Expand model given \code{y} and \code{x} variables.
#'
#' @param \code{y} The Y variable.
#' @param \code{x} The X variables.
#' @param \code{k} Number of additive components.
#' @return A \code{char} vector containing the expanded models.
#' @examples
#' expand_model('y', LETTERS[1:4], 1)
#' expand_model('y', LETTERS[1:4], 2)
#' expand_model('y', LETTERS[1:4], 3)
#' expand_model('y', LETTERS[1:4], 4)
#' @export
expand_model <- function(y, x, k){

  y <- paste0(y, ' ~ ')
  comb <- combn(x, k)

  if(k == 1){
    models <- unlist(lapply(y, paste0, comb))
  }

  if(k > 1){
    nc <- ncol(comb)
    pred <- vector('list', nc)
    for(j in 1:nc){
      pred[[j]] <- paste0(comb[,j], collapse = ' + ')
    }
    models <- unlist(lapply(y, paste0, pred))
  }
  return(models)
}
