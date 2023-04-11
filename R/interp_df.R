#' Inperpolate data frames
#'
#' @description Interpolate data frames using multicore, compressing to \code{compact.to} fraction. May remove zeros.
#' @param x A data frame.
#' @param compact.to Proportion of remaining points after interpolation. If equals to 1 and keep.zeros = TRUE, the original vector is presented.
#' @param id The identification column. Default: \code{colname} of the first column of \code{x}.
#' @param colnum A \code{char} vector indicating the numeric colnames. If \code{NULL}, uses the columns of the \code{numeric} class.
#' @param drop.x Logical. Drop columns containing .x? Default: \code{TRUE}.
#' @param drop.zeros Logical. Drop repeated zeros or keep 1 zero per null set? Default: \code{FALSE}.
#' @param to.data.frame Logical. Should return a data frame? If \code{FALSE} returns a list. Default: \code{TRUE}.
#' @param round.off Number of decimal places of the interpolated \code{y}. Default: \code{NULL}.
#' @param weight Vector of weights with same length of \code{y}. Default: \code{NULL}.
#' @param mc.cores The number of cores to mclapply. Default: \code{1}.
#' @return A data frame of interpolated values with nrow near to \code{compact.to*length(x)}.
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate_each
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#'
#' # getting Media data frame via lean call
#' M <- extract_features(dirname(path2wav), features = c('f0','fmt'),
#' mc.cores = 1, verbose = FALSE)
#'
#' \donttest{
#' (cM.df <- interp_df(M[,-(1:2)], 0.1, mc.cores = 1))
#' (cM.df2 <- interp_df(M[,-(1:2)], 0.1, drop.x = FALSE, mc.cores = 1))
#'
#' dim(M)
#' dim(cM.df)
#' dim(cM.df2)
#' (cM.list <- interp_df(M[,-(1:2)], 0.1, to.data.frame = FALSE, mc.cores = 1))
#' }
#' @seealso \code{interp}, \code{interp_mc}
#' @export
interp_df <- function(x, compact.to, id = colnames(x)[1], colnum = NULL,
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

  # interolationg numeric variables
  cn.li <- lapply(snum, voice::interp_mc, compact.to = compact.to,
                  drop.zeros = drop.zeros, to.data.frame = to.data.frame,
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
    cn.df.temp <- cn.df[[i]][,index2]
    if(is.numeric(cn.df.temp)){ # dealing with unitary features
      cn.df.temp <- dplyr::as_tibble(cn.df.temp)
      names(cn.df.temp) <- colnames(x[colnum])
    }
    cn.li[[i]] <- dplyr::bind_cols(cn.li[[i]], cn.df.temp)
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
