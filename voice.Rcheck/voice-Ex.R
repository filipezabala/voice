pkgname <- "voice"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('voice')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("class_svm")
### * class_svm

flush(stderr()); flush(stdout())

### Name: class_svm
### Title: Fits, forecasts and gets performance from SVM models, serial and
###   parallelized.
### Aliases: class_svm

### ** Examples

library(voice)



cleanEx()
nameEx("conv")
### * conv

flush(stderr()); flush(stdout())

### Name: conv
### Title: Convolute vectors.
### Aliases: conv

### ** Examples

(c1 <- conv(1:100, compact.to = 0.2, drop.zeros = TRUE))
length(c1$y)
plot(1:100, type = 'l')
points(c1$x, c1$y, col='red')

(v2 <- c(1:5, rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
length(v2)
conv(v2, 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
conv(v2, 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
conv(v2, 0.2, drop.zeros = TRUE)
conv(v2, 0.2, drop.zeros = FALSE)

(v3 <- c(rep(0,10), 1:20, rep(0,3)))
(c3 <- conv(v3, 1/3, drop.zeros = FALSE, to.data.frame = FALSE))
lapply(c3, length)
plot(v3, type = 'l')
points(c3$x, c3$y, col = 'red')

(v4 <- c(rnorm(1:100)))
(c4 <- conv(v4, 1/4, round.off = 3))



cleanEx()
nameEx("conv_df")
### * conv_df

flush(stderr()); flush(stdout())

### Name: conv_df
### Title: Convolute data frames.
### Aliases: conv_df

### ** Examples

library(voice)

# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
pattern <- glob2rx('*.wav'), full.names = TRUE)

# getting all the 1092 features
ef <- extract_features(dirname(path2wav), features = c('f0','formants',
'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'),
mc.cores = 1)

## Not run: 
##D (cef.df <- conv_df(ef, 0.1, id = 'file_name', mc.cores = 1))
##D (cef.df2 <- conv_df(ef, 0.1, id = 'file_name', drop.x = TRUE, mc.cores = 1))
##D 
##D dim(ef)
##D dim(cef.df)
##D dim(cef.df2)
##D (cef.list <- conv_df(ef, 0.1, id = 'file_name', to.data.frame = FALSE, mc.cores = 1))
## End(Not run)



cleanEx()
nameEx("conv_mc")
### * conv_mc

flush(stderr()); flush(stdout())

### Name: conv_mc
### Title: Convolute vectors using multicore.
### Aliases: conv_mc

### ** Examples

library(voice)
# Same result of conv() function if x is a vector
conv(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = FALSE)
conv_mc(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = FALSE)

conv(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = TRUE)
conv_mc(1:100, compact.to = 0.1, drop.zeros = TRUE, to.data.frame = TRUE)

# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
pattern <- glob2rx('*.wav'), full.names = TRUE)

# getting all the 1092 features
ef <- extract_features(dirname(path2wav), features = c('f0','formants',
'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'),
mc.cores = 1)

ef.num <- ef[-1]
nrow(ef.num)
cm1 <- conv_mc(ef.num, compact.to = 0.1, drop.zeros = TRUE,
to.data.frame = FALSE, mc.cores = 1)
names(cm1)
lapply(cm1$f0, length)



cleanEx()
nameEx("expand_model")
### * expand_model

flush(stderr()); flush(stdout())

### Name: expand_model
### Title: Expand model given 'y' and 'x' variables.
### Aliases: expand_model

### ** Examples

expand_model('y', LETTERS[1:4], 1)
expand_model('y', LETTERS[1:4], 2)
expand_model('y', LETTERS[1:4], 3)
expand_model('y', LETTERS[1:4], 4)



cleanEx()
nameEx("extract_features")
### * extract_features

flush(stderr()); flush(stdout())

### Name: extract_features
### Title: Extracts features from WAV audio files.
### Aliases: extract_features

### ** Examples

library(voice)
library(RColorBrewer)
library(ellipse)
library(ggplot2)
library(grDevices)
library(ggfortify)

# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
pattern <- glob2rx('*.wav'), full.names = TRUE)

# getting all the 1092 features
ef <- extract_features(dirname(path2wav), features = c('f0','formants',
'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'),
mc.cores = 1)
dim(ef)
ef

# using the default, i.e., not using 'cep','dft','css' and 'lps' (4*257 = 1028 columns)
ef2 <- extract_features(dirname(path2wav), mc.cores = 1)
dim(ef2)
ef2
table(ef2$file_name)

# limiting filesRange
ef3 <- extract_features(dirname(path2wav), filesRange = 3:6, mc.cores = 1)
dim(ef3)
ef3
table(ef3$file_name)

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
(pc <- prcomp(na.omit(ef2[-1]), scale = TRUE))
stats::screeplot(pc, type = 'lines')

autoplot(pc, data = na.omit(ef2), colour = 'file_name',
loadings = TRUE, loadings.label = TRUE)



cleanEx()
nameEx("extract_features_py")
### * extract_features_py

flush(stderr()); flush(stdout())

### Name: extract_features_py
### Title: Extract features from WAV audios using Python's Parselmouth
###   library.
### Aliases: extract_features_py

### ** Examples


## Not run: 
##D library(voice)
##D 
##D path2wav <- list.files(system.file('extdata', package = 'wrassp'),
##D pattern <- glob2rx('*.wav'), full.names = TRUE)
##D efp <- extract_features_py(dirname(path2wav))
##D efp
##D table(efp$file_name)
##D 
##D # limiting filesRange
##D efpl <- extract_features_py(dirname(path2wav), filesRange = 3:6)
##D efpl
##D table(efpl$file_name)
## End(Not run)



cleanEx()
nameEx("is_mono")
### * is_mono

flush(stderr()); flush(stdout())

### Name: is_mono
### Title: Verify if an audio is mono.
### Aliases: is_mono

### ** Examples

library(voice)
# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
pattern <- glob2rx('*.wav'), full.names = TRUE)
is_mono(path2wav[1])
sapply(path2wav, is_mono)



cleanEx()
nameEx("memory")
### * memory

flush(stderr()); flush(stdout())

### Name: memory
### Title: Gives the amount of memory RAM free, total and percentage =
###   free/total.
### Aliases: memory

### ** Examples

## Not run: 
##D library(voice)
##D memory()
## End(Not run)



cleanEx()
nameEx("rm0")
### * rm0

flush(stderr()); flush(stdout())

### Name: rm0
### Title: Transforms 'n' sets of 'm>n' zeros (alternated with sets of non
###   zeros) into 'n' sets of 'n' zeros.
### Aliases: rm0

### ** Examples

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



cleanEx()
nameEx("rp")
### * rp

flush(stderr()); flush(stdout())

### Name: rp
### Title: Prenda's rule. Returns '2t+p'.
### Aliases: rp

### ** Examples

rp(0,0) # 0
rp(0,1) # 1
rp(1,0) # 2
rp(1,1) # 3
rp(10,12) # 32
rp(12,10) # 34



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
