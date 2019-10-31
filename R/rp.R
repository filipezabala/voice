#' @export
rp <- function(tp = c(true,pred)){
  return(2*tp[1]+tp[2])
}

# t,p -> 2t+p
# 0,0 -> 0
# 0,1 -> 1
# 1,0 -> 2
# 1,1 -> 3
