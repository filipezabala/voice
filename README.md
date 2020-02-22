# voice
General tools for voice analysis.

```
devtools::install_github('filipezabala/voice', force = T)
library(voice)
library(dplyr)

# rm0
(v4 <- c(rep(0,10), 1:10, rep(0,5), 10:20, rep(0,10)))
(r4 <- rm0(v4))
length(r4)

# conv
(v3 <- c(rep(0,10), 1:20, rep(0,3)))
(c3 <- conv(v3, 1/3, drop.zeros = F, to.data.frame = F))
lapply(c3, length)
plot(v3, type = 'l')
points(c3$x, c3$y, col = 'red')

# conv_mc
dat.num <- dat %>%
  select(f0:mhs1)
nrow(dat.num)
cm1 <- conv_mc(dat.num, compact.to = 0.1, drop.zeros = T, to.data.frame = F)
names(cm1)
lapply(cm1$f0, length)

# conv_df
x <- dat %>%
  mutate_each(as.factor, id:anyep_diff_w1)
(cx <- conv_df(x, 0.1))
dim(x)
dim(cx)

# extract_features
?extract_features

# get path to audio file
path2wav <- list.files(system.file("extdata", package = "wrassp"),
pattern = glob2rx("*.wav"), full.names = TRUE)

# getting all the 1092 features
xx <- extract_features(dirname(path2wav))
ncol(xx)
xx

```
