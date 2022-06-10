chords <- function(x, pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'){
  note <- lapply(x, notes, method = 'octave')
  reticulate::use_python(pycall)
  pc <- reticulate::import('pychord')

  chord <- vector('list', length = nrow(x))
  noteseq <- paste0('note[[', 1:ncol(x), ']][i]', collapse = ', ')
  p <- parse(text = paste0('pc$note_to_chord(c(', noteseq, '))'))
  for(i in 1:nrow(x)){
    cond <- sum(is.na(eval(parse(text = paste0('c(', noteseq, ')')))))
    ifelse(cond > 0,
           chord[[i]] <- NA,
           chord[[i]] <- eval(p)
           )
    print(i/nrow(x))
  }
  return(chord)
}

# acor <- chords2(ef[,2:5])
# pc$Quality(c('C', 'E', 'G'))
# pc$note_to_chord(c(note[[1]][i], note[[2]][i], note[[3]][i]))
# pc$note_to_chord(c('C', 'E', 'G'))
# pc$note_to_chord(c('E', 'C', 'G'))
# pc$note_to_chord(c('C', 'E', 'F'))
# pc$note_to_chord(c('A', 'C', 'F','D'))
#
# library(combinat)
# x1 <- c(note[[1]][i], note[[2]][i], note[[3]][i])
# lapply(permn(x1),  pc$note_to_chord)
#
# pc$Chord
#
# c = pc$Chord("A7")
# c$info
# c$from_note_index
# c$quality
# c2 <- c$transpose(3L)
#
# pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'
# x = ef[,c('F0','F1','F2','F3')]
# chords2(x)
#
# chords(ef[,c('F0','F1','F2')])
