# `voice`

General tools for voice analysis. The `voice` package is being developed to be an easy-to-use set of tools to deal with audio analysis in R. It is based on [`tidyverse`](https://www.tidyverse.org/) collection, [`tuneR`](https://cran.r-project.org/web/packages/tuneR/index.html), [`wrassp`](https://cran.r-project.org/web/packages/wrassp/index.html), as well as [Parselmouth](https://github.com/YannickJadoul/Parselmouth) - a Python library for the [Praat](http://www.praat.org/) software. 

## Installation
### The R part
To make full use of the R part of the `voice` package you may use the following code.
```r
packs <- c('devtools', 'tidyverse', 'tuneR', 'wrassp', 'reticulate', 'ellipse',
           'RColorBrewer', 'ggfortify', 'pca3d')
install.packages(packs, dep = T)
update.packages(ask = F)

devtools::install_github('filipezabala/voice', force = T)
```
### The Python part
To make use of the Python part of the `voice` package the user must be aware of the increased complexity to manage and maintain simultaneously two systems. 
#### At R
```r
reticulate::py_config()
R.home()
```
#### At command-line
The following instructions should work on [command-line](https://en.wikipedia.org/wiki/Command-line_interface) of [Unix-like](https://en.wikipedia.org/wiki/Unix-like) systems.
```bash
pip3 install numpy pandas praat-parselmouth
```

## Examples
### `rm0`
Transforms `n` sets of `m>n` zeros (alternated with sets of non zeros) into `n` sets of `n` zeros.
```r
library(voice)

(v0 <- c(1:20,rep(0,10)))
(r0 <- rm0(v0))
length(v0)
length(r0)
sum(v0 == 0)

(v1 <- c(rep(0,10),1:20))
(r1 <- rm0(v1))
length(r1)

(v2 <- rep(0,10))
(r2 <- rm0(v2))
length(r2)

(v3 <- c(0:10))
(r3 <- rm0(v3))
length(r3)

(v4 <- c(rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
(r4 <- rm0(v4))
length(r4)
sum(v4 == 0)
```
### `conv`
Convolute vectors.
```r
library(voice)

(c1 <- conv(1:100, compact.to = 0.2, drop.zeros = T))
length(c1$y)
plot(1:100, type = 'l')
points(c1$x, c1$y, col='red')

(v2 <- c(1:5, rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
length(v2)
conv(v2, 0.1, drop.zeros = T, to.data.frame = F)
conv(v2, 0.1, drop.zeros = T, to.data.frame = T)
conv(v2, 0.2, drop.zeros = T)
conv(v2, 0.2, drop.zeros = F)

(v3 <- c(rep(0,10), 1:20, rep(0,3)))
(c3 <- conv(v3, 1/3, drop.zeros = F, to.data.frame = F))
lapply(c3, length)
plot(v3, type = 'l')
points(c3$x, c3$y, col = 'red')
```
### `conv_mc`
Convolute vectors using multicore.
```r
library(voice)

# Same result of conv() function if x is a vector
conv(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
conv_mc(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = F)

conv(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = T)
conv_mc(1:100, compact.to = 0.1, drop.zeros = T, to.data.frame = T)

dat.num <- dat %>%
  select(f0:mhs1)
nrow(dat.num)
cm1 <- conv_mc(dat.num, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
names(cm1)
lapply(cm1$f0, length)
```
### `conv_df`
Convolute data frames using multicore.
```r
library(voice)

x <- dat %>%
  mutate_each(as.factor, id:anyep_diff_w1)
(cx.df <- conv_df(x, 0.1))
(cx.df2 <- conv_df(x, 0.1, drop.x = T))
dim(x)
dim(cx.df)
dim(cx.df2)
(cx.list <- conv_df(x, 0.1, to.data.frame = F))
```
### `extract_features`
Extract features from WAV files using `tuneR` and `wrassp` functions.
```r
library(voice)

# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern <- glob2rx('*.wav'), full.names = TRUE)

# getting all the 1092 features
ef <- extract_features(dirname(path2wav), 
                       features = c('f0','formants','zcr','mhs','rms','gain',
                                    'rfc','ac','cep','dft','css','lps','mfcc'))
dim(ef)
ef

# using the default, i.e., not using 'cep','dft','css' and 'lps' (4*257 = 1028 columns)
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
my_colors <- brewer.pal(5, 'Spectral')
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
### `extract_features_py`
Extract features from WAV files using Python's `parselmouth`.
```r
library(voice)

path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern <- glob2rx('*.wav'), full.names = TRUE)
efp <- extract_features_py(dirname(path2wav))
efp
table(efp$file_name)

# limiting filesRange
efpl <- extract_features_py(dirname(path2wav), filesRange = 3:6)
efpl
table(efpl$file_name)
```
