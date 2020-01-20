#' Convolute vectors multicore.
#'
#' @param \code{x} A vector or time series.
#' @param \code{columns} A \code{char} vector indicating the colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param \code{by.filter} A \code{char} indicating the column to filter by. If \code{NULL} the filter is off.
#' @param \code{compact.to} Percentage of remaining points after compactation. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param \code{drop.zeros} Logical. Drop repeated zeros or compress to 1 zero per null set?
#' @param \code{to.data.frame} Logical. Should the return be a data frame? If \code{F} returns a list.
#' @param \code{mc.cores} The number of cores to mclapply.
#' @return A vector of convoluted values with length near to \code{compact.to*length(x)}.
#' @examples
#'
#' @seealso \code{conv} \code{conv_df}
#' @export
conv_mc <- function(x, columns, compact.to, drop.zeros, mc.cores = detectCores()){

  cm <- mclapply(x[,columns], voice::conv, compact.to = compact.to,
                 drop.zeros = drop.zeros, mc.cores = mc.cores)
  return(cm)
}
