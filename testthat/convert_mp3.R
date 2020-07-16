#'@param \code{convert.mp3} Logical. Should .mp3 files be converted to .wav? (default: \code{FALSE}) Used by \code{warbleR::mp32wav}.
#'@param \code{dest.path} Character string containing the directory path where the .wav files will be saved. If \code{NULL} (default) then the folder containing the sound files will be used. Used by \code{warbleR::mp32wav}.
#'@import warble
#'
# listing wav and mp3 files
wavFiles <- list.files(x, pattern = glob2rx('*.wav'),
                       full.names = full.names, recursive = recursive)
mp3Files <- list.files(x, pattern = glob2rx('*.mp3'),
                       full.names = full.names, recursive = recursive)

# does exist wav and mp3
# basename(wavFiles) == basename(mp3Files)

# converting mp3 to wav
if(convert.mp3 == convert.mp3 & length(mp3Files > 0)){
  try(warbleR::mp32wav(path = x, dest.path = dest.path, parallel = mc.cores),
      silent = F)
  wavFiles <- list.files(x, pattern = glob2rx('*.wav'),
                         full.names = full.names, recursive = recursive)
}
