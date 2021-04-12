path <- '~/Dropbox/D_Filipe_Zabala/pacotes/voice/testthat/vad/webrtc-refs_heads_master/common_audio/vad/'
system(paste0('cd ', path), intern=TRUE)
system('R CMD SHLIB vad_core.c', intern=TRUE)
dyn.load('vad.so')
