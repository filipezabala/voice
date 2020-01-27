#' Writes a list.
#'
#' @param \code{lista} A list.
#' @param \code{caminho} The directory.
#' @export
write_list <- function(lista, caminho){
  sink(caminho)
  print(lista)
  sink()
}
