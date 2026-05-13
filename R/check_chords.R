#' Check chords
#'
#' @description Check the sequence of musical notes for chords.
#' @param x A vector containing a sequence of musical notes.
#' @param window Size of window of notes to be checked. Default: \code{3}.
#' @param try_perm Logical. Must try all notes permutations of notes? Default: \code{FALSE}.
#' @examples
#' \dontrun{
#' library(voice)
#' check_chords(c('C','E','G'), window = 3, try_perm = FALSE)
#' check_chords(c('C','E','G'), window = 3, try_perm = TRUE)
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#' M <- extract_features(path2wav)
#' M$gain[is.na(M$f0)] <- NA
#' # assigning notes
#' f0_spn <- assign_notes(M, fmt = 0)
#' check_chords(f0_spn, window = 3, try_perm = FALSE)
#' check_chords(f0_spn, window = 3, try_perm = TRUE)
#' check_chords(f0_spn, window = 4, try_perm = TRUE)
#' }
#' @export
check_chords <- function(x, window = 3, try_perm = FALSE){

  # import Python libs
  pc <- reticulate::import('pychord')
  mi <- reticulate::import('mingus.core.chords')

  # length
  l <- length(x)

  # checking window > l
  if(window > l){
    cat('Window must be less than or equal to the length!\n')
    return(NA)
  }

  # chords lowercase without space (tabr)
  x_lo <- voice::spn2abc(x, to_lower = TRUE) #TODO: , drop_rep_seq = TRUE)

  # chords uppercase with space
  x_up <- voice::spn2abc(x)

  # major/minor by tabr
  if(try_perm){
    # permutations
    perm_lo <- arrangements::permutations(x_lo, window)
    perm_up <- arrangements::permutations(x_up, window)
    nchord <- nrow(perm_lo) #TODO: pre calculate nchord
    # TODO: clean repeated sequences, drop_rep_seq @ spn2abc?
    chrds <- data.frame(i = NA, seq_notes = NA, major = NA, minor = NA,
                        pychord = NA, mingus = NA)
    for(i in 1:nchord){
      fltr_lo <- perm_lo[i,]
      fltr_lo <- paste0(fltr_lo, collapse = '')
      fltr_up <- perm_up[i,]

      chrds[i,1] <- i
      chrds[i,2] <- toupper(fltr_lo)
      chrds[i,3] <- tabr::chord_is_major(fltr_lo)
      chrds[i,4] <- tabr::chord_is_minor(fltr_lo)
      pychord <- pc$find_chords_from_notes(fltr_up)
      if(length(pychord) > 0){
        chrds[i,5] <- paste0(sapply(pychord, as.character), collapse = ', ')
      }
      mingus <- mi$determine(fltr_up)
      if(length(mingus) > 0){
        chrds[i,6] <- paste0(sapply(mingus, as.character), collapse = ', ')
      }
    }
  } else{
    nchord <- l-window+1
    chrds <- data.frame(i = NA, seq_notes = NA,
                        major = NA, minor = NA,
                        pychord = NA, mingus = NA)
    for(i in 1:nchord){
      fltr_lo <- x_lo[i:(window+i-1)]
      fltr_lo <- paste0(fltr_lo, collapse = '')
      fltr_up <- x_up[i:(window+i-1)]

      chrds[i,1] <- i
      chrds[i,2] <- toupper(fltr_lo)
      chrds[i,3] <- tabr::chord_is_major(fltr_lo)
      chrds[i,4] <- tabr::chord_is_minor(fltr_lo)
      pychord <- pc$find_chords_from_notes(fltr_up)
      if(length(pychord) > 0){
        chrds[i,5] <- paste0(sapply(pychord, as.character), collapse = ', ')
      }
      mingus <- mi$determine(fltr_up)
      if(length(mingus) > 0){
        chrds[i,6] <- paste0(sapply(mingus, as.character), collapse = ', ')
      }
    }
  }
  return(chrds)
}

