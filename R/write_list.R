#' Writes a list to a path.
#'
#' @param x A list.
#' @param directory A directory.
#' @export
write_list <- function(x, directory){
  sink(directory)
  print(x)
  sink()
}
