library(itertools)
library(foreach)
library(doSNOW)
library(e1071)
library(prediction)

fit <- svm(Employed ~ ., data = longley)
class(fit)
scale <- 100
longley2 <- (longley[rep(seq(nrow(longley)), scale), ])

num_splits <- 4
cl <- makeCluster(num_splits)
registerDoSNOW(cl)  

predictions <-
  foreach(d=isplitRows(longley2, chunks=num_splits),
          .combine=c, .packages=c("stats")) %dopar% {
            prediction::prediction(fit, newdata=d)
          }
length(predictions)

