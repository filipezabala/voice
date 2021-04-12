# packs
library(tidyverse)
library(gridExtra)
library(ggfortify)
library(ggcorrplot)

# wd
setwd('~/Área de Trabalho/audios Filipe/novos/') # Linux
# setwd('~/Desktop/audios Filipe/novos/') # Mac

# reading data
(bf0NA <- read_csv('./data/bf0NA.csv'))
# (bf <- read_csv('./data/bf.csv'))

# id:anyep_diff_w1 as_factor
bf0NA <- bf0NA %>% 
  mutate_at(vars(id:anyep_diff_w1), as_factor)
# glimpse(bf0NA)

# graficos
# plot2 <- function(df, oque, peloque, legenda = 'none'){
#   chamada <- paste0(df,' %>%
#          ggplot(aes(x = ', oque,', fill = ',peloque,')) +
#          geom_density(alpha = .3) + theme(legend.position = ',legenda,')')
#   assign('p0',ggplot(chamada))
# }
# 
# p0 <- plot2(df = 'bf0NA', oque = 'f0', peloque = 'gender')
# ggplot(p0)

p0 <- bf0NA %>% 
  ggplot(aes(x = f0, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p1 <- bf0NA %>% 
  ggplot(aes(x = f1, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p2 <- bf0NA %>% 
  ggplot(aes(x = f2, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p3 <- bf0NA %>% 
  ggplot(aes(x = f3, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p4 <- bf0NA %>% 
  ggplot(aes(x = f4, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p5 <- bf0NA %>% 
  ggplot(aes(x = f5, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p6 <- bf0NA %>% 
  ggplot(aes(x = f6, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p7 <- bf0NA %>% 
  ggplot(aes(x = f7, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p8 <- bf0NA %>% 
  ggplot(aes(x = f8, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p9 <- bf0NA %>% 
  ggplot(aes(x = zc1, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p10 <- bf0NA %>% 
  ggplot(aes(x = zc2, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p11 <- bf0NA %>% 
  ggplot(aes(x = rms1, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p12 <- bf0NA %>% 
  ggplot(aes(x = rms2, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')
p13 <- bf0NA %>% 
  ggplot(aes(x = mhs1, fill = anyep_diff_w1)) +
  geom_density(alpha = .3) + theme(legend.position = 'bottom')

# f0:f8
gridExtra::grid.arrange(p0,p1,p2,
                        p3,p4,p5,
                        p6,p7,p8, ncol=3)

# zc1:mhs1
gridExtra::grid.arrange(p9, p10,
                        p11,p12,p13, ncol=2)

# preditoras
x <- bf0NA %>% 
  select(f0:mhs1) 

# matriz de correlacao
corr <- round(cor(x), 1)

# Gráfico
ggcorrplot(corr, hc.order = TRUE, 
           type = 'lower', 
           lab = TRUE, 
           lab_size = 3, 
           method = 'circle', 
           colors = c('tomato2', 'white', 'springgreen3'), 
           # title = 'Correlograma de mtcars', 
           ggtheme = theme_bw)
  
# pca
av <- prcomp(bf0NA[,11:24], scale = T)
screeplot(av, type = 'lines')

##
# graficos pca

# id
autoplot(av, data = bf0NA, colour = 'id', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'none')

# wordType
autoplot(av, data = bf0NA, colour = 'wordType', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# gender
autoplot(av, data = bf0NA, colour = 'gender', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# highRisk
autoplot(av, data = bf0NA, colour = 'highRisk', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# algumaDM
autoplot(av, data = bf0NA, colour = 'algumaDM', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# readcomp_diff_w1
autoplot(av, data = bf0NA, colour = 'readcomp_diff_w1', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# read_diff_w1
autoplot(av, data = bf0NA, colour = 'read_diff_w1', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# rspeed_diff_w1
autoplot(av, data = bf0NA, colour = 'rspeed_diff_w1', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# write_diff_w1
autoplot(av, data = bf0NA, colour = 'write_diff_w1', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')

# anyep_diff_w1
autoplot(av, data = bf0NA, colour = 'anyep_diff_w1', loadings = T, 
         loadings.label = T, type = 'raw') +
  theme(legend.position = 'bottom')
