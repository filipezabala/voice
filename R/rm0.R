#' Compress zeros.
#'
#' @description Transforms \code{n} sets of \code{m>n} zeros (alternated with sets of non zeros) into \code{n} sets of \code{n} zeros.
#' @param y A vector or time series.
#' @return Vector with n zeros.
#' @examples
#' library(voice)
#'
#' (v0 <- c(1:20,rep(0,10)))
#' (r0 <- rm0(v0))
#' length(v0)
#' length(r0)
#' sum(v0 == 0)
#'
#' (v1 <- c(rep(0,10),1:20))
#' (r1 <- rm0(v1))
#' length(r1)
#'
#' (v2 <- rep(0,10))
#' (r2 <- rm0(v2))
#' length(r2)
#'
#' (v3 <- c(0:10))
#' (r3 <- rm0(v3))
#' length(r3)
#'
#' (v4 <- c(rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
#' (r4 <- rm0(v4))
#' length(r4)
#' sum(v4 == 0)
#' @export
rm0 <- function(y){

  if(sum(y^2, na.rm = TRUE) == 0){ # null vector
    return(0)
  }

  is.zero <- y == 0 # is zero?
  if(sum(is.zero, na.rm = TRUE) == 0){ # no zeros, returns original vector
    return(y)
  }

  ly <- length(y)
  first.zero <- is.zero[1] # is the First position a Zero?
  diz <- diff(is.zero) # Difference of Is.Zero

  w0 <- which(is.zero) # positions containing zeros
  lw0 <- length(w0) # number of (positions containing) zeros

  d0 <- diff(w0) # position of the changes (F-T or T-F) in v0 == 0
  change <- d0 != 1
  n0 <- sum(change, na.rm = TRUE)+1 # number of sets with 0's

  if(sum(is.zero) == n0){ # number of zeros equals to number of sets with 0's
    return(y)
  }

  lv <- ly - lw0 + n0 # length of compacted vector, after cleaning 0's
  v <- rep(0, lv) # compact vector

  wdn0 <- which(diz != 0) # position of the last change (F-T or T-F in y==0)
  dwdn0 <- c(wdn0[1], diff(wdn0)) # sizes of sets with zeros and non-zeros, alternated
  ld0 <- length(dwdn0)
  dwdn1 <- rep(1, ld0) # vector of ones

  if(ld0 == 1 & first.zero){
    suppressWarnings(v[2:lv] <- y[(dwdn0[1]+1):ly])
  }

  if(ld0 == 1 & !first.zero){
    suppressWarnings(v[1:dwdn0[1]] <- y[1:dwdn0[1]])
  }

  if(ld0 > 1){
    odd <- seq(1, ld0, by = 2) # odd numbers 1:length(dwdn0)
    dwdn1[first.zero+odd] <- dwdn0[first.zero+odd]

    cs0 <- cumsum(dwdn0)
    cs1 <- cumsum(dwdn1)

    suppressWarnings(v[1:cs1[1]] <- y[1:cs0[1]])

    for(i in 2:length(cs0)){ # the loop works fine even with the warning (gets the last position, ok)
      suppressWarnings(v[(cs1[i-1]+1):cs1[i]] <- y[(cs0[i-1]+1):cs0[i]])
    }
  }
  return(v)
}
