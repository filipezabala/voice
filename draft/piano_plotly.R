data = M
max_fmt = 2

piano_plotly <- function(data, max_fmt = 2){

  # Preparing data
  x <- dplyr::pull(data[,'section_seq_file'])
  fmt <- paste0('f', 0:max_fmt)
  fig <- plotly::plot_ly(data[,fmt], x = ~x) %>%
    layout(xaxis = list(title = 'Sample'),
           yaxis = list(title = 'Frequency'),
           title = 'Frequencies and notes')

  #TODO: solve y = ~fmt[i+1] in loop
  # for(i in 0:max_fmt){
  #   fig <- fig %>%
  #     add_trace(data = data, type = 'scatter',
  #               y = ~fmt[i+1], name = fmt[i+1],
  #               mode = 'lines+markers')
  # }
  # fig

  fig <- fig %>%
    plotly::add_trace(data = data, type = 'scatter',
              y = ~f0, name = 'f0',
              mode = 'lines+markers')
  if(max_fmt >= 1){
    fig <- fig %>%
      plotly::add_trace(data = data, type = 'scatter',
                y = ~f1, name = 'f1',
                mode = 'lines+markers')
  }
  if(max_fmt >= 2){
    fig <- fig %>%
      plotly::add_trace(data = data, type = 'scatter',
                y = ~f2, name = 'f2',
                mode = 'lines+markers')
  }

  fig <- fig %>%
    layout(
      shapes = list(
        list(
          type = 'line',
          x0 = 0,
          x1 = nrow(data),
          y0 = 500,
          y1 = 500,
          line = list(color = 'grey', width = 1)
        )
      )
    )

  return(fig)
}
piano_plot(M, 1)

voice::notes_freq() %>%
  print(n = Inf)
