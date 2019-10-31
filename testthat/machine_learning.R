# packs
library(tidyverse)
library(e1071)
library(parallel)
library(parallelSVM)
library(ggfortify)
# library(gridExtra)
# library(foreach)
# library(itertools)

# wd
setwd('~/Área de Trabalho/audios Filipe/novos/') # Linux
# setwd('~/Desktop/audios Filipe/novos/') # Mac

# functions
source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/R/class_svm.R')
source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/testthat/rp.R')
source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/testthat/expand_model.R')
source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/testthat/restart.R')
source('../../../Dropbox/[D] Filipe Zabala/pacotes/voice/testthat/write_list.R')

# reading data
(df0NA <- read_csv('./data/df0NA.csv'))
# (bf <- read_csv('./data/bf.csv'))

# id:anyep_diff_w1 as_factor
df0NA <- df0NA %>%
  mutate_at(vars(id:anyep_diff_w1), as_factor)
# glimpse(df0NA)

# predictor candidates
X <- df0NA %>%
  select(f0:mhs1) %>%
  colnames
nX <- length(X)

# eigen-values and -vectors
co <- cor(df0NA[,X])
ev <- prcomp(df0NA[,X], scale = T)
e.vector <- ev$rotation
e.values <- ev$sdev^2

# plots
# autoplot(ev, data = df0NA, colour = 'gender', loadings = T, loadings.label = T)
# autoplot(ev, data = df0NA, colour = 'readcomp_diff_w1', loadings = T, loadings.label = T)
# autoplot(ev, data = df0NA, colour = 'read_diff_w1', loadings = T, loadings.label = T)
# autoplot(ev, data = df0NA, colour = 'rspeed_diff_w1', loadings = T, loadings.label = T)
# autoplot(ev, data = df0NA, colour = 'write_diff_w1', loadings = T, loadings.label = T)
# autoplot(ev, data = df0NA, colour = 'anyep_diff_w1', loadings = T, loadings.label = T)


# weighted X
wX <- vector(mode = 'list', length = nX)
for(i in 1:nX){
  w <- e.vector[,i]
  wX[[i]] <- as.matrix(df0NA[,X]) %*% as.matrix(w)
}
wX.matrix <- do.call(cbind, wX)
colnames(wX.matrix) <- tolower(colnames(ev$rotation))
df0NA <- cbind(df0NA, wX.matrix)
dim(df0NA)

# models
for(i in 1:3) {
  (model <- expand_model('anyep_diff_w1', paste0('pc',1:nX), i))
  fit <- class_svm(df0NA, modelo = model[1])
  write_csv(fit$result, paste0('~/Dropbox/[D] Filipe Zabala/dados/modelos/fit-',
                                 model[1], '.csv'))
  write_list(fit$cm.svm, paste0('~/Dropbox/[D] Filipe Zabala/dados/cm/cm-',
                                  model[1], '.txt'))
  write_list(fit$cm.svm.tab, paste0('~/Dropbox/[D] Filipe Zabala/dados/cm/cm.tab-',
                                      model[1], '.txt'))
  gc()
  # restart()
  # rm(e)
  # gc(verbose = T, reset = T)
  # gctorture(on = F)
  # gctorture2(step, wait = step, inhibit_release = FALSE)

# readcomp_diff_w1
# read_diff_w1
# rspeed_diff_w1
# write_diff_w1
# anyep_diff_w1
}
restart()

# # combinações
# expand_model('highRisk', x, 1)
# expand_model('highRisk', x, 2)
# expand_model('highRisk', x, 3)
# expand_model('highRisk', x, length(x))
# modelos <- lapply(1:length(x), expand_model, y = 'highRisk', x = x)
# sum(unlist(lapply(modelos, length)))



# svm
ini <- Sys.time()

# AUTOMATIZAR!
# fit_models <- function(df, y, x, n.vars = 1, loop = 1:7, path = getwd()){
#
# df = df0NA
# y = 'readcomp_diff_w1'
# x = X
# n.vars = 1
# loop = 8
# i = loop
# path = getwd()
#
#   models_full <- lapply(1:length(x), expand_model, y = y, x = x)
#
#   for(i in loop){
#     model_name <- paste0('models_',y,'[[',n.vars,']][',i,']')
#     model_svm <- class_svm(df, modelo = y)
#     folder <- paste0(path, y, model_name, '.csv')
#     write_csv(model_svm$result, paste0(folder,'.csv'))
#     write_list(model_svm$cm.svm, paste0('~/Dropbox/[D] Filipe Zabala/dados/cm/cm-',
#                                     models_anyep_diff_w1[[n.vars]][i], '.txt'))
#     write_list(model_svm$cm.svm.tab, paste0('~/Dropbox/[D] Filipe Zabala/dados/cm/cm.tab-',
#                                         models_anyep_diff_w1[[1]][i], '.txt'))
#   }
#
#
# }



models_gender <- lapply(1:length(X), expand_model, y = 'gender', x = X)
# models_highRisk <- lapply(1:length(X), expand_model, y = 'highRisk', x = X)
models_readcomp_diff_w1 <- lapply(1:length(X), expand_model, y = 'readcomp_diff_w1', x = X)
models_read_diff_w1 <- lapply(1:length(X), expand_model, y = 'read_diff_w1', x = X)
models_rspeed_diff_w1 <- lapply(1:length(X), expand_model, y = 'rspeed_diff_w1 ', x = X)
models_write_diff_w1 <- lapply(1:length(X), expand_model, y = 'write_diff_w1 ', x = X)
models_anyep_diff_w1 <- lapply(1:length(X), expand_model, y = 'anyep_diff_w1 ', x = X)

for(i in 8:14) {
  # e <- new.env()
  model <- class_svm(df0NA, modelo = models_gender[[1]][i])
  write_csv(model$result, paste0('~/Dropbox/[D] Filipe Zabala/dados/modelos/model-',
                                 models_gender[[1]][i], '.csv'))
  write_list(model$cm.svm, paste0('~/Dropbox/[D] Filipe Zabala/dados/cm/cm-',
                                  models_gender[[1]][i], '.txt'))
  write_list(model$cm.svm.tab, paste0('~/Dropbox/[D] Filipe Zabala/dados/cm/cm.tab-',
                                      models_gender[[1]][i], '.txt'))
  gc()
  # restart()
  # rm(e)
  # gc(verbose = T, reset = T)
  # gctorture(on = F)
  # gctorture2(step, wait = step, inhibit_release = FALSE)
}
# beepr::beep(1)
