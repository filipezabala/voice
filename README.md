# `voice`

General tools for voice analysis. The `voice` package is being developed to be an easy-to-use set of tools to deal with audio analysis in R. It is based on [`tidyverse`](https://www.tidyverse.org/) collection, [`tuneR`](https://cran.r-project.org/web/packages/tuneR/index.html), [`wrassp`](https://cran.r-project.org/web/packages/wrassp/index.html), as well as [Parselmouth](https://github.com/YannickJadoul/Parselmouth), a Python library for the [Praat](http://www.praat.org/) software. 

## Installation
### The R part
To make full use of the R part of the `voice` package you may use the following code.
```
packs <- c('devtools', 'tidyverse', 'tuneR', 'wrassp', 'ellipse', 'RColorBrewer', 'ggfortify', 'pca3d')
install.packages(packs, dep = T)
devtools::install_github('filipezabala/voice', force = T)
```
### The Python part
To make use of the Python part of the `voice` package the user must be aware of the incresing of complexity of maintaining and operating simultaneously two systems.
...

### Examples
#### `rm0`
Remove zeros.
```
library(voice)
# rm0
(v4 <- c(rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
(r4 <- rm0(v4))
length(r4)
```
#### `conv`
Convolute vectors.
```
library(voice)
# conv
(v3 <- c(rep(0,10), 1:20, rep(0,3)))
(c3 <- conv(v3, 1/3, drop.zeros = F, to.data.frame = F))
lapply(c3, length)
plot(v3, type = 'l')
points(c3$x, c3$y, col = 'red')
```
#### `conv_mc`
Convolute vectors using multicore.
```
library(voice)
# conv_mc
dat.num <- dat %>%
  select(f0:mhs1)
nrow(dat.num)
cm1 <- conv_mc(dat.num, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
names(cm1)
lapply(cm1$f0, length)
```
#### `conv_df`
Convolute data frames using multicore.
```
library(voice)
# conv_df
x <- dat %>%
  mutate_each(as.factor, id:anyep_diff_w1)
(cx <- conv_df(x, 0.1))
dim(x)
dim(cx)
```
#### `extract_features`
Extract features using `tuneR` and `wrassp` functions.
````
library(voice)

# get path to audio file
path2wav <- list.files(system.file("extdata", package = "wrassp"),
pattern <- glob2rx("*.wav"), full.names = TRUE)

# getting all the 1092 features
ef <- extract_features(dirname(path2wav), features = c('f0','formants',
'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'))
dim(ef)
ef

# using the default, i.e., not using 'cep','dft','css' and 'lps' (4*257 = 1028 column
ef2 <- extract_features(dirname(path2wav))
dim(ef2)
ef2
table(ef2$file_name)

# limiting filesRange
ef3 <- extract_features(dirname(path2wav), filesRange = 3:6)
dim(ef3)
ef3
table(ef3$file_name)

library(ellipse)
library(RColorBrewer)

# calculating correlation of ef2
data <- cor(ef2[-1])

# pane with 100 colors using RcolorBrewer
my_colors <- brewer.pal(5, "Spectral")
my_colors <- colorRampPalette(my_colors)(100)

# ordering the correlation matrix
ord <- order(data[1, ])
data_ord <- data[ord, ord]
plotcorr(data_ord , col=my_colors[data_ord*50+50] , mar=c(1,1,1,1))

# Principal Component Analysis (PCA)
(pc <- prcomp(ef2[-1], scale = T))
screeplot(pc, type = 'lines')

library(ggfortify)
autoplot(pc, data = ef2, colour = 'file_name', loadings = T, loadings.label = T)

library(pca3d)
pca3d(pc, group=ef2$file_name)
```
