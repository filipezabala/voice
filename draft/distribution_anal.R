# packs
library(voice)
library(Hmisc)
library(npreg)
library(splines2)
library(philentropy)

# reading file
wavFile <- '~/Downloads/voiceAudios/mp3Dir/doremi.wav'
M <- voice::extract_features(wavFile, features = 'f0', windowShift = 30)
summary(M)
# y <- forecast::na.interp(M$f0)
y <- M$f0
y[is.na(y)] <- min(y, na.rm = TRUE)
ys <- scale(y)
n <- length(y)
x <- 1:n

# original data
plot(y, pch = '.')

# models
fit1 <- stats::spline(y)
points(fit1, type = 'l', col = 'red')

# http://users.stat.umn.edu/~helwig/notes/smooth-spline-notes.html
fit2 <- stats::smooth.spline(y)
knot2 <- fit2$fit$knot
coef2 <- fit2$fit$coef
points(fit2, type = 'l', col = 'blue')
points(predict(fit2, floor(n*.5)), pch = '+', col = 'green')

fit3 <- npreg::ss(y)
summary(fit3)
knot3 <- fit3$fit$knot
coef3 <- fit3$fit$coef
points(fit3, type = 'l', col = 'brown')

fit4 <- splines2::bSpline(y, integral = TRUE)
summary(fit4)

fit5 <- Hmisc::rcspline.eval(y)
knot5 <- attr(fit5, 'knots')
coef5 <- lsfit(fit5, y)$coef

# spline function (SOMAR O MÍNIMO)
# sf1 <- Hmisc::rcsplineFunction(knot1, coef1)
sf2 <- Hmisc::rcsplineFunction(knot2, coef2)
sf3 <- Hmisc::rcsplineFunction(knot3, coef3)
# sf4 <- Hmisc::rcsplineFunction(knot4, coef4)
sf5 <- Hmisc::rcsplineFunction(knot5, coef5)
# sf5 <- Hmisc::rcsplineFunction(knot5, coef5, 'integral')

# integrate
# integrate(sf1, 1, n, coef1)
integrate(sf2, 1, n, coef2) # 11064589 with absolute error < 260
integrate(sf3, 1, n, coef3) # -6.738445e+34 with absolute error < 7.5e+20
# integrate(sf4, 1, n, coef4)
integrate(sf5, 1, n, coef5) # 1283274471 with absolute error < 41045

# distances
eval(sf2(x = x))
P <- c(.05, .1, .2, .05, .15, .25, .08, .12)
Q <- c(.3, .1, .2, .1, .1, .02, .08, .1)
x <- rbind(P,Q)
philentropy::KL(x, unit='log')
