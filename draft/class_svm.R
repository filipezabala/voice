#' Fits, forecasts and gets performance from SVM models.
#'
#' @param x A data frame or tibble.
#' @param model Character containing the model structure. See \code{expand_model}.
#' @param filtro Column(s) to filter the samples.
#' @param percTreino Percentage of the database used to train the model, filtered by \code{filtro}.
#' @param setSeed Specified seed for the pseudo-random parts.
#' @param custo Cost of constraints violation (default: 1)—it is the ‘C’-constant of the regularization term in the Lagrange formulation.
#' @param gama Needed for all kernels except linear (default: 1/(data dimension))
#' @param paralelo Logical. Should the process be parallelized?
#' @param print.cm Logical. Should the confusion matrix be shown?
#' @return \code{fcast} predicted time series using the model that minimizes the forecasting mean square error.
#' @return \code{runtime} running time.
#' @return \code{mse.pred} mean squared error of prediction. Used to decide the best model.
#' @importFrom dplyr %>%
#' @references
#' Vapnik, Vladimir (2000). The Nature of Statistical Learning Theory, Springer.
#' @examples
#' library(voice)
#' @export
class_svm <- function(x, model,
                      filtro = c('id'), # CORRIGIR!
                      percTreino = 0.5,
                      setSeed = 1,
                      # normalize = TRUE,
                      custo = 1, gama = 1,
                      # paralelo = TRUE,
                      print.cm = TRUE){

  # counting time
  pt1 <- proc.time() # to final table

  # global parameters
  model <<- model  # pq so global?
  # custo <<- custo # nem global!
  # gama <<- gama # nem global!

  # message 1
  cat('MODEL -', model,'\n\n')
  cat('1#4 START - SAMPLE', '\n')

  # creating idFull
  # idFull <- apply(x[filtro], 1, paste, collapse = ',')
  idFull <- x[filtro]

  # idFullUn
  idFullUn <- as.data.frame(unique(idFull))
  nFullUn <- nrow(idFullUn)

  # sample
  set.seed(setSeed)
  treino <- sort(base::sample(1:nFullUn, floor(nFullUn*percTreino)))
  idTreino <- idFullUn[treino,]
  idTeste <- idFullUn[-treino,]
  trainset <- as.data.frame(x %>% dplyr::filter(id %in% idTreino))
  testset <- as.data.frame(x %>% dplyr::filter(id %in% idTeste))
  num <- sapply(testset, is.numeric)
  testset.m <- as.matrix(testset[,num])
  nTest <- nrow(testset)
  nCores <- parallel::detectCores()
  nGrupo <- nrow(testset)/nCores
  grupo <- rep(1:nCores, each = ceiling(nGrupo))[1:nrow(testset)]
  # testset <- cbind(grupo, testset)  # pq so global?

  # sample time
  ptd1 <- proc.time()-pt1 # proc.time.difference1
  cat('1#4 END IN', ptd1[3], 'SECONDS\n\n')

  # model
  pt2 <- proc.time()
  cat('2#4 START - MODEL', '\n')

  # if(paralelo){
  #   fit.svm <- parallelSVM::parallelSVM(stats::as.formula(model), data = trainset, cost = 1, gamma = 1)
  #   gc()
  # }
  # if(!paralelo){
    fit.svm <- e1071::svm(stats::as.formula(model), data = trainset, cost = custo, gamma = gama)
    gc()
  # }

  # model time
  ptd2 <- proc.time()-pt2
  cat('2#4 END IN', ptd2[3], 'SECONDS\n\n')

  # predict
  pt3 <- proc.time()
  cat('3#4 START - PREDICT', '\n')

  if(paralelo){
    testsetSplit <- split(as.data.frame(testset.m), grupo)
    testsetSplit <- lapply(testsetSplit, as.matrix)
    temp <- parallel::mcMap(stats::predict, testsetSplit, object = fit.svm, mc.cores = nCores) # 2.950665 secs (f0)
    pred.svm <- do.call(c, temp)-1 # por que está somando 1???
    gc()
  }
  if(!paralelo){
    pred.svm  <- stats::predict(fit.svm, testset.m) # 1.806881 mins (f0), 13.06865 mins (f0:mhs1)
    gc()
  }

  # predict time
  ptd3 <- proc.time()-pt3
  cat('3#4 END IN', ptd3[3], 'SECONDS\n\n')

  # performance
  pt4 <- proc.time()
  cat('4#4 START - PERFORMANCE', '\n')

  # identifying and counting y levels
  y <- gsub(' ', '', unlist(strsplit(model,'~'))[1], fixed = T)
  # l <- as.numeric(levels(testset[,y]))
  l <- 1:nlevels(testset[,y])
  n <- length(l)

  # creating full table
  table(testset[,y])
  cm.svm.tab <- table(true = testset[,y], pred = pred.svm)
  cm.svm <- matrix(0, nrow=n, ncol=n, dimnames = list(l,l))
  (temp <- dplyr::as_tibble(table(true = testset[,y], pred = pred.svm),
                         stringsAsFactors = FALSE))
  temp$true <- as.numeric(temp$true)
  temp$pred <- as.numeric(temp$pred)
  ntab <- nrow(temp)

  # expand_grid & bind_cols
  tab <- tidyr::expand_grid(true=l, pred=l)
  # tab <- tab %>%
  #   mutate(rp = apply(tab,1,rp))
  tab <- dplyr::left_join(tab, temp, by = c('true','pred'))

  # fulfilling cm.svm
  k <- 0
  for(i in 1:nrow(cm.svm)){
    for(j in 1:ncol(cm.svm)){
      k <- k+1
      if(!is.na(tab$n[k])){
        cm.svm[i,j] <- tab$n[k]
      }
    }
  }

  # calculating performance
  # https://classeval.wordpress.com/introduction/basic-evaluation-measures/
  (pcm.svm <- prop.table(cm.svm))
  n <- sum(cm.svm)
  diagPri <- diag(cm.svm) # main diagonal
  diagSec <- diag(apply(cm.svm,2,rev)) # secondary diagonal
  tp <- cm.svm[1,1] # true positive
  fp <- cm.svm[2,1] # false positive
  fn <- cm.svm[1,2] # false negative
  tn <- cm.svm[2,2] # true negative

    # accuracy
    acc <- sum(diagPri)/n # 0.9187901 f0, 0.8340649 f0:mhs1

    # sensitivity, recall or true positive rate
    sen <- tp/sum(cm.svm[1,])

    # specificity (true negative rate)
    spe <- tn/sum(cm.svm[,2])

    # precision (positive predictive value)
    pre <- tp/sum(cm.svm[,1])

    # matthews correlation coefficient
    mcc <- (prod(diagPri)-prod(diagSec))/sqrt(prod(tp+fp,tp+fn,tn+fp,tn+fn))

    # F score, \beta = 0.5, 1 and 2.
    F05 <- (1.25*pre*sen)/(.25*pre+sen)
    F1 <- (2*pre*sen)/(pre+sen)
    F2 <- (5*pre*sen)/(4*pre+sen)

    # error rate
    err <- sum(diagSec)/n # 0.08123807 f0,

    # false positive rate
    fpr <- 1-spe

    # performance
    des <- c(acc=acc, sen=sen, spe=spe, pre=pre, mcc=mcc,
             F05=F05, F1=F1, F2=F2, err=err, fpr=fpr)

  ptd4 <- proc.time()-pt4
  cat('4#4 END IN', ptd4[3], 'SECONDS\n\n')
  cat('TOTAL TIME', (proc.time()-pt1)[3], 'SECONDS\n\n')
  cat('##### -------------- #####\n\n')

  # gathering results
  result <- dplyr::tibble(timestamp=Sys.time(),
                   y=y, model=model,
                   acc=acc, sen=sen, spe=spe, pre=pre,
                   mcc=mcc, F05=F05, F1=F1, F2=F2,
                   err=err, fpr=fpr, filtro=filtro,
                   percTrain=percTreino, setSeed=setSeed,
                   cost=custo, gamma=gama,
                   timeSample = ptd1[3], # [3] for elapsed time (total) in seconds
                   timeModel = ptd2[3],
                   timePredict = ptd3[3],
                   timePerformance = ptd4[3],
                   timeTotal = (proc.time()-pt1)[3])

  # presenting results
  if(print.cm) {return(list(result = result, cm.svm = cm.svm, cm.svm.tab = cm.svm.tab))}
  if(!print.cm) {return(list(result = result))}
}
