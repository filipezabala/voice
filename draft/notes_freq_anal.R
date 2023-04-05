# packs
library(voice)
library(DescTools)
library(caTools)

# variation coefficient function
vc <- function(x){
  return(sd(x, na.rm = T)/mean(x, na.rm = T))
}

# interval function
interval <- function(x, as_df = FALSE){
  k <- 615846/10689493
  l <- (1-k/2)*x
  h <- (1+k/2)*x
  lst <- list(x,l,h)
  names(lst)[1] <- 'freq'
  names(lst)[2] <- 'freq_lo'
  names(lst)[3] <- 'freq_hi'
  if(!as_df){
    return(lst)
  }
  if(as_df){
    tb <- dplyr::tibble(
      freq = x, freq_lo = l, freq_hi = h
    )
    return(tb)
  }
}
# interval(129.7)
# interval(129.7, T)
# interval(120:130)
# interval(120:130, T)

# get list slice
getx <- function(x, i=1){
  x[[i]]
}

# overlap proportion
overlaprop <- function(x){
  n <- length(x$freq)
  op <- vector(length = n)
  op[1] <- NA
  for(i in 2:n){
    ant <- c(x$freq_lo[i-1], x$freq_hi[i-1]) # antecessor
    suc <- c(x$freq_lo[i], x$freq_hi[i]) # successor
    lant <- diff(ant) # length of antecessor
    lsuc <- diff(suc) # length of successor
    o <- DescTools::Overlap(ant, suc) # overlap
    op[i] <- o/min(lant, lsuc) # overlap proportion
  }
  return(op)
}

# filters
fltr <- function(x){
  return(c(0, cumsum(abs(diff(x)))))
}





# getting coefficient
nf <- voice::notes_freq()

f <- nf$freq
plot(f)
plot(log(f))
t <- 1:length(f)
fit <- lm(log(f) ~ t)
summary(fit)
exp(fit$coefficients)


A <- nf$spn.hi-nf$spn.lo
plot(A)
plot(log(A))
t <- 1:length(A)
fit <- lm(log(A) ~ t)
summary(fit)
exp(fit$coefficients)

x <- nf$freq
par(mfrow=c(1,1))
plot(x,y)
abline(0, fit$coefficients[1], col = 'red')

fit <- lm(f ~ x - 1)
summary(fit)
par(mfrow=c(2,2))
plot(fit, 1:4)


sprintf("%.200f", fit$coefficients[1])

# 1/10 of Euler–Mascheroni constant??
# https://en.wikipedia.org/wiki/Euler%27s_constant
# 0.57721566490153286060651209008240243104215933593992
0.57721566490153286060651209008240243104215933593992/10

cte <- 0.05761227403395673130059861932750209234654903411865234375
cte_fr <- MASS::fractions(cte) # 615846/10689493
sprintf("%.200f", cte-cte_fr)

a <- 130*cte
130+a/2
130-a/2


# https://filipezabala.com/voicegnette/
# url0 <- 'https://github.com/filipezabala/voiceAudios/blob/main/mp3/doremi.mp3?raw=true'
# download.file(url0, paste0(tempdir(), '/doremi.mp3'), mode = 'wb')
# cmd <- paste0('cd ', tempdir(), ';',
#               ' for i in *.[Mm][Pp]3; do ffmpeg -i "$i" -ac 1 "./${i%.*}.wav"; done')
# system(cmd)
# M <- voice::extract_features(tempdir(), features = c('f0', 'gain', 'zcr'))

# mp3File <- '~/Downloads/voiceAudios/mp3Dir/doremi.mp3'
# cmd <- paste0('cd ', dirname(mp3File), ';',
#               ' for i in *.[Mm][Pp]3; do ffmpeg -i "$i" -ac 1 "./${i%.*}.wav"; done')
# system(cmd)
wavFile <- '~/Downloads/voiceAudios/mp3Dir/doremi.wav'

M <- voice::extract_features(wavFile, features = 'f0', windowShift = 5)
dim(M)
summary(M)

# F0 smooth
k <- 19
M$f0_smth  <- caTools::runquantile(M$f0, k, .5)
M$f0_smth[is.nan(M$f0_smth)] <- NA

# f0_exists (raw)
M$f0_exists <- !is.na(M$f0)

# f0_exists (smooth)
M$f0_exists_smth <- !is.na(M$f0_smth)

# f0 intervals and overlap proportions
if0 <- interval(M$f0)
M$overlaprop <- overlaprop(if0)
M$overlaprop[is.na(M$overlaprop)] <- 0

# f0 smooth intervals and overlap proportions
if0_smth <- interval(M$f0_smth)
M$overlaprop_smth <- overlaprop(if0_smth)
M$overlaprop_smth[is.na(M$overlaprop_smth)] <- 0

# Not NA (note/F0) interval
M$f0_notna <- c(0, diff((M$f0_exists)))

# Not NA (note/F0) interval smoothed
M$f0_notna_smth <- c(0, diff((M$f0_exists_smth)))

# Overlap interval
M$f0_overlap <- c(0, diff((M$overlaprop)))

# Overlap interval smooth
M$f0_overlap_smth <- c(0, diff((M$overlaprop_smth)))

# median by filter F0_EXISTS
md_f0_exists <- by(M$f0, fltr(M$f0_exists), median)
md_f0_exists <- sapply(md_f0_exists, getx)
(na <- sapply(md_f0_exists, is.na))
(md_f0_exists <- md_f0_exists[!na])

# median by filter F0_EXISTS smooth
md_f0_exists_smth <- by(as.numeric(M$f0_smth), fltr(M$f0_exists_smth), median)
md_f0_exists_smth <- sapply(md_f0_exists_smth, getx)
(na <- sapply(md_f0_exists_smth, is.na))
(md_f0_exists_smth <- md_f0_exists_smth[!na])


# PAREI AQUI!!
d_f0_smth <- diff(M$f0_smth)
M$f0_stable <- c(0, abs(d_f0_smth)) < .999
M$f0_stable[is.na(M$f0_stable)] <- FALSE

# median by filter F0_STABLE
md_f0_stable <- by(M$f0, fltr(M$f0_stable), median)
md_f0_stable <- sapply(md_f0_stable, getx)
(na <- sapply(md_f0_stable, is.na))
(md_f0_stable <- md_f0_stable[!na])



## OLD DOREMI

# C3, D3, E4, F3, G3, A3, B3, C4
(est_notes_notna <- voice::notes(med_freq_notna))
length(est_notes_notna)
length(est_notes_notna)-8

# median by filter overlaprop > 0.1, ..., 0.9
md_overlap <- by(M$f0,
                 fltr(M$has_f0 | caTools::runquantile(M$overlaprop, 30, .5) > .86),
                 median)
med_freq_overlap <- sapply(md_overlap, getx)
(na <- sapply(med_freq_overlap, is.na))
med_freq_overlap <- med_freq_overlap[!na]

# C3, D3, E4, F3, G3, A3, B3, C4
(est_notes_overlap <- voice::notes(med_freq_overlap))
length(est_notes_overlap)
length(est_notes_overlap)-8



# Plot
par(mfrow=c(4,1))
plot(M$f0, pch = '.', main = 'F0 raw with interval')

plot(M$f0_smth, pch = '.',
     main = paste0('F0 smooth k=', k))


# limits
points(if0$freq_lo, pch = '.', col = 'red')
points(if0$freq_hi, pch = '.', col = 'red')
#
# F0 NA's cumulated sum's !diff plot
plot(M$f0_exists, pch = '.', main = 'Does F0 exists? 1:yes, 0:no')

# # Not NA interval (+1 begins, -1 ends)
# plot(M$f0_notna, pch = '.',
#      main = 'Not NA interval, +1:begins (green), -1:ends (red)')
# beg <- which(M$f0_notna == 1)
# end <- which(M$f0_notna == -1)
# points(beg, M$f0_notna[beg], col = 'green')
# points(end, M$f0_notna[end], col = 'red')

# plot F0 overlap proportions
plot(M$overlaprop, pch = '.', main = 'Overlap proportions, [n]-[n-1]')
abline(h = 0.5, col = 'red')

# plot F0 overlap proportions smooth
plot(M$overlaprop_smth, pch = '.', main = 'Overlap proportions smooth, [n]-[n-1]')
abline(h = 0.5, col = 'red')

# plot diff Foverlaprop_smth
plot(diff(M$overlaprop_smth), pch = '.',
     main = paste0('Diff overlap proportions smooth k=', k))

# plot(caTools::runmad(M$overlaprop, 7), pch = '.')
# plot(caTools::runsd(M$overlaprop, 7), pch = '.')
# plot(caTools::runmax(M$overlaprop, 7), pch = '.')
# plot(caTools::runmin(M$overlaprop, 7), pch = '.')

# # Gain plot
# plot(M$gain, pch = '.')
# abline(h = 0, col = 'red')

# # Zero Crossing Rate plot
# plot(M$zcr1, pch = '.')
#


# notes summary
C3_pts <- 1:150
(C3_md <- median(M$f0[C3_pts], na.rm = TRUE))
voice::notes(C3_md)
(C3_sd <- sd(M$f0[C3_pts], na.rm = TRUE))
(C3_vc <- vc(M$f0[C3_pts]))
(C3_mad <- mad(M$f0[C3_pts], na.rm = TRUE))

D3_pts <- 190:280
(D3_md <- median(M$f0[D3_pts], na.rm = TRUE))
voice::notes(D3_md)
(D3_sd <- sd(M$f0[D3_pts], na.rm = TRUE))
(D3_vc <- vc(M$f0[D3_pts]))
(D3_mad <- mad(M$f0[D3_pts], na.rm = TRUE))

E4_pts <- 310:380
(E4_md <- median(M$f0[E4_pts], na.rm = TRUE))
voice::notes(E4_md)
(E4_sd <- sd(M$f0[E4_pts], na.rm = TRUE))
(E4_vc <- vc(M$f0[E4_pts]))
(E4_mad <- mad(M$f0[E4_pts], na.rm = TRUE))

F3_pts <- 420:500
(F3_md <- median(M$f0[F3_pts], na.rm = TRUE))
voice::notes(F3_md)
(F3_sd <- sd(M$f0[F3_pts], na.rm = TRUE))
(F3_vc <- vc(M$f0[F3_pts]))
(F3_mad <- mad(M$f0[F3_pts], na.rm = TRUE))

G3_pts <- 590:630
(G3_md <- median(M$f0[G3_pts], na.rm = TRUE))
voice::notes(G3_md)
(G3_sd <- sd(M$f0[G3_pts], na.rm = TRUE))
(G3_vc <- vc(M$f0[G3_pts]))
(G3_mad <- mad(M$f0[G3_pts], na.rm = TRUE))

A3_pts <- 700:770
(A3_md <- median(M$f0[A3_pts], na.rm = TRUE))
voice::notes(A3_md)
(A3_sd <- sd(M$f0[A3_pts], na.rm = TRUE))
(A3_vc <- vc(M$f0[A3_pts]))
(A3_mad <- mad(M$f0[A3_pts], na.rm = TRUE))

B3_pts <- 820:900
(B3_md <- median(M$f0[B3_pts], na.rm = TRUE))
voice::notes(B3_md)
(B3_sd <- sd(M$f0[B3_pts], na.rm = TRUE))
(B3_vc <- vc(M$f0[B3_pts]))
(B3_mad <- mad(M$f0[B3_pts], na.rm = TRUE))

C4_pts <- 950:1100
(C4_md <- median(M$f0[C4_pts], na.rm = TRUE))
voice::notes(C4_md)
(C4_sd <- sd(M$f0[C4_pts], na.rm = TRUE))
(C4_vc <- vc(M$f0[C4_pts]))
(C4_mad <- mad(M$f0[C4_pts], na.rm = TRUE))


# testing in RAVDESS, https://zenodo.org/record/1188976#.Y36PhuzMI-R
# Modality (01 = full-AV, 02 = video-only, 03 = audio-only).
# Vocal channel (01 = speech, 02 = song).
# Emotion (01 = neutral, 02 = calm, 03 = happy, 04 = sad, 05 = angry, 06 = fearful, 07 = disgust, 08 = surprised).
# Emotional intensity (01 = normal, 02 = strong). NOTE: There is no strong intensity for the 'neutral' emotion.
# Statement (01 = "Kids are talking by the door", 02 = "Dogs are sitting by the door").
# Repetition (01 = 1st repetition, 02 = 2nd repetition).
# Actor (01 to 24. Odd numbered actors are male, even numbered actors are female).
fl <- '~/MEGAsync/D_Filipe_Zabala/audios/ravdess/songs/03-02-01-01-01-01-01.wav'
M <- voice::extract_features(fl, features = c('f0'), windowShift = 10)
summary(M)
# file.show(fl)

# smooth F0
k <- 7
# zeros <- rep(0, nrow(M)-(nrow(M)-k+1))
M$f0_smth <- caTools::runquantile(M$f0, k, .5)
M$f0_smth[is.nan(M$f0_smth)] <- NA

# has_f0
M$has_f0 <- !is.na(M$f0_smth)

# f0 intervals and overlap proportions (original)
if0 <- interval(M$f0)
M$overlaprop <- overlaprop(if0)
M$overlaprop[is.na(M$overlaprop)] <- 0

# f0 intervals and overlap proportions (smooth)
if0_smth <- interval(M$f0_smth)
M$overlaprop_smth <- overlaprop(if0_smth)
M$overlaprop_smth[is.na(M$overlaprop_smth)] <- 0

# Not NA (note/F0) interval
M$notna <- c(0, diff((M$has_f0)))

# Overlap smooth median
M$overlap_smth <- caTools::runquantile(M$overlaprop, k, .5)
# smth > .4

# median by filter not NA
md_notna <- by(as.numeric(M$f0_smth), fltr(M$has_f0), median, na.rm = TRUE)
med_freq_notna <- sapply(md_notna, getx)
(na <- sapply(med_freq_notna, is.na))
(med_freq_notna <- med_freq_notna[!na])

# neutral: F3, F3, G3, G3, F3, E3, F3
# major mode (02, 03): F3, F3, A3, A3, F3, E3, F3
# minor mode : F3, F3, G#3, G#3, F3, E3, F3
(est_notes_notna <- voice::notes(med_freq_notna))
length(est_notes_notna)
length(est_notes_notna)-8

# median by filter overlaprop > 0.1, ..., 0.9
md_overlap <- by(M$f0,
                 fltr(M$overlap_smth > .5),
                 median)
med_freq_overlap <- sapply(md_overlap, getx)
(na <- sapply(med_freq_overlap, is.na))
med_freq_overlap <- med_freq_overlap[!na]

# neutral: F3, F3, G3, G3, F3, E3, F3
# major mode (02, 03): F3, F3, A3, A3, F3, E3, F3
# minor mode : F3, F3, G#3, G#3, F3, E3, F3
(est_notes_overlap <- voice::notes(med_freq_overlap))
length(est_notes_overlap)
length(est_notes_overlap)-8



# Plot
par(mfrow=c(6,1))
xfltr <- 100:350
# original
plot(M$f0[xfltr], pch = '.', main = 'F0')
points(if0$freq_lo[xfltr], pch = '.', col = 'red')
points(if0$freq_hi[xfltr], pch = '.', col = 'red')

# smooth
plot(M$f0_smth[xfltr], pch = '.', main = paste0('F0 smooth k = ', k))
points(if0_smth$freq_lo[xfltr], pch = '.', col = 'red')
points(if0_smth$freq_hi[xfltr], pch = '.', col = 'red')

# F0 NA's cumulated sum's !diff plot
plot(M$has_f0[xfltr], pch = '.', main = 'Has F0? 1:yes, 0:no')

# # Not NA interval (+1 begins, -1 ends)
# plot(M$notna, pch = '.', main = 'Not NA interval, +1:begins (green), -1:ends (red)')
# beg <- which(M$notna == 1)
# end <- which(M$notna == -1)
# points(beg, M$notna[beg], col = 'green')
# points(end, M$notna[end], col = 'red')

# plot F0 overlap proportions (original)
plot(M$overlaprop[xfltr], pch = '.', main = 'Overlap proportions, [n]-[n-1]')
abline(h = 0.5, col = 'red')

# plot F0 overlap proportions (smooth)
plot(M$overlaprop_smth[xfltr], pch = '.', main = 'Overlap proportions, [n]-[n-1] smooth')
abline(h = 0.5, col = 'red')

# plot(caTools::runmean(M$overlaprop, 31), pch = '.')
plot(M$overlap_smth[xfltr], pch = '.')
abline(h = 0.6, col = 'red')

# overlap
overlap <- diff(M$overlap_smth)
plot(overlap[xfltr], pch = '.')
abline(h = 0.04, col = 'red')
abline(h = -0.04, col = 'red')


# plot(caTools::runmad(M$overlaprop, 7), pch = '.')
# plot(caTools::runsd(M$overlaprop, 7), pch = '.')
# plot(caTools::runmax(M$overlaprop, 7), pch = '.')
# plot(caTools::runmin(M$overlaprop, 7), pch = '.')

# # Gain plot
# plot(M$gain, pch = '.')
# abline(h = 0, col = 'red')

# # Zero Crossing Rate plot
# plot(M$zcr1, pch = '.')
#





# studies
library(data.table)
?findInterval()
x <- 2:18
v <- c(5, 10, 15) # create two bins [5,10) and [10,15)
cbind(x, findInterval(x, v))

?foverlaps()
x = data.table(start=c(5,31,22,16), end=c(8,50,25,18), val2 = 7:10)
y = data.table(start=c(10, 20, 30), end=c(15, 35, 45), val1 = 1:3)
setkey(y, start, end)
foverlaps(x, y, type="any", which=TRUE) ## return overlap indices
foverlaps(x, y, type="any") ## return overlap join

# time series
f0_na0 <- ts(forecast::na.interp(M$f0))
par(mfrow=c(1,2))
acf(f0_na0, lag = nrow(M))
pacf(f0_na0, lag = nrow(M))
acf(diff(f0_na0), lag = nrow(M))

# strucchange::sctest(ts(M$f0))
