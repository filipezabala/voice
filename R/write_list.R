#' Writes a list to a path.
#'
#' @param \code{x} A list.
#' @param \code{directory} A directory.
#' @export
write_list <- function(x, directory){
  sink(directory)
  print(x)
  sink()
}
