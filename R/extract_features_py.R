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

# test
# directory <- '/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte'
# features = c('f0')
# full.names = TRUE
# recursive = FALSE

extract_features_py <- function(directory,
                                features = c('f0'),
                                full.names = TRUE, recursive = FALSE){

  # process time
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  directory <- directory[1]

  # # getting python functions - MUST BE A BETTER WAY TO DO THIS!
  if('f0' %in% features & !file.exists(paste0(getwd(),'/extract_f0.py'))){
    download.file('https://raw.githubusercontent.com/filipezabala/voice/master/testthat/extract_f0.py',
                  'extract_f0.py')
  }

  # listing wav files
  wavFiles <- list.files(directory, pattern = glob2rx('*.wav'),
                         full.names = full.names, recursive = recursive)

  # list of features
  features.list <- vector('list', length(features))
  i <- 0

  # 1. F0 analysis of the signal
  if('f0' %in% features){
    i <- i+1
    extract_f0 <- paste0('python3 ./extract_f0.py ', directory)
    f0 <- system(extract_f0, wait = FALSE, intern = T)
    f0 <- sapply(f0, strsplit, ',')
    f0 <- lapply(f0, as.numeric)
    n_f0 <- sapply(f0,length)
    names(features.list) <- 'f0'
    features.list[[i]] <- dplyr::bind_cols(unlist(f0))
    colnames(features.list[[i]]) <- 'F0'
  }

  # id
  id <- tibble::enframe(rep(basename(wavFiles), n_f0), value = 'audio', name = NULL)

  # final data frame
  dat <- dplyr::bind_cols(audio=id, features.list)

  # total time
  t0 <- proc.time()-pt0
  cat('TOTAL TIME', t0[3], 'SECONDS\n\n')

  # return(dat)
  return(dat)
}
