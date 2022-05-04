# packs
library(tuneR)    # setWavPlayer, readMP3, writeWave
library(wrassp)   # ksvF0, https://cran.r-project.org/web/packages/wrassp/wrassp.pdf
# devtools::install_github('maRce10/warbleR')
library(warbleR)  # checkwaves, mp32wav
library(tidyverse)
# library(multicore) # mclapply

##
# functions

# list to dataframe
list2df <- function(l, coln = NULL, tib = T){
  if(tib){
    df <- as_tibble(matrix(unlist(l), ncol = ncol(l[[1]]), byrow = F,
                           dimnames = list(NULL, coln)))
  }
  if(!tib){
    df <- data.frame(matrix(unlist(l), ncol = ncol(l[[1]]), byrow = F,
                            dimnames = list(NULL, coln)))
  }
  return(df)
}

# troca simbolo antigo por novo
troca <- function(df, ind = ind, old = 0, new = NA){
  filtro <- df[,ind] == old
  df[filtro,ind] <- new
  return(df)
}

# setting wav player
setWavPlayer("/Library/Audio/playRWave")

# wd
setwd('~/Área de Trabalho/audios Filipe/novos/') # Linux
# setwd('~/Desktop/audios Filipe/novos/') # Mac

# converting
# mp32wav(parallel = parallel::detectCores())

# getting file names
(wavFiles <- list.files(getwd(), pattern = glob2rx('*.wav'), 
                        full.names = F, recursive = F))
nWav <- length(wavFiles)

# reading files (stereo)
# (wav <- sapply(wavFiles[1:2], tuneR::readWave))

# converting to mono
# wav <- sapply(wav, tuneR::mono)

##
# extraindo sinal

# F0 analysis of the signal
f0 <- sapply(wavFiles, ksvF0, gender = 'u', toFile = FALSE, windowShift = 5) # Time difference of 16.78553 secs
n <- lapply(f0, length) # tamanho de amostras por audio
ncum <- cumsum(n) # posicoes
write_csv(list2df(f0, coln = 'f0'), './data/f0.csv') # Time difference of 3.457592 secs
rm(f0); gc()

# Formant estimation
fo <- lapply(wavFiles, forest, numFormants = 8, toFile = FALSE, windowShift = 5) # Time difference of 10.7085 mins
fo_fm <- tibble()
fo_bw <- tibble()

for(i in 1:length(fo)){
  fo_fm <- rbind(fo_fm, fo[[i]]$fm)
  fo_bw <- rbind(fo_bw, fo[[i]]$bw)
  print(i/length(fo))
} # Time difference of 21.87718 secs

fo_fm <- as_tibble(fo_fm)
fo_bw <- as_tibble(fo_bw)
colnames(fo_fm) <- paste0('f',1:8)
colnames(fo_bw) <- paste0('b',1:8)
gc()

write_csv(fo_fm, './data/fo_fm.csv') # Time difference of 2.615699 secs
write_csv(fo_bw, './data/fo_bw.csv') # Time difference of 2.697918 secs

rm(fo_fm)
rm(fo_bw)
gc()

# Analysis of the averages of the short-term positive and negative zero-crossing rates
zc <- sapply(wavFiles, zcrana, toFile = FALSE, windowShift = 5) # Time difference of 8.976548 secs
write_csv(list2df(zc, coln = paste0('zc', 1:ncol(zc[[1]]))), './data/zc.csv') # Time difference of 5.759505 secs
rm(zc); gc()

# Analysis of short-term Root Mean Square amplitude
rms <- sapply(wavFiles, rmsana, toFile = FALSE, windowShift = 5) # Time difference of 13.76676 secs
write_csv(list2df(rms, coln = paste0('rms', 1:ncol(rms[[1]]))), './data/rms.csv') # Time difference of 4.181211 secs
rm(rms); gc()

# Pitch analysis of the speech signal using Michel’s (M)odified (H)armonic (S)ieve algorithm
mhs <- sapply(wavFiles, mhsF0, toFile = FALSE, windowShift = 5) # Time difference of 11.08451 mins
write_csv(list2df(mhs, coln = paste0('mhs', 1:ncol(mhs[[1]]))), './data/mhs.csv') # Time difference of 6.294076 secs
rm(mhs); gc()

# Linear Prediction analysis
rfc <- lapply(wavFiles, rfcana, toFile = FALSE, windowShift = 5) # Time difference of 4.691893 mins
rfc2 <- tibble()
rfc2 <- rfc[[1]]$rfc
colnames(rfc2) <- paste0('rfc', 1:ncol(rfc[[1]]$rfc))
for(i in 2:length(rfc)){
  rfc2 <- rbind(rfc2, rfc[[i]]$rfc)
  print(i/(length(rfc)-1))
} # Time difference of 1.49138 mins
write_csv(as.data.frame(rfc2), './data/rfc.csv') # Time difference of 35.81268 secs
rm(rfc)
rm(rfc2); gc()

# Analysis of short-term autocorrelation function
ac <- sapply(wavFiles, acfana, toFile = FALSE, windowShift = 5) # Time difference of 3.169543 mins
write_csv(list2df(ac, coln = paste0('ac', 1:ncol(ac[[1]]))), './data/ac.csv') # Time difference of 16.23109 mins
rm(ac); gc()

# Short-term cepstral analysis (mais de 55.5 GB)
# ce <- sapply(wavFiles, cepstrum, toFile = FALSE, windowShift = 5) # Time difference of 6.682186 mins
# ini <- Sys.time()
# write_csv(list2df(ce, coln = paste0('ce', 1:ncol(ce[[1]]))), './data/ce.csv') # Time difference of 
# Sys.time()-ini
# rm(ce); gc()

# Short-term DFT spectral analysis, 
# dft <- sapply(wavFiles, dftSpectrum, toFile = FALSE, windowShift = 5) # Time difference of 3.006657 mins, 18.0GB RAM
# ini <- Sys.time()
# write_csv(list2df(dft, coln = paste0('dft', 1:ncol(dft[[1]]))), './data/dft.csv') # Time difference of , total 23.5+34.5 = 58GB RAM
# Sys.time()-ini
# rm(dft); gc()

# Cepstral smoothed version of dftSpectrum
# css <- sapply(wavFiles, cssSpectrum, toFile = FALSE, windowShift = 5) # Time difference of 7.476941 mins, 17.2 GB
# ini <- Sys.time()
# write_csv(list2df(css, coln = paste0('css', 1:ncol(css[[1]]))), './data/css.csv') # Time difference of 
# Sys.time()-ini
# rm(css); gc()

# Linear Predictive smoothed version of dftSpectrum
# ini <- Sys.time()
# lps <- sapply(wavFiles, lpsSpectrum, toFile = FALSE, windowShift = 5) # Time difference of
# Sys.time()-ini
# write_csv(list2df(lps, coln = paste0('lps', 1:ncol(lps[[1]]))), './data/lps.csv') # Time difference of 
# rm(lps); gc()

##
# reading databases, 4.0 GB
# suj <- read_rds('/home/filipe/Dropbox/[D] Filipe Zabala/dados/data20190829.rds')
suj <- read_rds('~/Dropbox/[D] Filipe Zabala/dados/data20190829.rds')
f0 <- read_csv('./data/f0.csv') # Time difference of 0.6426399 secs
fo_fm <- read_csv('./data/fo_fm.csv') # Time difference of 1.57177 secs
fo_bw <- read_csv('./data/fo_bw.csv') # Time difference of 1.558442 secs
zc <- read_csv('./data/zc.csv') # Time difference of 2.136677 secs
rms <- read_csv('./data/rms.csv') # Time difference of 1.95483 secs
mhs <- read_csv('./data/mhs.csv') # Time difference of 0.6366496 secs
# ac <- read_csv('./data/ac.csv') # Time difference of 52.06049 secs
# rfc <- read.csv('./data/rfc.csv') # Time difference of 50.01057 secs

##
# obtendo codigos dos sujeitos + tipo
nome <- names(n) # rodar f0 linhas 59-60
nl <- as.numeric(lapply(nome, nchar))
for(i in 1:nWav){
  nome[i] <- substr(nome[i], 1, nl[i]-7)
  print(i/nWav)
}
sujTipo <- as_tibble(matrix(unlist(str_split(nome,'_')), ncol = 2, byrow = T))
colnames(sujTipo) <- c('id','tipo')
sujTipo

##
# sujeitos unicos
(sujUn <- as_tibble(unique(sujTipo$id)))
colnames(sujUn) <- 'id'

# gerando uma sequencia de (indices) impares
impar <- seq(1, nrow(suj), 2)

# genero, 0:Male, 1:Female
gen <- as_tibble(suj$gender[impar]-1)
colnames(gen) <- 'gender'

# alto risco 1:sim, 0:nao
sel <- as_tibble(2-suj$selection[impar])
colnames(sel) <- 'highRisk'

# alguma doenca mental, 1:sim, 0:nao
adm <- as_tibble(suj$dcany[impar]/2)
colnames(adm) <- 'algumaDM'

# readcomp_diff_w1
rcw1 <- as_tibble(suj$readcomp_diff_w1[impar+1]) # pares tem 5 NAs a menos que os impares (todos 0)
colnames(rcw1) <- 'readcomp_diff_w1'

# read_diff_w1
rd1 <- as_tibble(suj$read_diff_w1[impar]) # impares tem 5 NAs a menos que os pares (4 '0', 1 '1')
colnames(rd1) <- 'read_diff_w1'

# rspeed_diff_w1 
rsd1 <- as_tibble(suj$rspeed_diff_w1[impar]) # impares tem 5 NAs a menos que os pares (5 '0')
colnames(rsd1) <- 'rspeed_diff_w1'

# write_diff_w1
wd1 <- as_tibble(suj$write_diff_w1[impar]) # impares tem 5 NAs a menos que os pares (5 '0')
colnames(wd1) <- 'write_diff_w1'

# anyep_diff_w1
ad1 <- as_tibble(suj$anyep_diff_w1[impar]) # impares tem 5 NAs a menos que os pares (4 '0', 1 '1')
colnames(ad1) <- 'anyep_diff_w1'

# colando colunas
(sujUn <- bind_cols(sujUn, gen, sel, adm, rcw1, rd1, rsd1, wd1, ad1))


##
# suj(eito)X(tended)
sujX <- as_tibble(rep(sujTipo$id, n))
wordType <- as_tibble(rep(sujTipo$tipo, n))
sujX <- bind_cols(sujX, wordType)
colnames(sujX) <- c('id','wordType')
(sujX <- left_join(sujX, sujUn, by = 'id'))

# base full
(bf <- bind_cols(sujX, f0, fo_fm, zc, rms, mhs))

# 0 <- NA
(colunas <- colnames(bf))
for(i in colunas[11:24]){
  bf <- troca(bf, i, old = 0, new = NA)
}
bf

# base sem NAs
(bf0NA <- na.omit(bf))
write_csv(bf0NA, './data/bf0NA.csv')

# # interpola NA
# for(i in colunas[6:19]){
#   bf[,i] <- treatNA(bf[,i])[,1]
# }
# bf
# (bf$f0)


# finalmente, escrevendo a base full
write_csv(bf, './data/bf.csv') # Time difference of 10.47393 secs

# removendo dados
rm(wordType)
rm(gender)
rm(suj)
rm(sujX)
rm(f0)
rm(fo_fm)
rm(fo_bw)
rm(zc)
rm(rms)
rm(mhs)
rm(ac)
rm(rfc)
gc()
