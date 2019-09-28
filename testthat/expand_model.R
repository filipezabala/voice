expand_model <- function(y, x, k){
  
  y <- paste0(y, ' ~ ')
  comb <- combn(x, k)
  
  if(k == 1){
    modelos <- unlist(lapply(y, paste0, comb))
  }
  
  if(k > 1){
    nc <- ncol(comb)
    pred <- vector('list', nc)
    for(j in 1:nc){
      pred[[j]] <- paste0(comb[,j], collapse = ' + ')
    }
    modelos <- unlist(lapply(y, paste0, pred))
  }
  return(modelos)
}
