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
#' @import dplyr
#' @export

# test
# directory <- '/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte'
directory <- '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/'
features = c('f0','formants')
full.names = TRUE
recursive = FALSE
library(dplyr)

extract_features_py <- function(directory,
                                features = c('f0','formants'),
                                full.names = TRUE, recursive = FALSE){

  # process time
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  directory <- directory[1]

  # # getting python functions - MUST BE A BETTER WAY TO DO THIS!
  if(!file.exists(paste0(getwd(),'/temp_libs.py'))){
    download.file('https://raw.githubusercontent.com/filipezabala/voice/master/testthat/libs.py',
                  'temp_libs.py')
  }

  if('f0' %in% features & !file.exists(paste0(getwd(),'/temp_extract_f0.py'))){
    download.file('https://raw.githubusercontent.com/filipezabala/voice/master/testthat/extract_f0.py',
                  'temp_extract_f0.py')
  }

  if('formants' %in% features & !file.exists(paste0(getwd(),'/temp_extract_formants.py'))){
    download.file('https://raw.githubusercontent.com/filipezabala/voice/master/testthat/extract_formants.py',
                  'temp_extract_formants.py')
  }

  # calling libraries - MUST BE A BETTER WAY TO DO THIS!
  reticulate::source_python('./temp_libs.py')

  # listing wav files
  wavFiles <- list.files(directory, pattern = glob2rx('*.wav'),
                         full.names = full.names, recursive = recursive)

  # list of features
  features.list <- vector('list', 1)
  i <- 0

  # 1. F0 analysis of the signal
  if('f0' %in% features){
    i <- i+1
    extract_f0 <- paste0('python3 ./temp_extract_f0.py ', directory)
    f0 <- system(extract_f0, wait = FALSE, intern = T)
    splist_f0 <- sapply(f0, strsplit, '\\s+')
    names(splist_f0) <- 1:length(splist_f0)
    df_f0 <- t(dplyr::bind_rows(splist_f0[-1]))[,-1]
    colnames(df_f0) <- t(dplyr::bind_rows(splist_f0[1]))[,-1]
    df_f0 <- df_f0 %>%
      as_tibble %>%
      mutate_at(vars(-file_name),
                list(as.numeric)) %>%
      select(file_name,interval,F0) %>%
      arrange(file_name, interval)
  }

  # 2. Formants
  if('formants' %in% features){
    i <- i+1
    extract_formants <- paste0('python3 ./temp_extract_formants.py ', directory)
    formants <- system(extract_formants, wait = FALSE, intern = T)
    splist_fo <- sapply(formants, strsplit, '\\s+')
    names(splist_fo) <- 1:length(splist_fo)
    df_formants <- t(dplyr::bind_rows(splist_fo[-1]))[,-1]
    colnames(df_formants) <- t(dplyr::bind_rows(splist_fo[1]))[,-1]
    colnames(df_formants)[-(1:2)] <- paste0('F',1:8)
    df_formants <- df_formants %>%
      as_tibble %>%
      mutate_at(vars(-file_name),
                list(as.numeric)) %>%
      select(file_name,interval,F1:F8) %>%
      arrange(file_name, interval)
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
