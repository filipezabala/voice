#'  Split Wave
#'
#' @description Split WAV files in \code{fromWav} folder using (same names) RTTM files as guidance.
#' @param fromWav A directory/folder containing WAV files.
#' @param fromRttm A directory/folder containing RTTM files.
#' @param to A directory/folder to write generated files.
#' @param output character string, the class of the object to return, either 'wave' or 'list'.
#' @param filesRange The desired range of directory files (default: \code{NULL}, i.e., all files).
#' @param full.names Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (default: \code{TRUE}) Used by \code{base::list.files}.
#' @param recursive Logical. Should the listing recursively into directories? (default: \code{FALSE}) Used by \code{base::list.files}.
#' @examples
#' library(voice)
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#'                                    pattern <- glob2rx('*.wav'), full.names = TRUE)
#' dir.create(rttm <- paste0(dirname(path2wav)[1], '/rttm/'))
#' wsw(from = dirname(path2wav)[1], to = rttm)
#'
#' dir.create(split <- paste0(dirname(path2wav)[1], '/split/'))
#' splitw(fromWav = dirname(path2wav)[1], fromRttm = rttm,
#'                          to = split, output = 'wave')
#' @export
splitw <- function(fromWav, fromRttm, to = NULL, output = 'wave',
                   filesRange = NULL,
                   full.names = TRUE,
                   recursive = FALSE){

  # listing WAV files
  wavFiles <- list.files(fromWav, pattern = '[[:punct:]][wW][aA][vV]$',
                         full.names = full.names, recursive = recursive)

  # listing RTTM files
  rttmFiles <- list.files(fromRttm, pattern = '[[:punct:]][rR][tT][tT][mM]$',
                          full.names = full.names, recursive = recursive)

  # filtering by fileRange
  if(!is.null(filesRange)){
    fullRange <- 1:length(wavFiles)
    filesRange <- base::intersect(fullRange,filesRange)
    wavFiles <- wavFiles[filesRange]
    rttmFiles <- rttmFiles[filesRange]
  }

  # number of WAV files to be extracted
  nWav <- length(wavFiles)

  # reading WAV
  audio <- sapply(wavFiles, tuneR::readWave)

  # reading RTTM
  rttm <- lapply(rttmFiles, utils::read.table)
  colnames <- c('type','file','chnl','tbeg','tdur',
                'ortho','stype','name','conf','slat')
  rttm <- lapply(rttm, stats::setNames, colnames)

  # useful functions
  get_tbeg <- function(x){
    return(x$tbeg)
  }
  get_tdur <- function(x){
    return(x$tdur)
  }
  get_left <- function(x){
    return(x@left)
  }
  get_right <- function(x){
    return(x@right)
  }
  get_samp.rate <- function(x){
    return(x@samp.rate)
  }
  get_bit <- function(x){
    return(x@bit)
  }

  # time beginning, duration and endind
  tbeg <- sapply(rttm, get_tbeg)
  tdur <- sapply(rttm, get_tdur)
  tend <- Map('+', tbeg, tdur)

  # defining break points
  breaks <- Map('c', tbeg, tend)
  breaks <- lapply(breaks, sort)
  nbreaks <- sapply(breaks, length)
  index <- lapply(nbreaks, seq, from = 2, by = 2)

  # audio information
  freq <- sapply(audio, get_samp.rate)
  # bit <- sapply(audio, get_bit)
  # left <- lapply(audio, get_left)
  # right <- lapply(audio, get_right)
  # totlen <- sapply(audio, length)
  # totsec <- totlen/freq


  # split.audio - Do parallel/vectorized!
  split.audio <- function(x, index, breaks, freq){
    splaudio <- vector('list', length(x))
    for(i in 1:length(x)){
      splaudio[[i]] <- vector('list', length(index[[i]]))
      for(j in index[[i]]){
        splaudio[[i]][[j/2]] <- x[[i]][(freq[i]*breaks[[i]][j-1]):(freq[i]*breaks[[i]][j])]
      }
    }
    return(splaudio)
  }
  sa <- split.audio(x=audio, index=index, breaks=breaks, freq=freq)

  # splitted audio information
  bitSpl <- lapply(unlist(sa), get_bit)
  freqSpl <- lapply(unlist(sa), get_samp.rate)
  leftSpl <- lapply(unlist(sa), get_left)
  rightSpl <- lapply(unlist(sa), get_right)

  # writing output as a list
  if(output == 'list'){
    if(!is.null(to)){
      timest <- format(Sys.time(), "%Y-%m-%d_%H-%M-%S")
      write_list(x=sa, path=paste0(to,'/list_', timest, '.txt'))
    }
    return(sa)
  }

  # writing output as wave
  if(output == 'wave'){
    fileName <- do.call(rbind, strsplit(basename(wavFiles), '[.]'))
    fileNameSplit <- vector('list', length(nbreaks))
    k <- 0
    audioWave <- vector('list', sum(nbreaks)/2)
    for(i in 1:length(nbreaks)){
      for(j in (nbreaks[i]/2)){
        fileNameSplit[[i]] <- paste0(fileName[i,1], '_split_', 1:j, '.',
               fileName[i,2])
      }
    }

    # Save the files
    pathNameSplit <- sapply(fileNameSplit, function(x) paste0(to, '/', x))
    for(i in 1:length(audio)){
      for(j in 1:length(sa[[i]])){
        tuneR::writeWave(sa[[i]][[j]], filename = pathNameSplit[[i]][j])
      }
    }
  }

}
