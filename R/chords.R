chords <- function(x, pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'){
  note <- lapply(x, notes, method = 'octave')
  reticulate::use_python(pycall)
  pc <- reticulate::import('pychord')

  chord <- vector(length = nrow(x))
  for(i in 1:nrow(x)){
    noteseq <- paste0('note[[i]][', 1:ncol(x), ']', collapse = ', ')
    p <- parse(text = paste0('pc$note_to_chord(c(', noteseq, '))'))
    ifelse(sum(is.na(note[[i]][1:ncol(x)])) > 0,
           chord[i] <- NA,
           chord[i] <- eval(p))
  }
  return(chord)
}
# chords(ef[,c('F0','F1','F2')])
#
# pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'
# x=ef[,c('F0','F1','F2')]
# chords(x)
