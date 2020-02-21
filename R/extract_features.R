#' Extracts 1093 features from WAV or MP3 audio.
#' @description Extracts 1093 features from WAV or MP3 audio.
#' @param \code{x} A directory containing audio file(s) in WAV or MP3 formats. If more than one directory is provided, only the first one is used.
#' @param \code{gender} = <code>: set gender specific parameters where <code> = 'f'[emale], 'm'[ale] or 'u'[nknown] (default: 'u'). Used by \code{wrassp::ksvF0}, \code{wrassp::forest} and \code{wrassp::mhsF0}.
#' @param \code{windowShift} = <dur>: set analysis window shift to <dur>ation in ms (default: 5.0). Used by \code{wrassp::ksvF0}, \code{wrassp::forest}, \code{wrassp::mhsF0}, \code{wrassp::zcrana}, \code{wrassp::rmsana}, \code{wrassp::rfcana}, \code{wrassp::acfana}, \code{wrassp::cepstrum}, \code{wrassp::dftSpectrum}, \code{wrassp::cssSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param \code{numFormants} = <num>: <num>ber of formants (default: 8). Used by \code{wrassp::forest}.
#' @param \code{numcep} Number of Mel-frequency cepstral coefficients (cepstra) to return (default: 12). Used by \code{tuneR::melfcc}.
#' @param \code{dcttype} Type of DCT used. 't1' or 't2', 't3' for HTK 't4' for feacalc (default = 't2'). Used by \code{tuneR::melfcc}.
#' @param \code{fbtype} Auditory frequency scale to use: \code{'mel'}, \code{'bark'}, \code{'htkmel'}, \code{'fcmel'} (default: \code{'mel'}). Used by \code{tuneR::melfcc}.
#' @param \code{resolution} = <freq>: set FFT length to the smallest value which results in a frequency resolution of <freq> Hz or better (default: 40.0). Used by \code{wrassp::cssSpectrum}, \code{wrassp::dftSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param \code{usecmp}. Logical. Apply equal-loudness weighting and cube-root compression (PLP instead of LPC) (default: \code{FALSE}). Used by \code{tuneR::melfcc}.
#' @param \code{mc.cores} Number of cores to be used in parallel processing. (default: \code{parallel::detectCores()})
#' @param \code{convert.mp3} Logical. Should .mp3 files be converted to .wav? (default: \code{FALSE}) Used by \code{warbleR::mp32wav}.
#' @param \code{dest.path} Character string containing the directory path where the .wav files will be saved. If \code{NULL} (default) then the folder containing the sound files will be used. Used by \code{warbleR::mp32wav}.
#' @param \code{full.names} Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (default: \code{TRUE}) Used by \code{base::list.files}.
#' @param \code{recursive} Logical. Should the listing recurse into directories? (default: \code{FALSE}) Used by \code{base::list.files}.
#' @param \code{as.tibble} Logical. Sould the output be a tibble or a data frame? (default: \code{TRUE})
#' @import parallel tibble tidyr tuneR warbleR wrassp
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file("extdata", package = "wrassp"),
#' pattern = glob2rx("*.wav"),
#' full.names = TRUE)
#' # calculate fundamental frequency contour
#' ef <- extract_features(dirname(path2wav))
#' ef

#' @export
extract_features <- function(x, gender = 'u', windowShift = 5, numFormants = 8,
                             numcep = 12, dcttype = c('t2', 't1', 't3', 't4'),
                             fbtype = c('mel', 'htkmel', 'fcmel', 'bark'),
                             resolution = 40, usecmp = FALSE,
                             mc.cores = parallel::detectCores(), convert.mp3 = FALSE,
                             dest.path = NULL, full.names = TRUE, recursive = FALSE,
                             as.tibble = TRUE){

   # removing duplicates, using the first directory provided
   x <- x[1]

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

    # number of wav files
    nWav <- length(wavFiles)

    # 1. F0 analysis of the signal
    f0 <- parallel::mclapply(wavFiles, wrassp::ksvF0, gender = gender, toFile = F,
                   windowShift = windowShift, mc.cores = mc.cores)

    # 2. Formant estimation (F1:F8)
    fo <- parallel::mclapply(wavFiles, wrassp::forest, gender = gender, toFile = F,
                   windowShift = windowShift, mc.cores = mc.cores, numFormants = numFormants)

    # 3. Analysis of the averages of the short-term positive and negative (Z)ero-(C)rossing (R)ates
    zcr <- parallel::mclapply(wavFiles, wrassp::zcrana, toFile = F,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 4. Analysis of short-term (R)oot (M)ean (S)quare amplitude
    rms1 <- parallel::mclapply(wavFiles, wrassp::rmsana, toFile = F,
                               windowShift = windowShift, mc.cores = mc.cores)

    # 5. Pitch analysis of the speech signal using Michel’s (M)odified (H)armonic (S)ieve algorithm
    mhs <- parallel::mclapply(wavFiles, wrassp::mhsF0, toFile = F,  gender = gender,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 6. (L)inear (P)rediction (A)nalysis [rms, gain, rfc]
    lpa <- parallel::mclapply(wavFiles, wrassp::rfcana, toFile = F,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 7. Analysis of short-term (A)uto(C)orrelation function
    ac <- parallel::mclapply(wavFiles, wrassp::acfana, toFile = F,
                             windowShift = windowShift, mc.cores = mc.cores)

    # 8. Short-term (CEP)stral analysis
    cep <- parallel::mclapply(wavFiles, wrassp::cepstrum, toFile = F,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 9. Short-term (DFT) spectral analysis
    dft <- parallel::mclapply(wavFiles, wrassp::dftSpectrum, toFile = F, resolution = resolution,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 10. (C)epstral (S)moothed version of dft(S)pectrum
    css <- parallel::mclapply(wavFiles, wrassp::cssSpectrum, toFile = F, resolution = resolution,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 11. (L)inear (P)redictive (S)moothed version of dftSpectrum
    lps <- parallel::mclapply(wavFiles, wrassp::lpsSpectrum, toFile = F, resolution = resolution,
                              windowShift = windowShift, mc.cores = mc.cores)

    # 12. Mel-Frequency Cepstral Coefficients (MFCC)
    rWave <- parallel::mclapply(wavFiles, tuneR::readWave, mc.cores = mc.cores)
    mf <- parallel::mclapply(rWave, tuneR::melfcc, wintime = windowShift/1000,
                             hoptime = windowShift/1000, dcttype = dcttype, numcep = numcep,
                             fbtype = fbtype, usecmp = usecmp, mc.cores = mc.cores)
    mf_le <- unlist(lapply(mf, nrow))


    # concatenating
    f0_fm <- dplyr::tibble()
    f0_le <- vector(length = nWav)

    fo_fm <- dplyr::tibble()
    fo_le <- vector(length = nWav)

    zcr_fm <- dplyr::tibble()
    zcr_le <- vector(length = nWav)

    rms1_fm <- dplyr::tibble()
    rms1_le <- vector(length = nWav)

    rms2_fm <- dplyr::tibble()
    rms2_le <- vector(length = nWav)

    mhs_fm <- dplyr::tibble()
    mhs_le <- vector(length = nWav)

    mhs_fm <- dplyr::tibble()
    mhs_le <- vector(length = nWav)

    gain_fm <- dplyr::tibble()
    gain_le <- vector(length = nWav)

    rfc_fm <- dplyr::tibble()
    rfc_le <- vector(length = nWav)

    ac_fm <- dplyr::tibble()
    ac_le <- vector(length = nWav)

    cep_fm <- dplyr::tibble()
    cep_le <- vector(length = nWav)

    dft_fm <- dplyr::tibble()
    dft_le <- vector(length = nWav)

    css_fm <- dplyr::tibble()
    css_le <- vector(length = nWav)

    lps_fm <- dplyr::tibble()
    lps_le <- vector(length = nWav)

    mf_fm <- dplyr::tibble()

    for(i in 1:nWav){ # upgrade: use bind_rows
       f0_temp <- as.matrix(f0[[i]]$F0[1:mf_le[i]], ncol = 1)
       f0_fm <- rbind(f0_fm, f0_temp)
       f0_le[i] <- nrow(f0[[i]]$F0)

       fo_temp <- as.matrix(fo[[i]]$fm[1:mf_le[i],], ncol = numFormants)
       fo_fm <- rbind(fo_fm, fo_temp)
       fo_le[i] <- nrow(fo[[i]]$fm)

       zcr_temp <- as.matrix(zcr[[i]]$zcr[1:mf_le[i],], ncol = 1)
       zcr_fm <- rbind(zcr_fm, zcr_temp)
       zcr_le[i] <- nrow(zcr[[i]]$zcr)

       rms1_temp <- as.matrix(rms1[[i]]$rms[1:mf_le[i],], ncol = 1)
       rms1_fm <- rbind(rms1_fm, rms1_temp)
       rms1_le[i] <- nrow(rms1[[i]]$rms)

       rms2_temp <- as.matrix(lpa[[i]]$rms[1:mf_le[i],], ncol = 1)
       rms2_fm <- rbind(rms2_fm, rms2_temp)
       rms2_le[i] <- nrow(lpa[[i]]$rms)

       mhs_temp <- as.matrix(mhs[[i]]$pitch[1:mf_le[i],], ncol = 1)
       mhs_fm <- rbind(mhs_fm, mhs_temp)
       mhs_le[i] <- nrow(mhs[[i]]$pitch)

       gain_temp <- as.matrix(lpa[[i]]$gain[1:mf_le[i],], ncol = 1)
       gain_fm <- rbind(gain_fm, gain_temp)
       gain_le[i] <- nrow(lpa[[i]]$gain)

       rfc_temp <- as.matrix(lpa[[i]]$rfc[1:mf_le[i],], ncol = 19)
       rfc_fm <- rbind(rfc_fm, rfc_temp)
       rfc_le[i] <- nrow(lpa[[i]]$rfc)

       ac_temp <- as.matrix(ac[[i]]$acf[1:mf_le[i],], ncol = 20)
       ac_fm <- rbind(ac_fm, ac_temp)
       ac_le[i] <- nrow(ac[[i]]$acf)

       cep_temp <- as.matrix(cep[[i]]$cep[1:mf_le[i],], ncol = 257)
       cep_fm <- rbind(cep_fm, cep_temp)
       cep_le[i] <- nrow(cep[[i]]$cep)

       dft_temp <- as.matrix(dft[[i]]$dft[1:mf_le[i],], ncol = 257)
       dft_fm <- rbind(dft_fm, dft_temp)
       dft_le[i] <- nrow(dft[[i]]$dft)

       css_temp <- as.matrix(css[[i]]$css[1:mf_le[i],], ncol = 257)
       css_fm <- rbind(css_fm, css_temp)
       css_le[i] <- nrow(css[[i]]$css)

       lps_temp <- as.matrix(lps[[i]]$lps[1:mf_le[i],], ncol = 257)
       lps_fm <- rbind(lps_fm, lps_temp)
       lps_le[i] <- nrow(lps[[i]]$lps)

       mf_fm <- rbind(mf_fm, mf[[i]])

       print(i/nWav)
    }

    # id, using smaller length: mf_le
    id <- tibble::enframe(rep(basename(wavFiles), mf_le), value = 'audio', name = NULL)

    # colnames
    colnames(f0_fm) <- 'F0'
    colnames(fo_fm) <- paste0('F', 1:numFormants)
    colnames(zcr_fm) <- paste0('ZCR')
    colnames(rms1_fm) <- paste0('RMS1')
    colnames(rms2_fm) <- paste0('RMS2')
    colnames(mhs_fm) <- paste0('MHS')
    colnames(gain_fm) <- paste0('GAIN')
    colnames(rfc_fm) <- paste0('RFC', 1:19)
    colnames(ac_fm) <- paste0('ACF', 1:20)
    colnames(cep_fm) <- paste0('CEP', 1:257)
    colnames(dft_fm) <- paste0('DFT', 1:257)
    colnames(css_fm) <- paste0('CSS', 1:257)
    colnames(lps_fm) <- paste0('LPS', 1:257)
    colnames(mf_fm) <- paste0('MFCC', 1:numcep)

    # final data frame
    df <- dplyr::bind_cols(id, f0_fm, fo_fm, zcr_fm, rms1_fm, rms2_fm,
                           mhs_fm, gain_fm, rfc_fm, ac_fm, cep_fm,
                           dft_fm, css_fm, lps_fm, mf_fm)

    # return df
    if(as.tibble){
       return(as_tibble(df))
    } else{return(df)}
}
