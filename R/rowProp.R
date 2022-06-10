#' Form Row Proportions.
#'
#' @param x A matrix, data frame or tibble.
#' @param pts Maximum number of points by question. Default \code{NULL}, i.e., automatic.
#' @param na.rm Logical. Must the NAs be removed? Default \code{TRUE}.
#' @examples
#' library(voice)
#' nr <- 50
#' nc <- 10
#' x <- matrix(sample(c(NA,0:3), nr*nc, replace = TRUE), nrow = nr)
#' colnames(x) <- paste0('V', 1:nc)
#' rowProp(x)
#' rowProp(x, na.rm = F)
#' @export
rowProp <- function(x, pts = NULL, na.rm = TRUE, ...){
  if(is.matrix(x)){
    x <- as.data.frame(x)
  }
  if(is.null(pts)){
    pts <- max(sapply(lapply(lapply(lapply(x, table), names), as.numeric), max))
  }
  rp <- rowSums(x, na.rm = na.rm)/(pts*ncol(x))
  return(rp)
}
