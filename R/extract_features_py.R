#' Extract features from WAV audios using Python's Parselmouth library.
#'
#' @param \code{directory} A directory/folder containing WAV files.
#' @param \code{features} Vector of features to be extracted. (default: 'f0','formants','zcr','mhs','rms','gain','rfc','ac','mfcc').
#' @return \code{char} vector containing the expanded models.
#' @details The function uses the \code{getwd()} folder to write the temp files.
#' @examples
#' path2wav <- list.files(system.file("extdata", package = "wrassp"),
#' pattern <- glob2rx("*.wav"), full.names = TRUE)
#' extract_features_py(dirname(path2wav)[1])
#' @export
extract_features_py <- function(directory,
                                features = c('f0')){

  # process time
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  directory <- directory[1]

  # # getting python functions - MUST BE A BETTER WAY TO DO THIS!
  # /Library/Frameworks/R.framework/Resources/library/voice
  # if('f0' %in% features & !file.exists(paste0(getwd(),'/testthat/extract_f0.py'))){
  #   download.file('https://raw.githubusercontent.com/filipezabala/voice/master/testthat/extract_f0.py',
  #                 './testthat/extract_f0.py')
  # }
  # command <- paste0('python3 ./extract_f0.py ', directory)
  if('f0' %in% features){
    command <- paste0('python3 ./extract_f0.py ', directory)
    f0_py <- system(command, wait = FALSE, intern = T)
    f0_py <- sapply(f0_py, strsplit, ',')
    f0_py <- lapply(f0_py, as.numeric)
  }
  return(f0_py)
}
