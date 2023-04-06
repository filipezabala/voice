#' Writes a list to a path
#'
#' @param x A list.
#' @param path A full path to file.
#' @return A file named `list.txt` in `path`.
#' @examples
#' \dontrun{
#' library(voice)
#'
#' pts <- list(x = cars[,1], y = cars[,2])
#' listFile <- paste0(tempdir(), '/list.txt')
#' voice::write_list(pts, listFile)
#' file.info(listFile)
#' system(paste0('head ', listFile))
#' }
#' @export
write_list <- function(x, path){
  sink(path)
  print(x)
  sink()
}
