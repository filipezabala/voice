#' Expand model given \code{y} and \code{x} variables.
#'
#' @param y The Y variable.
#' @param x The X variables.
#' @param k Number of additive components.
#' @return A \code{char} vector containing the expanded models.
#' @examples
#' library(voice)
#'
#' expand_model('y', LETTERS[1:4], 1)
#' expand_model('y', LETTERS[1:4], 2)
#' expand_model('y', LETTERS[1:4], 3)
#' expand_model('y', LETTERS[1:4], 4)
#'
#' # multiple models using apply functions
#' nx <- 10 # number of X variables to be used
#' models <- lapply(1:nx, expand_model, y = 'y', x = LETTERS[1:nx])
#' names(models) <- 1:nx
#' models
#' sum(sapply(models, length)) # total of models
#' @export
expand_model <- function(y, x, k){

  y <- paste0(y, ' ~ ')
  comb <- utils::combn(x, k)

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
