#' Convolute data frames.
#'
#' @param \code{x} A data frame.
#' @param \code{compact.to} Percentage of remaining points after compactation. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param \code{colnum} A \code{char} vector indicating the numeric colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param \code{id} The identification column.
#' @param \code{by.filter} A \code{char} indicating the column to filter by. If \code{NULL} uses the \code{id} content.
#' @param \code{drop.zeros} Logical. Drop repeated zeros or compress to 1 zero per null set?
#' @param \code{to.data.frame} Logical. Should the return be a data frame? If \code{F} returns a list.
#' @param \code{mc.cores} The number of cores to mclapply. By default uses \code{parallel::detectCores()}.
#' @return A vector of convoluted values with length near to \code{compact.to*length(x)}.
#' @examples
#' library(voice)
#'
#' x <- dat %>%
#' mutate_each(as.factor, id:anyep_diff_w1)
#' (cx.df <- conv_df(x, 0.1))
#' (cx.df2 <- conv_df(x, 0.1, drop.x = T))
#' dim(x)
#' dim(cx.df)
#' dim(cx.df2)
#' (cx.list <- conv_df(x, 0.1, to.data.frame = F))
#' @seealso \code{conv}, \code{conv_mc}
#' @export
conv_df <- function(x, compact.to, colnum = NULL, id = 'id', by.filter = id, drop.x = F,
                    drop.zeros = F, to.data.frame = T, mc.cores = parallel::detectCores()){
  ini <- Sys.time()

  # numeric columns
  if(is.null(colnum)){
    is.num <- unlist(lapply(x, class)) == 'numeric'
    colnum <- colnames(x[,is.num])
  }

  # non-numeric columns
  colnon <- setdiff(colnames(x), colnum)

  # split numeric columns by.filter
  snum <- split(x[,colnum], x[,by.filter])

  # split non-numeric columns by.filter
  snon <- split(x[,colnon], x[,by.filter])

  # original lengths by.filter
  lv <- table(x[,by.filter])

  #  vector and length of distinct id's
  nlv <- names(lv)
  nid <- length(nlv)

  # compact lengths by.filter
  n <- ceiling(compact.to*lv)
  cs <- c(0, cumsum(n))

  # convoluting numeric variables
  cn.li <- lapply(snum, voice::conv_mc, compact.to = compact.to,
                  drop.zeros = drop.zeros, to.data.frame = T, mc.cores = mc.cores)

  # transforming in dataframe
  cn.df <- lapply(cn.li, as.data.frame)

  # compact list
  li <- vector('list', length = nid)
  for(i in 1:nid){
    index <- 1:n[i]
    cn.li[[i]] <- snon[[i]][index,]
    even <- seq(2, ncol(cn.df[[i]]), by = 2)
    index2 <- sort(union(even, even-!drop.x))
    cn.li[[i]] <- dplyr::bind_cols(cn.li[[i]], cn.df[[i]][,index2])
    names(cn.li)[i] <- nlv[i]
  }

  # compact dataframe
  if(to.data.frame){
    cn.li <- do.call(dplyr::bind_rows, cn.li)
  }

  return(cn.li)
}
