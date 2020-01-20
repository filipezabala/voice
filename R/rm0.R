#' Transforms \code{n} sets of \code{m>n} zeros (alternated with sets of non zeros) into \code{n} sets of \code{n} zeros.
#'
#' @param x A vector or time series.
#' @return Vector with n zeros.
#' @examples
#' (v0 <- c(1:20,rep(0,10)))
#' rm0(v0)
#'
#' (v0 <- c(rep(0,10),1:20))
#' rm0(v0)
#'
#' (v0 <- c(1:5,rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
#' rm0(v0)
#'
#' (v0 <- rep(0,10))
#' rm0(v0)
#'
#' (v0 <- c(0:10))
#' rm0(v0)
#'
#' (v0 <- c(rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
#' rm0(v0)
#' @export
rm0 <- function(x){

  if(sum(x^2) == 0){ # null vector
    return(0)
  }

  is.zero <- x == 0 # is zero?

  if(sum(is.zero) == 0){ # no zeros, returns original vector
    return(x)
  }

  lv0 <- length(x)
  first.zero <- is.zero[1] # is the first position a zero?
  diz <- diff(is.zero) # Difference of Is.Zero

  w0 <- which(is.zero) # positions containing zeros
  lw0 <- length(w0)

  d0 <- diff(w0) # position of the changes (F-T or T-F in v0==0)
  change <- d0 != 1
  n0 <- sum(change)+1 # number of sets with 0's

  if(sum(is.zero) == n0){ # number of zeros equals to number of sets with 0's
    return(x)
  }

  lv1 <- lv0 - lw0 + n0 # length of compacted vector, after cleaning 0's
  v1 <- rep(0, lv1) # compact vector

  wdn0 <- which(diz != 0) # position of the last change (F-T or T-F in v0==0)
  dwdn0 <- c(wdn0[1], diff(wdn0)) # sizes of sets with zeros and non-zeros, alternated
  ld0 <- length(dwdn0)
  dwdn1 <- rep(1, ld0) # vector of ones

  if(ld0 == 1 & first.zero){
    suppressWarnings(v1[2:lv1] <- v0[(dwdn0[1]+1):lv0])
  }

  if(ld0 == 1 & !first.zero){
    suppressWarnings(v1[1:dwdn0[1]] <- v0[1:dwdn0[1]])
  }

  if(ld0 > 1){
    odd <- seq(1, ld0, by = 2) # odd numbers 1:length(dwdn0)
    dwdn1[first.zero+odd] <- dwdn0[first.zero+odd]

    cs0 <- cumsum(dwdn0)
    cs1 <- cumsum(dwdn1)

    suppressWarnings(v1[1:cs1[1]] <- v0[1:cs0[1]])

    for(i in 2:length(cs0)){ # the loop works fine even with the warning (gets the last position, ok)
      suppressWarnings(v1[(cs1[i-1]+1):cs1[i]] <- v0[(cs0[i-1]+1):cs0[i]])
    }
  }
  return(v1)
}

# tests
# (v0 <- c(1:20,rep(0,10)))
# rm0(v0)
#
# (v0 <- c(rep(0,10),1:20))
# rm0(v0)
#
# (v0 <- c(1:5,rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
# rm0(v0)
#
# rm0(rep(0,10))
#
# v0 <- c(0:10)
# rm0(v0)
#
# v0 <- c(10:0)
# rm0(v0)
#
# rm0(c(0:10,0))
#
# (v0 <- c(rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
# rm0(v0)
#
# (v0 <- c(1:10,rep(0,99),1:66, rep(0,2)))
# rm0(v0)


# OLD

# (v0 <- c(1:5,rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
# (v0 <- c(rep(0,10),1:10,rep(0,5),10:20,rep(0,10)))
# v0 <- c(rep(0,10),1:20, rep(0,4))
# v0 <- c(0:10)
# (v0 <- c(1:20,rep(0,10)))
# (v0 <- c(rep(0,10),1:20)) # bad
#
# (lv0 <- length(v0))
# (is.zero <- v0 == 0)
# (first.zero <- is.zero[1])
# (diz <- diff(is.zero))
#
# (w0 <- which(is.zero))
# (lw0 <- length(w0))
#
# (d0 <- diff(w0))
# (change <- d0 != 1)
# (n0 <- sum(change)+1) # number of sets with 0's
#
# (lv1 <- lv0 - lw0 + n0) # length of compacted vector, after cleaning 0's
# (v1 <- rep(0, lv1)) # compacted vector
#
# (wdn0 <- which(diz != 0)) # position of the last change (F-T or T-F in v0==0)
# (dwdn0 <- c(wdn0[1], diff(wdn0))) # sizes of sets with zeros and non-zeros, alternated
# ld0 <- length(dwdn0)
# (dwdn1 <- rep(1, ld0))
# (odd <- seq(1, ld0, by = 2))
# dwdn1[first.zero+odd] <- dwdn0[first.zero+odd]
#
# (cs0 <- cumsum(dwdn0))
# (cs1 <- cumsum(dwdn1))
#
# # the loop works fine even with the warning (gets the last position, ok)
# v1[1:cs1[1]] <- v0[1:cs0[1]]
# for(i in 2:length(cs0)){
#   v1[(cs1[i-1]+1):cs1[i]] <- v0[(cs0[i-1]+1):cs0[i]]
# }
