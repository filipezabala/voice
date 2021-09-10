# x = ef
# k = 7
# colnum = NULL
# id = colnames(x)[1]
# by.filter = id
#
# table(x$id)
# table(x$id.min.time)

smooth_df <- function(x, k = 7, colnum = NULL, id = colnames(x)[1],
                      by.filter = id){

  # n smoothed
  n <- nrow(x)
  ns <- n-k+1

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

  # vector and length of distinct id's
  nlv <- names(lv)
  nid <- length(nlv)

  # result lengths by.filter
  cs <- c(0, cumsum(ns))

  x_li <- lapply(x[,colnum], zoo::rollmean, k)
  x_df <- bind_cols(x_li)

  # compact list
  li <- vector('list', length = nid)
  for(i in 1:nid){
    index <- 1:ns[i]
    x_li[[i]] <- snon[[i]][index,]
    even <- seq(2, ncol(x_df[[i]]), by = 2)
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

}
