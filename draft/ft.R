#' Plot to Discrete Fourier Series fit
#'
#' @param x Numeric vector.
#' @param f Output from \code{dfs} function.
#' @examples
#' n <- 100000
#' (fit <- ffit(rnorm(n)))
#' plot(ft, lwd = 3, col = 'red', xlim = range(1:n), main = paste0('Fit order ', 10))
#' @export
ft <- function(x, full = FALSE){
  fit.order <- fit$fit.order
  cosseno <- paste0(fit$ak, '*cos(', 1:fit.order, '*', fit$beta, '*x)')
  seno    <- paste0(fit$bk, '*sin(', 1:fit.order, '*', fit$beta, '*x)')
  trig <- c(fit$a0, cosseno, seno)
  f0 <- c(paste0(trig,'+'),0)
  # fml <- as.function(paste(f0, collapse = ' '))
  fun <- parse(text = f0)
  res <- eval(fun)
  if(full){
    return(list(f0=f0, fun=fun, res=res))
    } else return(res)
}
