# libs
library(tidyverse)

# http://archive.ics.uci.edu/ml/datasets/Arrhythmia
bd = read.table('http://archive.ics.uci.edu/ml/machine-learning-databases/00579/MI.data',
                sep = ',')
bd[bd=='?'] <- NA
sum(is.na(bd))

# exploratória
miss = VIM::aggr(bd, sortVars = T)
mm = miss$missings
quantile(round(mm$Count/nrow(bd),3), probs = seq(0,1,.1))

# função para listar as variáveis com perda máxima limitada (1 traz tudo)
na_filter = function(x, perda.max = 1){
  d = x$missings
  d.ord = d[with(d, order(-Count, Variable)), ]
  d.ord$Prop = d.ord[,'Count']/nrow(x$x)
  filtro = d.ord[d.ord$Prop <= perda.max,'Variable']
  return(filtro)
}
na_filter(miss) # tudo, padrão
na_filter(miss, .05) # perda máxima (NA) de 5%
na_filter(miss, .005) # perda máxima (NA) de 0.5%

# filtrando as variáveis com no máximo 0.5% de perda
bd2 = bd %>%
  dplyr::select(sort(na_filter(miss, .005)))
dplyr::glimpse(bd2)

VIM::aggr(bd2, sortVars = T)
