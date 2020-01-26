#' Convolute data frames.
#'
#' @param \code{x} A data frame.
#' @param \code{compact.to} Percentage of remaining points after compactation. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param \code{columns} A \code{char} vector indicating the colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param \code{by.filter} A \code{char} indicating the column to filter by. If \code{NULL} the filter is off.
#' @param \code{drop.zeros} Logical. Drop repeated zeros or compress to 1 zero per null set?
#' @param \code{to.data.frame} Logical. Should the return be a data frame? If \code{F} returns a list.
#' @param \code{mc.cores} The number of cores to mclapply.
#' @return A vector of convoluted values with length near to \code{compact.to*length(x)}.
#' @examples
#' library(tidyverse)
#' library(voice)
#' x <- dat %>%
#' mutate_each(as.factor, id:anyep_diff_w1)
#' cx <- conv_df(x, 0.1)
#' dim(x)
#' dim(cx)
#' @seealso \code{conv}, \code{conv_mc}
#' @export
conv_df <- function(x, compact.to, colnum = NULL, id = 'id', by.filter = id,
                    drop.zeros = T, to.data.frame = T, mc.cores = parallel::detectCores()){
  ini <- Sys.time()

  # numeric columns
  if(is.null(colnum)){
    is.num <- unlist(lapply(x, class)) == 'numeric'
    colnum <- colnames(x[,is.num])
  }

  # non-numeric columns
  # colnon <- setdiff(colnames(x), colnum)

  # split numeric columns by.filter
  snum <- split(x[,colnum], x[,by.filter])

  # split non-numeric columns by.filter
  # snon <- split(x[,colnon], x[,by.filter])

  # original lengths by.filter
  lv <- table(x[,by.filter])

  #  vector and length of distinct id's
  nlv <- names(lv)
  nid <- length(nlv)

  # compact lengths by.filter
  n <- ceiling(compact.to*lv)
  cs <- c(0, cumsum(n))

  # convoluting numeric variables
  ld <- lapply(snum, voice::conv_mc, compact.to = compact.to,
               drop.zeros = drop.zeros, to.data.frame = T, mc.cores = mc.cores)

  # transforming in dataframe
  ld.df <- lapply(ld, as.data.frame)

  # compact list
  li <- vector('list', length = nid)
  for(i in 1:nid){
    index <- 1:n[i]
    li[[i]] <- snon[[i]][index,]
    li[[i]] <- dplyr::bind_cols(li[[i]], ld.df[[i]])
    names(li)[i] <- nlv[i]
  }

  # compact dataframe
  if(to.data.frame){
    li <- do.call(dplyr::bind_rows, li)
  }

  return(li)
}
