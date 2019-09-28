# packs
library(tidyverse)
# library(gridExtra)
# library(ggfortify)
library(e1071)
library(parallelSVM)
library(parallel)
# library(foreach)
# library(itertools)

# wd
setwd('~/Área de Trabalho/audios Filipe/novos/') # Linux
# setwd('~/Desktop/audios Filipe/novos/') # Mac

# functions
# source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/R/class_svm.R')
# source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/testthat/expand_model.R')
# source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/testthat/write_list.R')

# reading data
(bf0NA <- read_csv('./data/bf0NA.csv'))
# (bf <- read_csv('./data/bf.csv'))

# id:anyep_diff_w1 as_factor
bf0NA <- bf0NA %>%
  mutate_at(vars(id:anyep_diff_w1), as_factor)
# glimpse(bf0NA)

# colunas de preditoras
x <- bf0NA %>%
  select(f0:mhs1) %>%
  colnames

# # combinações
expand_model('highRisk', x, 1)
expand_model('highRisk', x, 2)
expand_model('highRisk', x, 3)
expand_model('highRisk', x, length(x))
modelos <- lapply(1:length(x), expand_model, y = 'highRisk', x = x)
sum(unlist(lapply(modelos, length)))

# svm
ini <- Sys.time()
# wf0 <- class_svm(bf0NA, modelo = 'wordType ~ f0') # rever categorias
# write_list(wf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/wf0.txt')
#
# gf0 <- class_svm(bf0NA, modelo = modelos[1])
# gf0 <- class_svm(bf0NA, modelo = 'gender ~ f0')
# write_list(gf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/gf0.txt')
#
# hf0 <- class_svm(bf0NA, modelo = 'highRisk ~ f0')
# write_list(hf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/hf0.txt')
#
# af0 <- class_svm(bf0NA, modelo = 'algumaDM ~ f0')
# write_list(af0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/af0.txt')

rcf0 <- class_svm(bf0NA, modelo = 'readcomp_diff_w1 ~ f0', restart = F)
write_list(rcf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/rcf0.txt')
.rs.restartR()

rf0 <- class_svm(bf0NA, modelo = 'read_diff_w1 ~ f0')
write_list(rf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/rf0.txt')

rsf0 <- class_svm(bf0NA, modelo = 'rspeed_diff_w1 ~ f0')
write_list(rsf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/rsf0.txt')

wdf0 <- class_svm(bf0NA, modelo = 'write_diff_w1 ~ f0')
write_list(wdf0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/wdf0.txt')

aef0 <- class_svm(bf0NA, modelo = 'anyep_diff_w1 ~ f0')
write_list(aef0, '~/Dropbox/[D] Filipe Zabala/dados/modelos/aef0.txt')
Sys.time()-ini
