#' Create an audio id by row at data frame.
#'
#' @param x A data frame.
#' @param col A column containing the ID to be extracted. If \code{NULL}, the first column is used. Default: \code{NULL}.
#' @param pattern Pattern to split \code{col}. Default: \code{'[_.]'}.
#' @param i ID position in \code{col}. Default: \code{5}.
#' @param drop_col Logical. Should \code{col} be removed? Default: \code{FALSE}.
#' @export
id_file <- function(x, col = NULL, pattern = '[_.]', i = 5, drop_col = FALSE){

  # time processing
  pt0 <- proc.time()

  x <- as.data.frame(x)

  if(is.null(col)){
    col <- 1
  } else if(is.character(col)){
    col <- which(colnames(x) == col)
  }
  ss <- strsplit(x[,col], '[_.]')
  geti <- function(x){ as.integer(x[i]) }
  aid <- sapply(ss, geti)
  sprintf('%1.0f', aid)

  x <- dplyr::bind_cols(id_file = aid, x) %>%
    plyr::arrange(id_file) %>%
    dplyr::as_tibble()

  if(drop_col){
    x <- x %>%
      select(-col)
  }

  # total time
  t0 <- proc.time()-pt0
  cat('TOTAL TIME', t0[3], 'SECONDS\n\n')

  return(x)
}
