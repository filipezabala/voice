#' Writes a list to a path.
#'
#' @param x A list.
#' @param path A full path to file.
#' @examples
#' library(voice)
#' pts <- list(x = cars[,1], y = cars[,2])
#' write_list(pts, paste0(getwd(), '/list.txt'))
#' @export
write_list <- function(x, path){
  sink(path)
  print(x)
  sink()
}
