#' Extract audio features
#' @description Extracts features from WAV audio files.
#' @param x A vector containing either files or directories of audio files in WAV format.
#' @param features Vector of features to be extracted. (Default: \code{'f0','fmt','rf','rcf','rpf','rfc','mfcc'}). The \code{'fmt_praat'} feature may take long time processing. The following features may contain a variable number of columns: \code{'cep'}, \code{'dft'}, \code{'css'} and \code{'lps'}.
#' @param filesRange The desired range of directory files (Default: \code{NULL}, i.e., all files). Should only be used when all the WAV files are in the same folder.
#' @param sex \code{= <code>} set sex specific parameters where <code> = \code{'f'}[emale], \code{'m'}[ale] or \code{'u'}[nknown] (Default: \code{'u'}). Used as 'gender' by \code{wrassp::ksvF0}, \code{wrassp::forest} and \code{wrassp::mhsF0}.
#' @param windowShift \code{= <dur>} set analysis window shift to <dur>ation in ms (Default: \code{5.0}). Used by \code{wrassp::ksvF0}, \code{wrassp::forest}, \code{wrassp::mhsF0}, \code{wrassp::zcrana}, \code{wrassp::rfcana}, \code{wrassp::acfana}, \code{wrassp::cepstrum}, \code{wrassp::dftSpectrum}, \code{wrassp::cssSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param numFormants \code{= <num>} <num>ber of formants (Default: \code{8}). Used by \code{wrassp::forest}.
#' @param numcep Number of Mel-frequency cepstral coefficients (cepstra) to return (Default: \code{12}). Used by \code{tuneR::melfcc}.
#' @param dcttype Type of DCT used. \code{'t1'} or \code{'t2'}, \code{'t3'} for HTK \code{'t4'} for feacalc (Default: \code{'t2'}). Used by \code{tuneR::melfcc}.
#' @param fbtype Auditory frequency scale to use: \code{'mel'}, \code{'bark'}, \code{'htkmel'}, \code{'fcmel'} (Default: \code{'mel'}). Used by \code{tuneR::melfcc}.
#' @param resolution \code{= <freq>} set FFT length to the smallest value which results in a frequency resolution of <freq> Hz or better (Default: \code{40.0}). Used by \code{wrassp::cssSpectrum}, \code{wrassp::dftSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param usecmp Logical. Apply equal-loudness weighting and cube-root compression (PLP instead of LPC) (Default: \code{FALSE}). Used by \code{tuneR::melfcc}.
#' @param mc.cores Number of cores to be used in parallel processing. (Default: \code{1})
#' @param full.names Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (Default: \code{TRUE}) Used by \code{base::list.files}.
#' @param recursive Logical. Should the listing recursively into directories? (Default: \code{FALSE}) Used by \code{base::list.files}.
#' @param check.mono Logical. Check if the WAV file is mono. (Default: \code{TRUE})
#' @param stereo2mono (Experimental) Logical. Should files be converted from stereo to mono? (Default: \code{TRUE})
#' @param overwrite (Experimental) Logical. Should converted files be overwritten? If not, the file gets the suffix \code{_mono}. (Default: \code{FALSE})
#' @param freq Frequency in Hz to write the converted files when \code{stereo2mono=TRUE}. (Default: \code{44100})
#' @param round.to Number of decimal places to round to. (Default: \code{NULL})
#' @param verbose Logical. Should the running status be showed? (Default: \code{FALSE})
#' @param pycall Python call. See \url{https://github.com/filipezabala/voice} for details.
#' @return A Media data frame containing the selected features.
#' @details The feature 'df' corresponds to 'formant dispersion' (df2:df8) by Fitch (1997), 'pf' to formant position' (pf1:pf8) by Puts, Apicella & Cárdena (2011), 'rf' to 'formant removal' (rf1:rf8) by Zabala (2023), 'rcf' to 'formant cumulated removal' (rcf2:rcf8) by Zabala (2023) and 'rpf' to 'formant position removal' (rpf2:rpf8) by Zabala (2023).
#' @references Levinson N. (1946). The Wiener (root mean square) error criterion in filter design and prediction. Journal of Mathematics and Physics, 25(1-4), 261–278. (\doi{10.1002/SAPM1946251261})
#'
#' Durbin J. (1960). “The fitting of time-series models.” Revue de l’Institut International de Statistique, pp. 233–244. (\url{https://www.jstor.org/stable/1401322})
#'
#' Cooley J.W., Tukey J.W. (1965). “An algorithm for the machine calculation of complex Fourier series.” Mathematics of computation, 19(90), 297–301. (\url{https://www.ams.org/journals/mcom/1965-19-090/S0025-5718-1965-0178586-1/})
#'
#' Wasson D., Donaldson R. (1975). “Speech amplitude and zero crossings for automated identification of human speakers.” IEEE Transactions on Acoustics, Speech, and Signal Processing, 23(4), 390–392. (\url{https://ieeexplore.ieee.org/document/1162690})
#'
#' Allen J. (1977). “Short term spectral analysis, synthesis, and modification by discrete Fourier transform.” IEEE Transactions on Acoustics, Speech, and Signal Processing, 25(3), 235– 238. (\url{https://ieeexplore.ieee.org/document/1162950})
#'
#' Schäfer-Vincent K. (1982). "Significant points: Pitch period detection as a problem of segmentation." Phonetica, 39(4-5), 241–253. (\doi{10.1159/000261665} )
#'
#' Schäfer-Vincent K. (1983). "Pitch period detection and chaining: Method and evaluation." Phonetica, 40(3), 177–202. (\doi{10.1159/000261691})
#'
#' Ephraim Y., Malah D. (1984). “Speech enhancement using a minimum-mean square error short-time spectral amplitude estimator.” IEEE Transactions on acoustics, speech, and signal processing, 32(6), 1109–1121. (\url{https://ieeexplore.ieee.org/document/1164453})
#'
#' Delsarte P., Genin Y. (1986). “The split Levinson algorithm.” IEEE transactions on acoustics, speech, and signal processing, 34(3), 470–478. (\url{https://ieeexplore.ieee.org/document/1164830})
#'
#' Jackson J.C. (1995). "The Harmonic Sieve: A Novel Application of Fourier Analysis to Machine Learning Theory and Practice." Technical report, Carnegie-Mellon University Pittsburgh PA Schoo; of Computer Science. (\url{https://apps.dtic.mil/sti/pdfs/ADA303368.pdf})
#'
#' Fitch, W.T. (1997) "Vocal tract length and formant frequency dispersion correlate with body size in rhesus macaques." J. Acoust. Soc. Am. 102, 1213 – 1222. (\doi{10.1121/1.421048})
#'
#' Boersma P., van Heuven V. (2001). Praat, a system for doing phonetics by computer. Glot. Int., 5(9/10), 341–347. (\url{https://www.fon.hum.uva.nl/paul/papers/speakUnspeakPraat_glot2001.pdf})
#'
#' Ellis DPW (2005). “PLP and RASTA (and MFCC, and inversion) in Matlab.” Online web resource. (\url{https://www.ee.columbia.edu/~dpwe/resources/matlab/rastamat/})
#'
#' Puts, D.A., Apicella, C.L., Cardenas, R.A. (2012) "Masculine voices signal men's threat potential in forager and industrial societies." Proc. R. Soc. B Biol. Sci. 279, 601–609. (\doi{10.1098/rspb.2011.0829})
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern = glob2rx('*.wav'), full.names = TRUE)
#'
#' # minimal usage
#' M1 <- extract_features(path2wav)
#' M2 <- extract_features(dirname(path2wav))
#' identical(M1,M2)
#' table(basename(M1$wav_path))
#'
#' # limiting filesRange
#' M3 <- extract_features(path2wav, filesRange = 3:6)
#' table(basename(M3$wav_path))
#' @export
extract_features <- function(x,
                             features = c('f0', 'fmt',        # F0 and formants
                                          'rf', 'rpf', 'rcf', # Formant removals
                                          'rfc',              # (R)e(F)lection (C)oefficients
                                          'mfcc'),            # (M)el (Frequency (C)epstral (C)oefficients
                             filesRange = NULL,
                             sex = 'u',
                             windowShift = 10,
                             numFormants = 8,
                             numcep = 12,
                             dcttype = c('t2', 't1', 't3', 't4'),
                             fbtype = c('mel', 'htkmel', 'fcmel', 'bark'),
                             resolution = 40,
                             usecmp = FALSE,
                             mc.cores = 1,
                             full.names = TRUE,
                             recursive = FALSE,
                             check.mono = FALSE,
                             stereo2mono = FALSE,
                             overwrite = FALSE,
                             freq = 44100,
                             round.to = NULL,
                             verbose = FALSE,
                             pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'){

  # time processing
  pt0 <- proc.time()

  # checking if x is composed by files or directories
  if(utils::file_test('-f', x[1])){
    wavDir <- lapply(x, dirname)
    wavDir <- do.call(rbind, wavDir)
    wavDir <- unique(wavDir)
    wavFiles <- x
  } else{
    wavDir <- unique(x)
    nWavDir <- length(wavDir)
    wavFiles <- lapply(wavDir, list.files, pattern = '[[:punct:]][wW][aA][vV]$',
                       full.names = full.names, recursive = recursive)
    wavFiles <- do.call(rbind, as.list(unlist(wavFiles)))
    # wavFiles <- do.call(rbind, wavFiles)
  }

  # filtering by filesRange
  if(!is.null(filesRange)){
    fullRange <- 1:length(wavFiles)
    filesRange <- base::intersect(fullRange, filesRange)
    wavFiles <- wavFiles[filesRange]
  }

  # number of wav files to be extracted
  nWav <- length(wavFiles)

  # checking mono/stereo (GO PARALLEL?)
  if(check.mono){
    mono <- sapply(wavFiles, voice::is_mono)
    which.stereo <- which(!mono)
    ns <- length(which.stereo)
    if(sum(which.stereo)){
      if(verbose){
        cat('The following', ns, 'audio files are stereo and must be converted to mono: \n',
            paste0(names(mono[which.stereo]), sep = '\n'), '\n')
      }
      if(stereo2mono){
        audio <- sapply(wavFiles[which.stereo], tuneR::readWave)
        new.mono <- sapply(audio, tuneR::mono)
        n <- sapply(wavFiles[which.stereo], nchar)
        for(i in 1:ns){
          if(overwrite){
            seewave::savewav(new.mono[[i]], f=freq,
                             filename = wavFiles[which.stereo][i])
          }
          else if(!overwrite){
            new.name <- substr(wavFiles[which.stereo][i], 1, n[i]-4)
            new.name <- paste0(new.name, '_mono.wav')
            seewave::savewav(new.mono[[i]], f=freq, filename = new.name)
          }
        }
      }
    }
  }

  # checking lpa features
  f <- vector(length = 3)
  f[1] <- sum(features == 'rms')
  f[2] <- sum(features == 'gain')
  f[3] <- sum(features == 'rfc')

  # list of features
  features2 <- base::setdiff(features, c('df','pf','rf','rcf','rpf'))
  nFe <- length(features2)
  ifelse(sum(f) == 0, ind1 <- 0, ind1 <- 1)
  ifelse(sum(features == 'mfcc'), ind2 <- 0, ind2 <- 1)
  features.list.temp <- vector('list', nFe-sum(f)+ind1+ind2)
  features.list <- vector('list', nFe)
  length.list <- vector('list', nFe)
  i.temp <- 0
  i <- 0

  # 1. F0 analysis of the signal via Schafer-Vincent (1983), wrassp::ksvF0
  if('f0' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::ksvF0,
                                                       gender = sex,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'f0'
    names(features.list)[i] <- 'f0'
    names(length.list)[i] <- 'f0'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 2. F0 analysis of the signal via Jackson (1995) [Michel’s (M)odified (H)armonic (S)ieve algorithm], wrassp::mhsF0
  if('f0_mhs' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::mhsF0,
                                                       toFile = FALSE,
                                                       gender = sex,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'f0_mhs'
    names(features.list)[i] <- 'f0_mhs'
    names(length.list)[i] <- 'f0_mhs'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }


  # 3. F0 analysis of the signal via Boersma (1993)
  if('f0_praat' %in% features){
    i.temp <- i.temp+1
    i <- i+1

    # setting environment
    reticulate::use_condaenv(pycall, required = TRUE)
    parselmouth <- reticulate::import('parselmouth')

    # setting structure
    names(features.list.temp)[i.temp] <- 'f0_praat'
    names(features.list)[i] <- 'f0_praat'
    names(length.list)[i] <- 'f0_praat'
    features.list.temp[[i.temp]] <- vector('list', nWav)

    # F0 extraction
    for(j in 1:nWav){
      snd <- parselmouth$Sound(wavFiles[j])
      pitch <- snd$to_pitch(time_step = windowShift/1000)
      interval <- seq(pitch$start_time, pitch$end_time, windowShift/1000)

      f0_praat_temp <- sapply(interval, pitch$get_value_at_time)
      f0_praat_temp[is.nan(f0_praat_temp)] <- NA
      features.list.temp[[i.temp]][[j]] <- f0_praat_temp
    }

    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]], length))
  }

  # 4. Formant estimation (f1:f8) via wrassp::forest
  if('fmt' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::forest,
                                                       gender = sex,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       numFormants = numFormants,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'fmt'
    names(features.list)[i] <- 'fmt'
    names(length.list)[i] <- 'fmt'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 5. Formant estimation (f1_praat:f8_praat) via Burg algorithm
  if('fmt_praat' %in% features){
    i.temp <- i.temp+1
    i <- i+1

    # setting environment
    reticulate::use_condaenv(pycall, required = TRUE)
    parselmouth <- reticulate::import('parselmouth')

    # setting structure
    names(features.list.temp)[i.temp] <- 'fmt_praat'
    names(features.list)[i] <- 'fmt_praat'
    names(length.list)[i] <- 'fmt_praat'
    features.list.temp[[i.temp]] <- vector('list', nWav)

    # Formant extraction
    for(j in 1:nWav){
      # formants extraction
      snd <- parselmouth$Sound(wavFiles[j])
      fmt <- snd$to_formant_burg(time_step = windowShift/1000,
                                 max_number_of_formants = numFormants)
      interval <- seq(fmt$start_time, fmt$end_time, windowShift/1000)

      #TODO: build with apply
      fmt_praat_temp <- matrix(nrow = length(interval), ncol = numFormants)
      colnames(fmt_praat_temp) <- paste0('fmt_', 1:numFormants)
      for(k in 1:numFormants){
        for(l in 1:length(interval)){
          fmt_praat_temp[l,k] <- fmt$get_value_at_time(formant_number = as.integer(k),
                                                       time = interval[l])
        }
      }
      fmt_praat_temp[is.nan(fmt_praat_temp)] <- NA
      features.list.temp[[i.temp]][[j]] <- fmt_praat_temp
    }

    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]], nrow))
  }

  # 6. Analysis of the averages of the short-term positive and negative (Z)ero-(C)rossing (R)ates
  if('zcr' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::zcrana,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'zcr'
    names(features.list)[i] <- 'zcr'
    names(length.list)[i] <- 'zcr'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }


  # 7. (L)inear (P)rediction (A)nalysis [rms, gain, rfc]
  if('rms' %in% features | 'gain' %in% features | 'rfc' %in% features){
    i.temp <- i.temp+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::rfcana,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'lpa'

    if('rms' %in% features){
      i <- i+1
      names(features.list)[i] <- 'rms'
      names(length.list)[i] <- 'rms'
      length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                        wrassp::numRecs.AsspDataObj))
    }

    if('gain' %in% features){
      i <- i+1
      names(features.list)[i] <- 'gain'
      names(length.list)[i] <- 'gain'
      # features.list[[i]] <- dplyr::tibble()
      length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                        wrassp::numRecs.AsspDataObj))
    }

    if('rfc' %in% features){
      i <- i+1
      names(features.list)[i] <- 'rfc'
      names(length.list)[i] <- 'rfc'
      length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                        wrassp::numRecs.AsspDataObj))
    }
  }

  # 8. Analysis of short-term (A)uto(C)orrelation function
  if('ac' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::acfana,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'ac'
    names(features.list)[i] <- 'ac'
    names(length.list)[i] <- 'ac'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 9. Short-term (CEP)stral analysis
  if('cep' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::cepstrum,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'cep'
    names(features.list)[i] <- 'cep'
    names(length.list)[i] <- 'cep'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 10. Short-term (DFT) spectral analysis
  if('dft' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::dftSpectrum,
                                                       toFile = FALSE,
                                                       resolution = resolution,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'dft'
    names(features.list)[i] <- 'dft'
    names(length.list)[i] <- 'dft'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 11. (C)epstral (S)moothed version of dft(S)pectrum
  if('css' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::cssSpectrum,
                                                       toFile = FALSE,
                                                       resolution = resolution,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'css'
    names(features.list)[i] <- 'css'
    names(length.list)[i] <- 'css'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 12. (L)inear (P)redictive (S)moothed version of dftSpectrum
  if('lps' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::lpsSpectrum,
                                                       toFile = FALSE,
                                                       resolution = resolution,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'lps'
    names(features.list)[i] <- 'lps'
    names(length.list)[i] <- 'lps'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 13. Mel-Frequency Cepstral Coefficients (MFCC)
  rWave <- parallel::mclapply(wavFiles, tuneR::readWave, mc.cores = mc.cores)
  i.temp <- i.temp+1
  features.list.temp[[i.temp]] <- parallel::mclapply(rWave, tuneR::melfcc,
                                                     wintime = windowShift/1000,
                                                     hoptime = windowShift/1000,
                                                     dcttype = dcttype,
                                                     numcep = numcep,
                                                     fbtype = fbtype,
                                                     usecmp = usecmp,
                                                     mc.cores = mc.cores)
  names(features.list.temp)[i.temp] <- 'mfcc'

  if('mfcc' %in% features){
    i <- i+1
    names(features.list)[i] <- 'mfcc'
    names(length.list)[i] <- 'mfcc'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]], nrow))
  }

  # creating tibbles at features.list
  features.list <- lapply(features.list, dplyr::tibble)

  # minimum length
  n_min <- apply(dplyr::bind_rows(length.list), 1, min)

  # concatenating
  for(j in 1:nWav){ # upgrade: use bind_rows, foreach

    # time processing
    pt1 <- proc.time()

    if('f0' %in% features){
      f0_temp <- as.matrix(features.list.temp$f0[[j]]$F0[1:n_min[j]], ncol = 1)
      features.list$f0 <- rbind(features.list$f0, f0_temp)
    }

    if('f0_mhs' %in% features){
      f0_mhs_temp <- as.matrix(features.list.temp$f0_mhs[[j]]$pitch[1:n_min[j],],
                               ncol = 1)
      features.list$f0_mhs <- rbind(features.list$f0_mhs, f0_mhs_temp)
    }

    if('f0_praat' %in% features){
      f0_praat_temp <- as.matrix(features.list.temp$f0_praat[[j]][1:n_min[j]],
                                 ncol = 1)
      features.list$f0_praat <- rbind(features.list$f0_praat, f0_praat_temp)
    }

    if('fmt' %in% features){
      fmt_temp <- as.matrix(features.list.temp$fmt[[j]]$fm[1:n_min[j],],
                           ncol = numFormants)
      features.list$fmt <- rbind(features.list$fmt, fmt_temp)
    }

    if('fmt_praat' %in% features){
      fmt_praat_temp <- as.matrix(features.list.temp$fmt_praat[[j]][1:n_min[j],],
                                  ncol = numFormants)
      features.list$fmt_praat <- rbind(features.list$fmt_praat, fmt_praat_temp)
    }

    if('zcr' %in% features){
      zcr_temp <- as.matrix(features.list.temp$zcr[[j]]$zcr[1:n_min[j],],
                            ncol = 1)
      features.list$zcr <- rbind(features.list$zcr, zcr_temp)
    }

    if('rms' %in% features){
      rms_temp <- as.matrix(features.list.temp$lpa[[j]]$rms[1:n_min[j],],
                            ncol = 1)
      features.list$rms <- rbind(features.list$rms, rms_temp)
    }

    if('gain' %in% features){
      gain_temp <- as.matrix(features.list.temp$lpa[[j]]$gain[1:n_min[j],],
                             ncol = 1)
      features.list$gain <- rbind(features.list$gain, gain_temp)
    }

    if('rfc' %in% features){
      rfc_temp <- as.matrix(features.list.temp$lpa[[j]]$rfc[1:n_min[j],],
                            ncol = 19)
      features.list$rfc <- rbind(features.list$rfc, rfc_temp)
    }

    if('ac' %in% features){
      ac_temp <- as.matrix(features.list.temp$ac[[j]]$acf[1:n_min[j],],
                           ncol = 20)
      features.list$ac <- rbind(features.list$ac, ac_temp)
    }

    if('cep' %in% features){
      cep_temp <- as.matrix(features.list.temp$cep[[j]]$cep[1:n_min[j],],
                            ncol = 257)
      features.list$cep <- rbind(features.list$cep, cep_temp)
    }

    if('dft' %in% features){
      dft_temp <- as.matrix(features.list.temp$dft[[j]]$dft[1:n_min[j],],
                            ncol = 257)
      features.list$dft <- rbind(features.list$dft, dft_temp)
    }

    if('css' %in% features){
      css_temp <- as.matrix(features.list.temp$css[[j]]$css[1:n_min[j],],
                            ncol = 257)
      features.list$css <- rbind(features.list$css, css_temp)
    }

    if('lps' %in% features){
      lps_temp <- as.matrix(features.list.temp$lps[[j]]$lps[1:n_min[j],],
                            ncol = 257)
      features.list$lps <- rbind(features.list$lps, lps_temp)
    }

    if('mfcc' %in% features){
      features.list$mfcc <- rbind(features.list$mfcc,
                                  features.list.temp$mfcc[[j]][1:n_min[j],])
    }

    if(verbose){
      cat('PROGRESS', paste0(round(j/nWav*100,2),'%'), '\n')
    }
    t1 <- proc.time()-pt1
    if(verbose){
      cat('FILE', j, 'OF', nWav, '|', t1[3], 'SECONDS\n\n')
    }
  }

  # id, using smaller length: n_min
  id <- tibble::enframe(rep(wavFiles, n_min), value = 'wav_path',
                        name = NULL)

  # colnames
  if('f0' %in% features){
    colnames(features.list$f0) <- 'f0'
  }

  if('f0_mhs' %in% features){
    colnames(features.list$f0_mhs) <- paste0('f0_mhs')
  }

  if('f0_praat' %in% features){
    colnames(features.list$f0_praat) <- paste0('f0_praat')
  }

  if('fmt' %in% features){
    colnames(features.list$fmt) <- paste0('f', 1:ncol(features.list$fmt))
  }

  if('fmt_praat' %in% features){
    colnames(features.list$fmt_praat) <- paste0('f', 1:ncol(features.list$fmt_praat), '_praat')
  }

  if('zcr' %in% features){
    colnames(features.list$zcr) <- paste0('zcr', 1:ncol(features.list$zcr))
  }

  if('rms' %in% features){
    colnames(features.list$rms) <- paste0('rms')
  }

  if('gain' %in% features){
    colnames(features.list$gain) <- paste0('gain')
  }

  if('rfc' %in% features){
    colnames(features.list$rfc) <- paste0('rfc', 1:ncol(features.list$rfc))
  }

  if('ac' %in% features){
    colnames(features.list$ac) <- paste0('acf', 1:ncol(features.list$ac))
  }

  if('cep' %in% features){
    colnames(features.list$cep) <- paste0('cep', 1:ncol(features.list$cep))
  }

  if('dft' %in% features){
    colnames(features.list$dft) <- paste0('dft', 1:ncol(features.list$dft))
  }

  if('css' %in% features){
    colnames(features.list$css) <- paste0('css', 1:ncol(features.list$css))
  }

  if('lps' %in% features){
    colnames(features.list$lps) <- paste0('lps', 1:ncol(features.list$lps))
  }

  if('mfcc' %in% features){
    colnames(features.list$mfcc) <- paste0('mfcc', 1:ncol(features.list$mfcc))
  }

  # as data frame
  dat <- dplyr::bind_cols(id, features.list)

  # rounding
  if(!is.null(round.to)){
    dat[-1] <- round(dat[-1], round.to)
  }

  # replacing 0 by NA
  dat[-1][sapply(dat[-1], R.utils::isZero)] <- NA

  # 14. Df - Formant Dispersion by Fitch (1997)
  if('f0' %in% features & 'fmt' %in% features & 'df' %in% features){
    if(numFormants >= 2) {dat$df2 <- (dat$f2-dat$f1)/1}
    if(numFormants >= 3) {dat$df3 <- (dat$f3-dat$f1)/2}
    if(numFormants >= 4) {dat$df4 <- (dat$f4-dat$f1)/3}
    if(numFormants >= 5) {dat$df5 <- (dat$f5-dat$f1)/4}
    if(numFormants >= 6) {dat$df6 <- (dat$f6-dat$f1)/5}
    if(numFormants >= 7) {dat$df7 <- (dat$f7-dat$f1)/6}
    if(numFormants >= 8) {dat$df8 <- (dat$f8-dat$f1)/7}
  }

  # TODO: in scale check if columns are not constant (degenerated random variables)
  # Scaling
  if('f0' %in% features & 'fmt' %in% features &
     ('pf' %in% features | 'rf' %in% features |
      'rcf' %in% features | 'rpf' %in% features)){
    cn <- paste0('f', 0:numFormants)
    f_sc <- sapply(dat[,cn], scale)
  }

  # 15. Pf - Formant Position by Puts, Apicella & Cárdenas (2011)
  if('f0' %in% features & 'fmt' %in% features & 'pf' %in% features){
    if(numFormants >= 1) {dat$pf1 <- f_sc[,'f1']}
    if(numFormants >= 2) {dat$pf2 <- rowMeans(f_sc[,c('f1','f2')], na.rm = TRUE)}
    if(numFormants >= 3) {dat$pf3 <- rowMeans(f_sc[,c('f1','f2','f3')], na.rm = TRUE)}
    if(numFormants >= 4) {dat$pf4 <- rowMeans(f_sc[,c('f1','f2','f3','f4')], na.rm = TRUE)}
    if(numFormants >= 5) {dat$pf5 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5')], na.rm = TRUE)}
    if(numFormants >= 6) {dat$pf6 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6')], na.rm = TRUE)}
    if(numFormants >= 7) {dat$pf7 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6','f7')], na.rm = TRUE)}
    if(numFormants >= 8) {dat$pf8 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6','f7','f8')], na.rm = TRUE)}
  }

  # 16. Rf - Formant Removal by Zabala (2023)
  if('f0' %in% features & 'fmt' %in% features & 'rf' %in% features){
    if(numFormants >= 1) {dat$rf1 <- f_sc[,'f0']-f_sc[,'f1']}
    if(numFormants >= 2) {dat$rf2 <- f_sc[,'f0']-f_sc[,'f2']}
    if(numFormants >= 3) {dat$rf3 <- f_sc[,'f0']-f_sc[,'f3']}
    if(numFormants >= 4) {dat$rf4 <- f_sc[,'f0']-f_sc[,'f4']}
    if(numFormants >= 5) {dat$rf5 <- f_sc[,'f0']-f_sc[,'f5']}
    if(numFormants >= 6) {dat$rf6 <- f_sc[,'f0']-f_sc[,'f6']}
    if(numFormants >= 7) {dat$rf7 <- f_sc[,'f0']-f_sc[,'f7']}
    if(numFormants >= 8) {dat$rf8 <- f_sc[,'f0']-f_sc[,'f8']}
  }

  # 17. RCf - Formant Cumulated Removal by Zabala (2023)
  if('f0' %in% features & 'fmt' %in% features & 'rcf' %in% features){
    # if(numFormants >= 1) {dat$rcf1 <- f_sc[,'f0']-f_sc[,'f1']} # equivalent to Rf1 and RPf1
    if(numFormants >= 2) {dat$rcf2 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2')], na.rm = TRUE)}
    if(numFormants >= 3) {dat$rcf3 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3')], na.rm = TRUE)}
    if(numFormants >= 4) {dat$rcf4 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4')], na.rm = TRUE)}
    if(numFormants >= 5) {dat$rcf5 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5')], na.rm = TRUE)}
    if(numFormants >= 6) {dat$rcf6 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5','f6')], na.rm = TRUE)}
    if(numFormants >= 7) {dat$rcf7 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5','f6','f7')], na.rm = TRUE)}
    if(numFormants >= 8) {dat$rcf8 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5','f6','f7','f8')], na.rm = TRUE)}
  }

  # 18. RPf - Formant Position Removal by Zabala (2023)
  if('f0' %in% features & 'fmt' %in% features & 'rpf' %in% features){
    # if(numFormants >= 1) {dat$rpf1 <- f_sc[,'f0']-dat$pf1} # equivalent to Rf1 and RCf1
    if(numFormants >= 2) {dat$rpf2 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2')], na.rm = TRUE)}
    if(numFormants >= 3) {dat$rpf3 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2','f3')], na.rm = TRUE)}
    if(numFormants >= 4) {dat$rpf4 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2','f3','f4')], na.rm = TRUE)}
    if(numFormants >= 5) {dat$rpf5 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2','f3','f4','f5')], na.rm = TRUE)}
    if(numFormants >= 6) {dat$rpf6 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6')], na.rm = TRUE)}
    if(numFormants >= 7) {dat$rpf7 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6','f7')], na.rm = TRUE)}
    if(numFormants >= 8) {dat$rpf8 <- f_sc[,'f0']-rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6','f7','f8')], na.rm = TRUE)}
  }

  # creating ids
  idf <- lapply(n_min, seq, 1)
  dat <- dplyr::bind_cols(section_seq = 1:nrow(dat),
                          section_seq_file = unlist(lapply(idf, rev)), dat)

  # total time
  t0 <- proc.time()-pt0
  if(verbose){
    cat('TOTAL TIME', t0[3], 'SECONDS\n\n')
  }

  # return dat
  return(dat)
}
