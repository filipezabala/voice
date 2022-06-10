#'  Plot quality measures.
#'
#' @description Get bit from WAV file.
#' @param fit A data frame containing quality measures in columns.
#' @param title Desired plot title.
#' @param ymin,ymax Y label range.
#' @param measure Desired measures.
#' @export
plot_q <- function(fit, title = NULL, ymin = NULL, ymax = NULL,
                   measure = c('Accuracy',
                               'Kappa', 'Sensitivity', 'Specificity',
                               'Pos.Pred.Value', 'Neg.Pred.Value',
                               'Precision', 'Recall', 'F1', 'Prevalence',
                               'Detection.Rate', 'Detection.Prevalence',
                               'Balanced.Accuracy')){

  fig <- plotly::plot_ly(fit, x = ~top) %>%
    plotly::layout(legend = list(title=list(text='Measure')),
                   title = title,
                   xaxis = list(title = '# top variables',
                                zerolinecolor = '#ffff',
                                zerolinewidth = 2,
                                gridcolor = 'ffff'),
                   yaxis = list(title = 'Measure',
                                zerolinecolor = '#ffff',
                                zerolinewidth = 2,
                                gridcolor = 'ffff',
                                range = c(ymin, ymax)),
                   plot_bgcolor='#e5ecf6')

  if('Accuracy' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Accuracy,
                                     name = 'Accuracy',
                                     mode = 'lines+markers')
  }
  if('Kappa' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Kappa,
                                     name = 'Kappa',
                                     mode = 'lines+markers')
  }
  if('Sensitivity' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Sensitivity,
                                     name = 'Sensitivity',
                                     mode = 'lines+markers')
  }
  if('Specificity' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Specificity,
                                     name = 'Specificity',
                                     mode = 'lines+markers')
  }
  if('Pos.Pred.Value' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Pos.Pred.Value,
                                     name = 'Pos.Pred.Value',
                                     mode = 'lines+markers')
  }
  if('Neg.Pred.Value' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Neg.Pred.Value,
                                     name = 'Neg.Pred.Value',
                                     mode = 'lines+markers')
  }
  if('Precision' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Precision,
                                     name = 'Precision',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  if('Recall' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Recall,
                                     name = 'Recall',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  if('F1' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~F1,
                                     name = 'F1',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  if('Prevalence' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Prevalence,
                                     name = 'Prevalence',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  if('Detection.Rate' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Detection.Rate,
                                     name = 'Detection.Rate',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  if('Detection.Prevalence' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Detection.Prevalence,
                                     name = 'Detection.Prevalence',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  if('Balanced.Accuracy' %in% measure){
    fig <- fig %>% plotly::add_trace(y = ~Balanced.Accuracy,
                                     name = 'Balanced.Accuracy',
                                     mode = 'lines+markers',
                                     marker = list(symbol = 3))
  }
  return(fig)
}
