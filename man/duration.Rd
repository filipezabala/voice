% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/duration.R
\name{duration}
\alias{duration}
\title{Duration of sequences}
\usage{
duration(x, windowShift = 5)
}
\arguments{
\item{x}{A vector containing symbols and \code{NA}.}

\item{windowShift}{Window shift to duration in ms (default: 5.0).}
}
\value{
A data frame with duration in number of lines/ocurrences (\code{dur_line}), milliseconds (\code{dur_ms}) and proportional (\code{dur_prop}).
}
\description{
Duration of sequences
}
\examples{
library(voice)
duration(letters)
duration(c('a','a','a',letters,'z'))

nts <- c('NA','NA','A3','A3','A3','A3','A#3','B3','B3','C4','C4','C4','C4',
'C4','C4','C#4','C4','C4','C4','B3','A#3','NA','NA','NA','NA','NA','NA','NA',
'NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','D4','D4','D4','C#4',
'C#4','C#4','C4','C4','B3','B3','A#3','A#3','A3','A3','G3','G#3','G3','F#3')
duration(nts)
}
