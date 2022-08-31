#' Convolute data frames using multicore.
#'
#' @param x A data frame.
#' @param compact.to Percentage of remaining points after compaction If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param id The identification column. Default: \code{colname} of the first column of \code{x}.
#' @param colnum A \code{char} vector indicating the numeric colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param drop.x Logical. Drop columns containing .x? Default: \code{TRUE}.
#' @param drop.zeros Logical. Drop repeated zeros or compress to 1 zero per null set? Default: \code{FALSE}.
#' @param to.data.frame Logical. Should the return be a data frame? If \code{FALSE} returns a list. Default: \code{TRUE}.
#' @param round.off Number of decimal places of the convoluted vector. Default: \code{NULL}.
#' @param weight Vector of weights with same length of \code{y}. Default: \code{NULL}.
#' @param mc.cores The number of cores to mclapply. By default uses \code{1}.
#' @return A vector of convoluted values with length near to \code{compact.to*length(x)}.
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate_each
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' # getting Media data frame
#' M <- extract_features(dirname(path2wav), features = c('f0','formants'),
#' mc.cores = 1, verbose = FALSE)
#'
#' \donttest{
#' (cM.df <- conv_df(M[,-(1:2)], 0.1, mc.cores = 1))
#' (cM.df2 <- conv_df(M[,-(1:2)], 0.1, drop.x = FALSE, mc.cores = 1))
#'
#' dim(M)
#' dim(cM.df)
#' dim(cM.df2)
#' (cM.list <- conv_df(M[,-(1:2)], 0.1, to.data.frame = FALSE, mc.cores = 1))
#' }
#' @seealso \code{conv}, \code{conv_mc}
#' @export
conv_df <- function(x, compact.to, id = colnames(x)[1], colnum = NULL,
                    drop.x = TRUE, drop.zeros = FALSE,
                    to.data.frame = TRUE, round.off = NULL, weight = NULL,
                    mc.cores = 1){
  ini <- Sys.time()

  # numeric columns
  if(is.null(colnum)){
    is.num <- unlist(lapply(x, class)) == 'numeric'
    colnum <- colnames(x[,is.num])
  }

  # non-numeric columns
  colnon <- setdiff(colnames(x), colnum)

  # split numeric columns by id
  snum <- split(x[,colnum], x[,id])

  # split non-numeric columns id
  snon <- split(x[,colnon], x[,id])

  # original lengths by id
  lv <- table(x[,id])

  # vector and length of distinct id's
  nlv <- names(lv)
  nid <- length(nlv)

  # compact lengths by id
  n <- ceiling(compact.to*lv)
  cs <- c(0, cumsum(n))

  # convoluting numeric variables
  cn.li <- lapply(snum, voice::conv_mc, compact.to = compact.to,
                  drop.zeros = drop.zeros, to.data.frame = TRUE,
                  round.off = round.off, weight = weight, mc.cores = mc.cores)

  # transforming in dataframe
  cn.df <- lapply(cn.li, as.data.frame)
  # cn.df <- bind_cols(cn.li)

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
  if(drop.x){
    cn <- lapply(cn.li, colnames)[[1]]
    cn <- base::strsplit(cn, '[.]')
    cn <- as.data.frame(cn)[1,]
    cn.li <- lapply(cn.li, stats::setNames, cn)
  }

  # compact dataframe
  if(to.data.frame){
    cn.li <- do.call(dplyr::bind_rows, cn.li)
  }

  return(cn.li)
}
