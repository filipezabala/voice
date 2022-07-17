#' Smooth numeric variables in a data frame.
#'
#' @param x A data frame.
#' @param k Integer width of the rolling window. Default: \code{11}.
#' @param id The identification column. Default: \code{colname} of the first column of \code{x}.
#' @param colnum A \code{char} vector indicating the numeric colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param mc.cores The number of cores to mclapply. By default uses \code{1}.
#' @return A vector of convoluted values with length near to \code{compact.to*length(x)}.
#' @importFrom dplyr %>%
#' @seealso \code{extract_features}
#' @export
smooth_df <- function(x, k = 11, id = colnames(x)[1], colnum = NULL,
                      mc.cores = 1){

  # n
  n <- nrow(x)
  n_by_id <- table(x[,id])

  # n smoothed
  ns_fun <- function(x,k) {return(x-k+1)}
  ns_by_id <- sapply(n_by_id, ns_fun, k=k)
  ns <- sum(ns_by_id) # generalize

  # vector and length of distinct id's
  id_names <- names(n_by_id)
  n_id <- length(id_names)

  # beginning (beg0) and end (end0) of original objects
  beg0 <- c(0, cumsum(n_by_id)) + 1
  end0 <- beg0[-(n_id+1)] -1 + ns_by_id

  # beginning (beg1) and end (end1) of smoothed objects
  beg1 <- c(0, cumsum(ns_by_id)) + 1
  end1 <- cumsum(ns_by_id)

  # numeric columns
  if(is.null(colnum)){
    is.num <- sapply(x, class) %in% c('integer', 'numeric')
    colnum <- colnames(x[,is.num])
  }

  # non-numeric columns
  colnon <- base::setdiff(colnames(x), colnum)

  # split numeric columns by id
  snum <- split(x[,colnum], x[,id])

  # split non-numeric columns by id
  snon <- split(x[,colnon], x[,id])
  snon_df <- tibble::as_tibble(do.call(rbind, snon), .name_repair = 'unique')

  # smooth
  snum_li <- parallel::mclapply(snum, zoo::rollmean, k,
                     mc.cores = mc.cores)
  snum_df <- tibble::as_tibble(do.call(rbind, snum_li), .name_repair = 'unique')

  # binding non numeric columns to *x* *s*moothed
  xs <- suppressMessages(tibble::as_tibble(matrix(NA, nrow = ns,
                                 ncol = ncol(snon_df)+ncol(snum_df)),
                          .name_repair = 'unique'))
  colnames(xs) <- c(colnames(snon_df), colnames(snum_df))
  for(i in 1:n_id){
    fltr0 <- beg0[i]:end0[i]
    fltr1 <- beg1[i]:end1[i]
    xs[fltr1, ] <- dplyr::bind_cols(snon_df[fltr0,], snum_df[fltr1,])
  }

  # reordering columns
  xs <- xs %>%
    dplyr::select(colnames(x))

  return(xs)
}
