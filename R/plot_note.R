

plot_note <- function(x){
  x <- dplyr::as_tibble(x)
  ggplot2::ggplot(x, aes(date, unemploy / pop)) +
    geom_line()
}
