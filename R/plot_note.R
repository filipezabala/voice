#' Plot notes
#'
#' @param x A data frame.

plot_note <- function(x){
  x <- dplyr::as_tibble(x)
  ggplot2::ggplot(x, ggplot2::aes(date, unemploy / pop)) +
    ggplot2::geom_line()
}
