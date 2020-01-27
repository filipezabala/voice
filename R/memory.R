#' Gives the amount of memory free, total and percentage.
#'
#' @param \code{unit} A \code{char} indicating \code{bytes}, \code{kbytes}, \code{mbytes} and \code{gbytes}.
#' @examples
#' library(voice)
#' memory()
#' @export
memory <- function(){

  plat <- strsplit(version$platform,'-')

  if(sum(plat[[1]] == 'linux')){
    mem <- system('free -m', intern=TRUE)
    memtotal <- as.numeric((strsplit(mem[2],'     ')[[1]])[3])
    memfree  <- as.numeric((strsplit(mem[2],'     ')[[1]])[5])
    memfreeperc <- memfree/memtotal
  } else if(sum(plat[[1]] == 'apple')){
    cat('Only works in Linux!\n')
    # mem <- system('vm_stat', intern=TRUE)
    # memtotal <- ?
    # memfree  <- ?
    # memfreeperc <- memfree/memtotal
  } else if(sum(plat[[1]] == 'windows')){
    cat('Only works in Linux!\n')
  }  else{cat('Only works in Linux!\n')}

  return(list(memory.free=memfree,
              memory.total=memtotal,
              mem.free.perc=memfreeperc))
}
