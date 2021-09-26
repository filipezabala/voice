#' Create an audio id by row at data frame.
#'
#' @param x A data frame.
#' @export
audio_id <- function(x, i=5, drop_fn = FALSE){
  ini <- Sys.time()
  ss <- strsplit(x$file_name, '[_.]')
  geti <- function(x){ as.integer(x[i]) }
  aid <- sapply(ss, geti)
  if(drop_fn){
    x <- bind_cols(audio_id=aid, x) %>%
      arrange(audio_id) %>%
      select(-file_name)
  } else{
    x <- bind_cols(audio_id=aid, x) %>%
      arrange(audio_id)
  }
  print(Sys.time()-ini)
  return(x)
}
