#' Convolute data frames.
#'
#' @param x A data frame.
#' @param compact.to Percentage of remaining points after compactation. If equals to 1 and keep.zeros = T, the original vector is presented.
#' @param colnum A \code{char} vector indicating the numeric colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param id The identification column. Default: \code{'id'}.
#' @param by.filter A \code{char} indicating the column to filter by. If \code{NULL} uses the \code{id} content.
#' @param drop.x Logical. Drop columns containing .x? Default: \code{'FALSE'}.
#' @param drop.zeros Logical. Drop repeated zeros or compress to 1 zero per null set? Default: \code{'FALSE'}.
#' @param to.data.frame Logical. Should the return be a data frame? If \code{F} returns a list. Default: \code{'TRUE'}.
#' @param round.off Number of decimal places of the convoluted vector. Default: \code{'NULL'}.
#' @param mc.cores The number of cores to mclapply. By default uses \code{parallel::detectCores()}.
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
#' # getting all the 1092 features
#' ef <- extract_features(dirname(path2wav), features = c('f0','formants',
#' 'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'),
#' mc.cores = 1)
#'
#' (cef.df <- conv_df(ef, 0.1, id = 'file_name', mc.cores = 1))
#' (cef.df2 <- conv_df(ef, 0.1, id = 'file_name', drop.x = TRUE, mc.cores = 1))
#'
#' dim(ef)
#' dim(cef.df)
#' dim(cef.df2)
#' (cef.list <- conv_df(ef, 0.1, id = 'file_name', to.data.frame = FALSE, mc.cores = 1))
#' @seealso \code{conv}, \code{conv_mc}
#' @export
conv_df <- function(x, compact.to, colnum = NULL, id = 'id', by.filter = id,
                    drop.x = FALSE, drop.zeros = FALSE, to.data.frame = TRUE,
                    round.off = NULL, mc.cores = parallel::detectCores()){
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
                  drop.zeros = drop.zeros, to.data.frame = TRUE,
                  round.off = round.off, mc.cores = mc.cores)

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
