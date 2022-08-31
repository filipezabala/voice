#' Extract features from WAV audios using 'Python's' 'Parselmouth' library.
#'
#' @param directory A directory/folder containing WAV files.
#' @param filesRange The desired range of directory files (default: 0, i.e., all files).
#' @param features Vector of features to be extracted. (default: 'f0' (pitch),'formants' (F1:F8)).
#' @param windowShift \code{= <dur>} set analysis window shift to <dur>ation in ms (default: 5/1000).
#' @param full.names Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (default: \code{TRUE})
#' @param recursive Logical. Should the listing recursively into directories? (default: \code{FALSE})
#' @param round.to Number of decimal places to round to. (default: \code{NULL})
#' @return A data frame containing the selected features.
#' @details The function uses the \code{getwd()} folder to write the temp files.
#' @examples
#'
#' \dontrun{
#' library(voice)
#'
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#' efp <- extract_features_py(dirname(path2wav))
#' efp
#' table(efp$file_name)
#'
#' # limiting filesRange
#' efpl <- extract_features_py(dirname(path2wav), filesRange = 3:6)
#' efpl
#' table(efpl$file_name)
#' }
#' @export
extract_features_py <- function(directory, filesRange = 0,
                                features = c('f0','formants'),
                                windowShift = 5/1000,
                                full.names = TRUE, recursive = FALSE,
                                round.to = NULL){

  # process time
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  directory <- directory[1]

  # # getting python functions - MUST BE A BETTER WAY TO DO THIS!
  if(!file.exists(paste0(getwd(),'/temp_libs.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/libs.py',
                  'temp_libs.py')
  }

  if('f0' %in% features & !file.exists(paste0(getwd(),'/temp_extract_f0.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/extract_f0.py',
                  'temp_extract_f0.py')
  }

  if('formants' %in% features & !file.exists(paste0(getwd(),'/temp_extract_formants.py'))){
    utils::download.file('https://raw.githubusercontent.com/filipezabala/voice/master/tests/extract_formants.py',
                  'temp_extract_formants.py')
  }

  # calling libraries - MUST BE A BETTER WAY TO DO THIS!
  reticulate::source_python('./temp_libs.py')

  # 1. F0 analysis of the signal
  if('f0' %in% features){
    extract_f0 <- paste('python3 ./temp_extract_f0.py', directory, windowShift,
                        min(filesRange), max(filesRange))
    f0 <- system(extract_f0, wait = FALSE, intern = T)
    splist_f0 <- sapply(f0, strsplit, '\\s+')
    names(splist_f0) <- 1:length(splist_f0)
    df_f0 <- t(dplyr::bind_rows(splist_f0[-1]))
    colnames(df_f0) <- as.vector(t(dplyr::bind_rows(splist_f0[1])))
    colnames(df_f0)[1] <- 'id'
    df_f0 <- df_f0 %>%
      dplyr::as_tibble() %>%
      dplyr::mutate_at(dplyr::vars(-file_name),
                list(as.numeric)) %>%
      dplyr::select(id, file_name, interval, F0) %>%
      dplyr::arrange(file_name, interval)
  }

  # 2. Formants
  if('formants' %in% features){
    extract_formants <- paste('python3 ./temp_extract_formants.py ', directory,
                              windowShift, min(filesRange), max(filesRange))
    formants <- system(extract_formants, wait = FALSE, intern = T)
    splist_fo <- sapply(formants, strsplit, '\\s+')
    names(splist_fo) <- 1:length(splist_fo)
    df_formants <- t(dplyr::bind_rows(splist_fo[-1]))
    colnames(df_formants) <- as.vector(t(dplyr::bind_rows(splist_fo[1])))
    colnames(df_formants)[-(2:3)] <- c('id',paste0('F',1:8))
    df_formants <- df_formants %>%
      dplyr::as_tibble() %>%
      dplyr::mutate_at(dplyr::vars(-file_name),
                list(as.numeric)) %>%
      dplyr::select(id,file_name,interval,F1:F8) %>%
      dplyr::arrange(file_name, interval)
  }

  # final data frame
  dat <- dplyr::left_join(df_f0, df_formants, by=c('id','file_name','interval'))

  # rounding
  if(!is.null(round.to)){
    dat[,-(1:2)] <- round(dat[,-(1:2)], round.to)
  }

  # replacing NaN by NA
  dat[sapply(dat, is.nan)] <- NA

  # total time
  t0 <- proc.time()-pt0
  cat('TOTAL TIME', t0[3], 'SECONDS\n\n')

  # return(dat)
  return(dat)
}

# test0 <- extract_features_py('~/Dropbox/D_Filipe_Zabala/audios/coorte')
