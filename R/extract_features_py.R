#' Extract features from WAV audios using Python's Parselmouth library.
#'
#' @param \code{directory} A directory/folder containing WAV files.
#' @param \code{filesRange} The desired range of directory files (default: \code{NULL}, i.e., all files).
#' @param \code{features} Vector of features to be extracted. (default: 'f0' (pitch),'formants' (F1:F8)).
#' @return \code{char} vector containing the expanded models.
#' @details The function uses the \code{getwd()} folder to write the temp files.
#' @examples
#' library(voice)
#' path2wav <- list.files(system.file("extdata", package = "wrassp"),
#' pattern <- glob2rx("*.wav"), full.names = TRUE)
#' efp <- extract_features_py(dirname(path2wav))
#' efp
#' table(efp$file_name)
#'
#' # limiting filesRange
#' efpl <- extract_features_py(dirname(path2wav), filesRange = 3:6)
#' efpl
#' table(efpl$file_name)
#'
#' @import dplyr
#' @export

# test
# directory <- '/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte'
directory <- '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/'
features = c('f0','formants')
windowShift = 5/1000
full.names = TRUE
recursive = FALSE
library(dplyr)

extract_features_py <- function(directory, filesRange = NULL,
                                features = c('f0','formants'),
                                windowShift = 5/1000,
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

  # # list of features
  # features.list <- vector('list', 1)
  # i <- 0

  # 1. F0 analysis of the signal
  if('f0' %in% features){
    extract_f0 <- paste('python3 ./temp_extract_f0.py', directory, windowShift)
    f0 <- system(extract_f0, wait = FALSE, intern = T)
    splist_f0 <- sapply(f0, strsplit, '\\s+')
    names(splist_f0) <- 1:length(splist_f0)
    df_f0 <- t(dplyr::bind_rows(splist_f0[-1]))
    colnames(df_f0) <- as.vector(t(dplyr::bind_rows(splist_f0[1])))
    colnames(df_f0)[1] <- 'id'
    df_f0 <- df_f0 %>%
      as_tibble() %>%
      mutate_at(vars(-file_name),
                list(as.numeric)) %>%
      select(id, file_name, interval, F0) %>%
      arrange(file_name, interval)
  }

  # 2. Formants
  if('formants' %in% features){
    extract_formants <- paste0('python3 ./temp_extract_formants.py ', directory)
    formants <- system(extract_formants, wait = FALSE, intern = T)
    splist_fo <- sapply(formants, strsplit, '\\s+')
    names(splist_fo) <- 1:length(splist_fo)
    df_formants <- t(dplyr::bind_rows(splist_fo[-1]))
    colnames(df_formants) <- as.vector(t(dplyr::bind_rows(splist_fo[1])))
    colnames(df_formants)[-(2:3)] <- c('id',paste0('F',1:8))
    df_formants <- df_formants %>%
      as_tibble %>%
      mutate_at(vars(-file_name),
                list(as.numeric)) %>%
      select(id,file_name,interval,F1:F8) %>%
      arrange(file_name, interval)
  }

  # final data frame
  dat <- dplyr::left_join(df_f0, df_formants, by=c('id','file_name','interval'))

  # total time
  t0 <- proc.time()-pt0
  cat('TOTAL TIME', t0[3], 'SECONDS\n\n')

  # return(dat)
  return(dat)
}
