aggr2 <- function (x, delimiter = NULL, plot = TRUE, ...) 
{
  check_data(x)
  x <- as.data.frame(x)
  imputed <- FALSE
  if (is.null(dim(x))) {
    n <- length(x)
    imp <- FALSE
    cn <- defaultNames(1)
    nNA <- countNA(x)
    tab <- table(as.numeric(is.na(x)))
    tabcomb <- as.matrix(as.integer(names(tab)))
  }
  else {
    if (!is.null(delimiter)) {
      tmp <- grep(delimiter, colnames(x))
      if (length(tmp) > 0) {
        imp_var <- x[, tmp, drop = FALSE]
        x <- x[, -tmp, drop = FALSE]
        if (ncol(x) == 0) 
          stop("Only the missing-index is given")
        if (is.matrix(imp_var) && range(imp_var) == c(0, 
                                                      1)) 
          imp_var <- apply(imp_var, 2, as.logical)
        if (is.null(dim(imp_var))) {
          if (!is.logical(imp_var)) 
            stop("The missing-index of imputed variables must be of the type logical")
        }
        else {
          if (!any(as.logical(lapply(imp_var, is.logical)))) 
            stop("The missing-index of imputed variables must be of the type logical")
        }
        imputed <- TRUE
      }
      else {
        warning("'delimiter' is given, but no missing-index variable is found", 
                call. = FALSE)
      }
    }
    n <- nrow(x)
    cn <- colnames(x)
    if (is.null(cn)) 
      cn <- defaultNames(ncol(x))
    nNA <- apply(x, 2, countNA)
    imp <- rep(FALSE, ncol(x))
    if (imputed) {
      nNA_imp <- countImp(x, delimiter, imp_var)
      imp <- nNA_imp > 0
      nNA <- nNA + nNA_imp
    }
    tmp <- ifelse(is.na(x), 1, 0)
    if (imputed) {
      tmp_imp <- isImp(x, pos = NULL, delimiter = delimiter, 
                       imp_var = imp_var, selection = "none")[["missh"]]
      tmp_imp <- ifelse(tmp_imp, 2, 0)
      tmp[, colnames(tmp_imp)] <- tmp_imp
    }
    tab <- table(apply(tmp, 1, paste, collapse = ":"))
    tabcomb <- sapply(names(tab), function(x) as.integer(unlist(strsplit(x, 
                                                                         ":", fixed = TRUE))), USE.NAMES = FALSE)
    tabcomb <- if (is.null(dim(tabcomb))) 
      as.matrix(tabcomb)
    else t(tabcomb)
  }
  miss <- data.frame(Variable = cn, Count = nNA, stringsAsFactors = FALSE)
  count <- as.integer(tab)
  res <- list(x = x, combinations = names(tab), count = count, 
              percent = count * 100/n, missings = miss, tabcomb = tabcomb, 
              imputed = imp)
  class(res) <- "aggr"
  if (plot) {
    plot(res, ...)
    invisible(res)
  }
  else res
}
