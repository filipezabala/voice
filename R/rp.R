#' Prenda's rule. Returns \code{2t+p}.
#'
#' @param true A number.
#' @param pred A number.
#' @return
#' \code{t,p -> 2t+p}
#'
#' \code{0,0 -> 0}
#'
#' \code{0,1 -> 1}
#'
#' \code{1,0 -> 2}
#'
#' \code{1,1 -> 3}
#'
#' \code{10,12 -> 32}
#'
#' \code{12,10 -> 34}
#'
#' @examples
#' rp(0,0) # 0
#' rp(0,1) # 1
#' rp(1,0) # 2
#' rp(1,1) # 3
#' rp(10,12) # 32
#' rp(12,10) # 34
#' @export
rp <- function(true, pred){
  tp <- c(true,pred)
  return(2*tp[1]+tp[2])
}
