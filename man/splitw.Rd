% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/splitw.R
\name{splitw}
\alias{splitw}
\title{Split Wave}
\usage{
splitw(
  fromWav,
  fromRttm,
  to = NULL,
  output = "wave",
  filesRange = NULL,
  full.names = TRUE,
  recursive = FALSE,
  min.time = 0.4
)
}
\arguments{
\item{fromWav}{A directory/folder containing WAV files.}

\item{fromRttm}{A directory/folder containing RTTM files.}

\item{to}{A directory/folder to write generated files.}

\item{output}{character string, the class of the object to return, either 'wave' or 'list'.}

\item{filesRange}{The desired range of directory files (default: \code{NULL}, i.e., all files).}

\item{full.names}{Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (default: \code{TRUE}) Used by \code{base::list.files}.}

\item{recursive}{Logical. Should the listing recursively into directories? (default: \code{FALSE}) Used by \code{base::list.files}.}

\item{min.time}{Minimum split time in seconds. (default: \code{0.4})}
}
\description{
Split WAV files in \code{fromWav} folder using (same names) RTTM files as guidance.
}
\examples{
library(voice)
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                                   pattern <- glob2rx('*.wav'), full.names = TRUE)
dir.create(rttm <- paste0(dirname(path2wav)[1], '/rttm/'))
wsw(from = dirname(path2wav)[1], to = rttm)

dir.create(split <- paste0(dirname(path2wav)[1], '/split/'))
splitw(fromWav = dirname(path2wav)[1], fromRttm = rttm,
                         to = split, output = 'wave')
}
