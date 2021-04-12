#' Tests if a vector is character(0), i.e., has length 0.
#' @param x A vector.
#' @examples
#' @export
is.chr0 <- function(x){
  length(x) == 0
}
