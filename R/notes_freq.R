#' Frequencies on Scientific Pitch Notation (SPN)
#'
#' @description Returns a tibble of frequencies on Scientific Pitch Notation (SPN) for equal-tempered scale, A4 = 440 Hz.
#' @details The symbol '#' is being used to represent a sharp note, the higher in pitch by one semitone. The SPN is also known as American Standard Pitch Notation (ASPN) or International Pitch Notation (IPN).
#' @references \url{https://gist.github.com/nvictor/7b4ab7070e210bc1306356f037226dd9}
#' @return A tibble with frequencies for equal-tempered scale, A4 = 440 Hz.
#' @seealso \code{notes}
#' @examples
#' library(voice)
#' notes_freq()
#' @export
notes_freq <- function(){
  nf <- dplyr::tribble(
    ~spn, ~freq, ~wavelength, ~black, ~Black,
    #--|--|----
    'C0' , 16.35  , 2109.89, 0, 0,
    'C#0', 17.32  , 1991.47, 1, 1,
    'D0' , 18.35  , 1879.69, 0, 0,
    'D#0', 19.45  , 1774.20, 1, 1,
    'E0' , 20.60  , 1674.62, 0, 0,
    'F0' , 21.83  , 1580.63, 0, 0,
    'F#0', 23.12  , 1491.91, 1, 1,
    'G0' , 24.50  , 1408.18, 0, 0,
    'G#0', 25.96  , 1329.14, 1, 1,
    'A0' , 27.50  , 1254.55, 0, 0,
    'A#0', 29.14  , 1184.13, 1, 1,
    'B0' , 30.87  , 1117.67, 0, 1,
    'C1' , 32.70  , 1054.94, 0, 0,
    'C#1', 34.65  , 995.73 , 1, 1,
    'D1' , 36.71  , 939.85 , 0, 0,
    'D#1', 38.89  , 887.10 , 1, 1,
    'E1' , 41.20  , 837.31 , 0, 0,
    'F1' , 43.65  , 790.31 , 0, 0,
    'F#1', 46.25  , 745.96 , 1, 1,
    'G1' , 49.00  , 704.09 , 0, 0,
    'G#1', 51.91  , 664.57 , 1, 1,
    'A1' , 55.00  , 627.27 , 0, 0,
    'A#1', 58.27  , 592.07 , 1, 1,
    'B1' , 61.74  , 558.84 , 0, 1,
    'C2' , 65.41  , 527.47 , 0, 0,
    'C#2', 69.30  , 497.87 , 1, 1,
    'D2' , 73.42  , 469.92 , 0, 0,
    'D#2', 77.78  , 443.55 , 1, 1,
    'E2' , 82.41  , 418.65 , 0, 0,
    'F2' , 87.31  , 395.16 , 0, 0,
    'F#2', 92.50  , 372.98 , 1, 1,
    'G2' , 98.00  , 352.04 , 0, 0,
    'G#2', 103.83 , 332.29 , 1, 1,
    'A2' , 110.00 , 313.64 , 0, 0,
    'A#2', 116.54 , 296.03 , 1, 1,
    'B2' , 123.47 , 279.42 , 0, 1,
    'C3' , 130.81 , 263.74 , 0, 0,
    'C#3', 138.59 , 248.93 , 1, 1,
    'D3' , 146.83 , 234.96 , 0, 0,
    'D#3', 155.56 , 221.77 , 1, 1,
    'E3' , 164.81 , 209.33 , 0, 0,
    'F3' , 174.61 , 197.58 , 0, 0,
    'F#3', 185.00 , 186.49 , 1, 1,
    'G3' , 196.00 , 176.02 , 0, 0,
    'G#3', 207.65 , 166.14 , 1, 1,
    'A3' , 220.00 , 156.82 , 0, 0,
    'A#3', 233.08 , 148.02 , 1, 1,
    'B3' , 246.94 , 139.71 , 0, 1,
    'C4' , 261.63 , 131.87 , 0, 0,
    'C#4', 277.18 , 124.47 , 1, 1,
    'D4' , 293.66 , 117.48 , 0, 0,
    'D#4', 311.13 , 110.89 , 1, 1,
    'E4' , 329.63 , 104.66 , 0, 0,
    'F4' , 349.23 , 98.79  , 0, 0,
    'F#4', 369.99 , 93.24  , 1, 1,
    'G4' , 392.00 , 88.01  , 0, 0,
    'G#4', 415.30 , 83.07  , 1, 1,
    'A4' , 440.00 , 78.41  , 0, 0,
    'A#4', 466.16 , 74.01  , 1, 1,
    'B4' , 493.88 , 69.85  , 0, 1,
    'C5' , 523.25 , 65.93  , 0, 0,
    'C#5', 554.37 , 62.23  , 1, 1,
    'D5' , 587.33 , 58.74  , 0, 0,
    'D#5', 622.25 , 55.44  , 1, 1,
    'E5' , 659.25 , 52.33  , 0, 0,
    'F5' , 698.46 , 49.39  , 0, 0,
    'F#5', 739.99 , 46.62  , 1, 1,
    'G5' , 783.99 , 44.01  , 0, 0,
    'G#5', 830.61 , 41.54  , 1, 1,
    'A5' , 880.00 , 39.20  , 0, 0,
    'A#5', 932.33 , 37.00  , 1, 1,
    'B5' , 987.77 , 34.93  , 0, 1,
    'C6' , 1046.50, 32.97  , 0, 0,
    'C#6', 1108.73, 31.12  , 1, 1,
    'D6' , 1174.66, 29.37  , 0, 0,
    'D#6', 1244.51, 27.72  , 1, 1,
    'E6' , 1318.51, 26.17  , 0, 0,
    'F6' , 1396.91, 24.70  , 0, 0,
    'F#6', 1479.98, 23.31  , 1, 1,
    'G6' , 1567.98, 22.00  , 0, 0,
    'G#6', 1661.22, 20.77  , 1, 1,
    'A6' , 1760.00, 19.60  , 0, 0,
    'A#6', 1864.66, 18.50  , 1, 1,
    'B6' , 1975.53, 17.46  , 0, 1,
    'C7' , 2093.00, 16.48  , 0, 0,
    'C#7', 2217.46, 15.56  , 1, 1,
    'D7' , 2349.32, 14.69  , 0, 0,
    'D#7', 2489.02, 13.86  , 1, 1,
    'E7' , 2637.02, 13.08  , 0, 0,
    'F7' , 2793.83, 12.35  , 0, 0,
    'F#7', 2959.96, 11.66  , 1, 1,
    'G7' , 3135.96, 11.00  , 0, 0,
    'G#7', 3322.44, 10.38  , 1, 1,
    'A7' , 3520.00, 9.80   , 0, 0,
    'A#7', 3729.31, 9.25   , 1, 1,
    'B7' , 3951.07, 8.73   , 0, 1,
    'C8' , 4186.01, 8.24   , 0, 0,
    'C#8', 4434.92, 7.78   , 1, 1,
    'D8' , 4698.63, 7.34   , 0, 0,
    'D#8', 4978.03, 6.93   , 1, 1,
    'E8' , 5274.04, 6.54   , 0, 0,
    'F8' , 5587.65, 6.17   , 0, 0,
    'F#8', 5919.91, 5.83   , 1, 1,
    'G8' , 6271.93, 5.50   , 0, 0,
    'G#8', 6644.88, 5.19   , 1, 1,
    'A8' , 7040.00, 4.90   , 0, 0,
    'A#8', 7458.62, 4.63   , 1, 1,
    'B8' , 7902.13, 4.37   , 0, 1
  )
  # add midi
  nf <- dplyr::bind_cols(nf, midi = 12:119)

  # add lo and hi limits to spn
  freq <- nf$freq
  distance <- diff(freq)
  lf <- length(freq)
  freqhalf <- c(freq[1] - distance[1]/2,
                freq[-lf] + distance/2,
                freq[lf] + distance[lf-1]/2)
  nf$spn.lo <- freqhalf[1:lf]
  nf$spn.hi <- freqhalf[2:(lf+1)]

  # ordering spn
  lev <- c('C0','C#0','D0','D#0','E0','F0','F#0','G0','G#0','A0','A#0','B0',
           'C1','C#1','D1','D#1','E1','F1','F#1','G1','G#1','A1','A#1','B1',
           'C2','C#2','D2','D#2','E2','F2','F#2','G2','G#2','A2','A#2','B2',
           'C3','C#3','D3','D#3','E3','F3','F#3','G3','G#3','A3','A#3','B3',
           'C4','C#4','D4','D#4','E4','F4','F#4','G4','G#4','A4','A#4','B4',
           'C5','C#5','D5','D#5','E5','F5','F#5','G5','G#5','A5','A#5','B5',
           'C6','C#6','D6','D#6','E6','F6','F#6','G6','G#6','A6','A#6','B6',
           'C7','C#7','D7','D#7','E7','F7','F#7','G7','G#7','A7','A#7','B7',
           'C8','C#8','D8','D#8','E8','F8','F#8','G8','G#8','A8','A#8','B8')
  nf$spn <- factor(nf$spn, levels = lev, ordered = TRUE)
  nf <- dplyr::select(nf, freq, spn.lo, spn.hi, spn, midi, black, Black, wavelength)
  return(nf)
}
