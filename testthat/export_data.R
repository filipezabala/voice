library(tidyverse)
library(devtools)

setwd('./data/')

(dat <- read_csv('~/Dropbox/[D] Filipe Zabala/thesis/df0NA.csv'))
use_data(dat, overwrite = TRUE)
