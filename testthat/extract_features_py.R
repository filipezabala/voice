#' Extract features from WAV audios using Python's Parselmouth library.
#'
#' @param \code{directory} A directory/folder containing the WAV files.
#' @return \code{char} vector containing the expanded models.
#' @details The function uses the \code{getwd()} folder to write the temp files.
#' @examples
#' path2wav <- list.files(system.file("extdata", package = "wrassp"),
#' pattern <- glob2rx("*.wav"), full.names = TRUE)
#' extract_features_py(dirname(path2wav)[1])
#' @export
extract_features_py <- function(directory,
                                features = c('f0'))
{
  if(!file.exists(paste0(getwd(),'/temp_f0.py'))){
    download.file('https://raw.githubusercontent.com/filipezabala/voice/master/testthat/extract_f0.py',
                  'extract_f0.py')
  }
  # command <- paste0('python3 ./extract_f0.py ', directory)
  command <- paste0('python3 ./testthat/extract_f0.py ', directory)
  f0_py <- system(command, wait = FALSE, intern = T)
  f0_py <- sapply(f0_py, strsplit, ',')
  f0_py <- lapply(f0_py, as.numeric)


  return(f0_py)
}

ef_py <- extract_features_py('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte')

lapply(ef_py, quantile, probs=seq(0,1,.1))
lapply(ef_py, length)

