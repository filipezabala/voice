#' Fits and forecast SVM models, serial and parallelized.
#'
#' @param df A data frame or tibble.
#' @param modelo Character containing the model structure.
#' @param filtro Column(s) to filter the samples.
#' @param percTreino Percentage of the database used to train the model, filtered by \code{filtro}.
#' @param setSeed Specified seed for the pseudo-random parts.
#' @param custo Cost of constraints violation (default: 1)—it is the ‘C’-constant of the regularization term in the Lagrange formulation.
#' @param gama Needed for all kernels except linear (default: 1/(data dimension))
#' @param paralelo Logical. Should the process be parallelized?
#' @param simbolico Logical. Should the symbolic confusion matrix be printed?
#' @param restart Logical. Should the R session be restarted? (It frees memory)

#' @return \code{$fcast} predicted time series using the model that minimizes the forecasting mean square error.
#' \code{$runtime} running time.
#' \code{mse.pred} mean squared error of prediction. Used to decide the best model.
#' @import e1071, parallelSVM, parallel
#' @references
#' Vapnik, Vladimir (2000). The Nature of Statistical Learning Theory, Springer.
#' @examples
#' library(voice)
#' @export
class_svm <- function(df, modelo,
                      filtro = c('id'),
                      percTreino = 0.5,
                      setSeed = 1,
                      # normalize = T,
                      custo = 1, gama = 1,
                      paralelo = T, simbolico = F,
                      restart = F){
  df = bf0NA
  modelo = 'readcomp_diff_w1 ~ f0'
  filtro = c('id')
  # id0 = c('id','wordType')
  setSeed = 1
  percTreino = 0.5
  custo = 1
  gama = 1
  paralelo = T
  simbolico = F

  # contando o tempo
  ini1 <- Sys.time()
  # ini1 <- proc.time()

  # criando idFull
  idFull <- apply(df[,filtro], 1, paste, collapse = ',')

  # idFullUn
  idFullUn <- as.data.frame(unique(idFull))
  nFullUn <- nrow(idFullUn)

  # parametros globais
  modelo <<- modelo  # pq so global?
  # custo <<- custo # nem global!
  # gama <<- gama # nem global!

  # sorteando amostra
  set.seed(setSeed)
  treino <- sort(base::sample(1:nFullUn, floor(nFullUn*percTreino)))
  idTreino <- idFullUn[treino,]
  idTeste <- idFullUn[-treino,]
  trainset <- as.data.frame(df %>% filter(id %in% idTreino))
  testset <- as.data.frame(df %>% filter(id %in% idTeste))
  nTest <- nrow(testset)
  nCores <- parallel::detectCores()
  nGrupo <- nrow(testset)/nCores
  grupo <- rep(1:nCores, each = ceiling(nGrupo))[1:nrow(testset)]
  # testset <- cbind(grupo, testset)  # pq so global?

  # Tempo da amostra
  tempo1 <- Sys.time()-ini1
  # tempo1 <- proc.time()-ini1
  cat('Etapa 1 - AMOSTRA', tempo1, '\n')

  # SVM
  ini2 <- Sys.time()
  # ini2 <- proc.time()
  if(paralelo){
    fit.svm <- parallelSVM::parallelSVM(as.formula(modelo), data = trainset, cost = 1, gamma = 1)
  }
  if(!paralelo){
    fit.svm <- e1071::svm(as.formula(modelo), data = trainset, cost = custo, gamma = gama) # Processo 1 - MODELO 10.31172 minutos
  }

  # Tempo do modelo
  tempo2 <- Sys.time()-ini2
  # tempo2 <- proc.time()-ini2
  cat('Etapa 2 - MODELO', tempo2, '\n')

  # predicao
  ini3 <- Sys.time()
  # ini3 <- proc.time()

  if(paralelo){
    testsetSplit <- split(testset, grupo)
    temp <- parallel::mcMap(predict, testsetSplit, object = fit.svm,  mc.cores = nCores) # 2.950665 secs (f0)
    pred.svm <- do.call(c, temp)
  }
  if(!paralelo){
    pred.svm  <- stats::predict(fit.svm, testset) # 1.806881 mins (f0), 13.06865 mins (f0:mhs1)
  }

  # Tempo da predição
  tempo3 <- Sys.time()-ini3
  # tempo3 <- proc.time()-ini3
  cat('Etapa 3 - PREDIÇÃO', tempo3, '\n')

  # Medindo desempenho
  # https://classeval.wordpress.com/introduction/basic-evaluation-measures/
  y <- gsub(' ', '', unlist(strsplit(modelo,'~'))[1], fixed = T)
  print(length(testset[,y]))
  print(length(pred.svm))

  (cm.svm <- table(true = testset[,y], pred = pred.svm))
  (pcm.svm <- prop.table(cm.svm))
  n <- sum(cm.svm)
  diagPri <- diag(cm.svm)
  diagSec <- diag(apply(cm.svm,2,rev))
  tp <- cm.svm[1,1] # true positive
  fp <- cm.svm[2,1] # false positive
  fn <- cm.svm[1,2] # false negative
  tn <- cm.svm[2,2] # true negative

    # accuracy
    (acc <- sum(diagPri)/n) # 0.9187901 f0, 0.8340649 f0:mhs1

    # sensitivity, recall or true positive rate
    (sen <- tp/sum(cm.svm[1,]))

    # specificity (true negative rate)
    (spe <- tn/sum(cm.svm[,2]))

    # precision (positive predictive value)
    (pre <- tp/sum(cm.svm[,1]))

    # matthews correlation coefficient
    (mcc <- (prod(diagPri)-prod(diagSec))/sqrt(prod(tp+fp,tp+fn,tn+fp,tn+fn)))

    # F score, \beta = 0.5, 1 and 2.
    (F05 <- (1.25*pre*sen)/(.25*pre+sen))
    (F1 <- (2*pre*sen)/(pre+sen))
    (F2 <- (5*pre*sen)/(4*pre+sen))

    # error rate
    (err <- sum(diagSec)/n) # 0.08123807 f0,

    # false positive rate
    (fpr <- 1-spe)

    # desempenho
    des <- c(acc=acc, sen=sen, spe=spe, pre=pre, mcc=mcc, F05=F05, F1=F1, F2=F2,
             err=err, fpr=fpr)

  # apresentando resultados
  if(simbolico){
    sym <- symnum(pcm.svm, cutpoints = quantile(pcm.svm, probs = seq(0,1,1/4)),
                  sym = c(".", "-", "+", "$"))
    return(list(tab.total = cm.svm,
                tab.simbolico = sym,
                # tab.perc=pcm.svm,
                desempenho = des,
                tempProc1 = tempo1,
                tempProc2 = tempo2,
                tempProc3 = tempo3,
                tempoProcTot = Sys.time()-ini1))
  }
  if(!simbolico){
    return(list(tab.total = cm.svm,
                # tab.perc=pcm.svm,
                desempenho = des,
                tempoAmostra = tempo1,
                tempoModelo = tempo2,
                tempoPredicao = tempo3,
                tempoProcTot = Sys.time()-ini1))
                # tempoProcTot = proc.time()-ini1))
  }
  # reiniciando sessao
  if(restart) {.rs.restartR()}
}
