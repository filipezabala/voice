cumsumReset <- function(x, threshold = 0){
  somaAc <- rep(0, length(x))
  somaAc[1] <- x[1]
  ifelse(somaAc[1] < threshold, somaAc[1] <- 0, somaAc[1] <- somaAc[1])

  for(i in 2:length(x)){
    somaAc[i] <- somaAc[i-1] + x[i]
    ifelse(somaAc[i] < threshold, somaAc[i] <- 0, somaAc[i] <- somaAc[i])
  }
  return(somaAc)
}
