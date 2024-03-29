#' Voice example #1.
#'
#' A dataset containing the features F0:F8 and GAIN obtained from
#' voice::extract_features with windowShift = 5 miliseconds. Two women.
#'
#' @usage \code{data(voice_ex1)}
#' @format A tibble with 40,244 rows and 50 variables:
#' \describe{
#'   \item{audio_id}{Audio ID from 1 to 100}
#'   \item{F0}{Fundamental frequency or pitch.}
#'   \item{Fi}{ith Formant, i=1,...,8.}
#'   \item{GAIN}{Gain, the popular 'volume'.}
#'   \item{Dfi}{ith Formant Dispersion by Fitch (1997), i=2,...,8.}
#'   \item{Pfi}{Formant Position by Puts, Apicella & Cárdenas (2011), i=1,...,8.}
#'   \item{Rfi}{Formant Removal by Zabala (2021/2022), i=1,...,8.}
#'   \item{RNfi}{Formant Dispersion Removal by Zabala (2022), i=1,...,8.}
#'   \item{RPfi}{Formant Position Removal by Zabala (2022), i=1,...,8.}
#' }
'voice_ex1'
