#' Extracts features from WAV audio files
#' @description Extracts features from WAV audio files.
#' @param x A vector containing either files or directories of audio files in WAV format.
#' @param filesRange The desired range of directory files (default: \code{NULL}, i.e., all files). Should only be used when all the WAV files are in the same folder.
#' @param features Vector of features to be extracted. (default: 'f0','formants','mfcc','df','pf','rf','rcf','rpf'). The following features may contain a variable number of columns: \code{'cep'}, \code{'dft'}, \code{'css'} and \code{'lps'}.
#' @param gender \code{= <code>} set gender specific parameters where <code> = \code{'f'}[emale], \code{'m'}[ale] or \code{'u'}[nknown] (default: \code{'u'}). Used by \code{wrassp::ksvF0}, \code{wrassp::forest} and \code{wrassp::mhsF0}.
#' @param windowShift \code{= <dur>} set analysis window shift to <dur>ation in ms (default: 5.0). Used by \code{wrassp::ksvF0}, \code{wrassp::forest}, \code{wrassp::mhsF0}, \code{wrassp::zcrana}, \code{wrassp::rfcana}, \code{wrassp::acfana}, \code{wrassp::cepstrum}, \code{wrassp::dftSpectrum}, \code{wrassp::cssSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param numFormants \code{= <num>} <num>ber of formants (default: 8). Used by \code{wrassp::forest}.
#' @param numcep Number of Mel-frequency cepstral coefficients (cepstra) to return (default: 12). Used by \code{tuneR::melfcc}.
#' @param dcttype Type of DCT used. \code{'t1'} or \code{'t2'}, \code{'t3'} for HTK \code{'t4'} for feacalc (default = \code{'t2'}). Used by \code{tuneR::melfcc}.
#' @param fbtype Auditory frequency scale to use: \code{'mel'}, \code{'bark'}, \code{'htkmel'}, \code{'fcmel'} (default: \code{'mel'}). Used by \code{tuneR::melfcc}.
#' @param resolution \code{= <freq>} set FFT length to the smallest value which results in a frequency resolution of <freq> Hz or better (default: 40.0). Used by \code{wrassp::cssSpectrum}, \code{wrassp::dftSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param usecmp Logical. Apply equal-loudness weighting and cube-root compression (PLP instead of LPC) (default: \code{FALSE}). Used by \code{tuneR::melfcc}.
#' @param mc.cores Number of cores to be used in parallel processing. (default: \code{1})
#' @param full.names Logical. If \code{TRUE}, the directory path is prepended to the file names to give a relative file path. If \code{FALSE}, the file names (rather than paths) are returned. (default: \code{TRUE}) Used by \code{base::list.files}.
#' @param recursive Logical. Should the listing recursively into directories? (default: \code{FALSE}) Used by \code{base::list.files}.
#' @param check.mono Logical. Check if the WAV file is mono. (default: \code{TRUE})
#' @param stereo2mono Logical. Should files be converted from stereo to mono? (default: \code{TRUE})
#' @param overwrite Logical. Should converted files be overwritten? If not, the file gets the suffix \code{_mono}. (default: \code{FALSE})
#' @param freq Frequency in Hz to write the converted files when \code{stereo2mono=TRUE}. (default: \code{44100})
#' @param round.to Number of decimal places to round to. (default: \code{NULL})
#' @param verbose Logical. Should the running status be showed? (default: \code{FALSE})
#' @return A Media data frame containing the selected features.
#' @details When \code{features} 'df', 'pf', 'rf', 'rcf' or 'rpf' are selected, 'f0' and 'formants' must be selected. The feature 'df' corresponds to 'formant dispersion' (df2:df8) by Fitch (1997), 'pf' to formant position' (pf1:pf8) by Puts, Apicella & Cárdena (2011), 'rf' to 'formant removal' (rf1:rf8) by Zabala (2022), 'rcf' to 'formant cumulated removal' (rcf2:rcf8) by Zabala (2022) and 'rpf' to 'formant position removal' (rpf1:rpf8) by Zabala (2022).
#' @references Fitch, W.T. (1997) Vocal tract length and formant frequency dispersion correlate with body size in rhesus macaques. J. Acoust. Soc. Am. 102, 1213 – 1222. (\doi{10.1121/1.421048})
#'
#' Puts, D.A., Apicella, C.L., Cardenas, R.A. (2012) Masculine voices signal men's threat potential in forager and industrial societies. Proc. R. Soc. B Biol. Sci. 279, 601–609. (\doi{10.1098/rspb.2011.0829})
#' @examples
#' library(voice)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
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
                             filesRange = NULL,
                             features = c('f0','formants','mfcc',
                                          'df','pf','rf','rcf','rpf'),
                             gender = 'u',
                             windowShift = 5,
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
                             verbose = FALSE){

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

  # 1. f0 analysis of the signal
  if('f0' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::ksvF0,
                                                       gender = gender,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'f0'
    names(features.list)[i] <- 'f0'
    names(length.list)[i] <- 'f0'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 2. Formant estimation (f1:f8)
  if('formants' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::forest,
                                                       gender = gender,
                                                       toFile = FALSE,
                                                       windowShift = windowShift,
                                                       numFormants = numFormants,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'formants'
    names(features.list)[i] <- 'formants'
    names(length.list)[i] <- 'formants'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 3. Analysis of the averages of the short-term positive and negative (Z)ero-(C)rossing (R)ates
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

  # 4. Pitch analysis of the speech signal using Michel’s (M)odified (H)armonic (S)ieve algorithm
  if('mhs' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::mhsF0,
                                                       toFile = FALSE,
                                                       gender = gender,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'mhs'
    names(features.list)[i] <- 'mhs'
    names(length.list)[i] <- 'mhs'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 5. (L)inear (P)rediction (A)nalysis [rms, gain, rfc]
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

  # 6. Analysis of short-term (A)uto(C)orrelation function
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

  # 7. Short-term (CEP)stral analysis
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

  # 8. Short-term (DFT) spectral analysis
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

  # 9. (C)epstral (S)moothed version of dft(S)pectrum
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

  # 10. (L)inear (P)redictive (S)moothed version of dftSpectrum
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

  # 11. Mel-Frequency Cepstral Coefficients (MFCC)
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

    if('formants' %in% features){
      fo_temp <- as.matrix(features.list.temp$fo[[j]]$fm[1:n_min[j],],
                           ncol = numFormants)
      features.list$formants <- rbind(features.list$formants, fo_temp)
    }

    if('zcr' %in% features){
      zcr_temp <- as.matrix(features.list.temp$zcr[[j]]$zcr[1:n_min[j],],
                            ncol = 1)
      features.list$zcr <- rbind(features.list$zcr, zcr_temp)
    }

    if('mhs' %in% features){
      mhs_temp <- as.matrix(features.list.temp$mhs[[j]]$pitch[1:n_min[j],],
                            ncol = 1)
      features.list$mhs <- rbind(features.list$mhs, mhs_temp)
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

  if('formants' %in% features){
    colnames(features.list$formants) <- paste0('f', 1:ncol(features.list$formants))
    }

  if('zcr' %in% features){
    colnames(features.list$zcr) <- paste0('zcr', 1:ncol(features.list$zcr))
    }

  if('mhs' %in% features){
    colnames(features.list$mhs) <- paste0('mhs')
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

  # 12. Df - Formant Dispersion by Fitch (1997)
  if('f0' %in% features & 'formants' %in% features & 'df' %in% features){
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
  if('f0' %in% features & 'formants' %in% features &
     ('pf' %in% features | 'rf' %in% features |
      'rcf' %in% features | 'rpf' %in% features)){
    cn <- paste0('f', 0:numFormants)
    f_sc <- sapply(dat[,cn], scale)
  }

  # 13. Pf - Formant Position by Puts, Apicella & Cárdenas (2011)
  if('f0' %in% features & 'formants' %in% features & 'pf' %in% features){
    if(numFormants >= 1) {dat$pf1 <- f_sc[,'f1']}
    if(numFormants >= 2) {dat$pf2 <- rowMeans(f_sc[,c('f1','f2')], na.rm = TRUE)}
    if(numFormants >= 3) {dat$pf3 <- rowMeans(f_sc[,c('f1','f2','f3')], na.rm = TRUE)}
    if(numFormants >= 4) {dat$pf4 <- rowMeans(f_sc[,c('f1','f2','f3','f4')], na.rm = TRUE)}
    if(numFormants >= 5) {dat$pf5 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5')], na.rm = TRUE)}
    if(numFormants >= 6) {dat$pf6 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6')], na.rm = TRUE)}
    if(numFormants >= 7) {dat$pf7 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6','f7')], na.rm = TRUE)}
    if(numFormants >= 8) {dat$pf8 <- rowMeans(f_sc[,c('f1','f2','f3','f4','f5','f6','f7','f8')], na.rm = TRUE)}
  }

  # 14. Rf - Formant Removal by Zabala (2022)
  if('f0' %in% features & 'formants' %in% features & 'rf' %in% features){
    if(numFormants >= 1) {dat$rf1 <- f_sc[,'f0']-f_sc[,'f1']}
    if(numFormants >= 2) {dat$rf2 <- f_sc[,'f0']-f_sc[,'f2']}
    if(numFormants >= 3) {dat$rf3 <- f_sc[,'f0']-f_sc[,'f3']}
    if(numFormants >= 4) {dat$rf4 <- f_sc[,'f0']-f_sc[,'f4']}
    if(numFormants >= 5) {dat$rf5 <- f_sc[,'f0']-f_sc[,'f5']}
    if(numFormants >= 6) {dat$rf6 <- f_sc[,'f0']-f_sc[,'f6']}
    if(numFormants >= 7) {dat$rf7 <- f_sc[,'f0']-f_sc[,'f7']}
    if(numFormants >= 8) {dat$rf8 <- f_sc[,'f0']-f_sc[,'f8']}
  }

  # 15. RCf - Formant Cumulated Removal by Zabala (2022)
  if('f0' %in% features & 'formants' %in% features & 'rcf' %in% features){
    # if(numFormants >= 1) {dat$rcf1 <- f_sc[,'f0']-f_sc[,'f1']} # equivalent to Rf1 and RPf1
    if(numFormants >= 2) {dat$rcf2 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2')], na.rm = TRUE)}
    if(numFormants >= 3) {dat$rcf3 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3')], na.rm = TRUE)}
    if(numFormants >= 4) {dat$rcf4 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4')], na.rm = TRUE)}
    if(numFormants >= 5) {dat$rcf5 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5')], na.rm = TRUE)}
    if(numFormants >= 6) {dat$rcf6 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5','f6')], na.rm = TRUE)}
    if(numFormants >= 7) {dat$rcf7 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5','f6','f7')], na.rm = TRUE)}
    if(numFormants >= 8) {dat$rcf8 <- f_sc[,'f0']-rowSums(f_sc[,c('f1','f2','f3','f4','f5','f6','f7','f8')], na.rm = TRUE)}
  }

  # 16. RPf - Formant Position Removal by Zabala (2022)
  if('f0' %in% features & 'formants' %in% features & 'rpf' %in% features){
    # if(numFormants >= 1) {dat$rpf1 <- f_sc[,'f0']-dat$pf1} # equivalent to Rf1 and RCf1
    if(numFormants >= 2) {dat$rpf2 <- f_sc[,'f0']-dat$pf2}
    if(numFormants >= 3) {dat$rpf3 <- f_sc[,'f0']-dat$pf3}
    if(numFormants >= 4) {dat$rpf4 <- f_sc[,'f0']-dat$pf4}
    if(numFormants >= 5) {dat$rpf5 <- f_sc[,'f0']-dat$pf5}
    if(numFormants >= 6) {dat$rpf6 <- f_sc[,'f0']-dat$pf6}
    if(numFormants >= 7) {dat$rpf7 <- f_sc[,'f0']-dat$pf7}
    if(numFormants >= 8) {dat$rpf8 <- f_sc[,'f0']-dat$pf8}
  }

  # creating ids
  idf <- lapply(n_min, seq, 1)
  dat <- dplyr::bind_cols(slice_seq = 1:nrow(dat),
                          slice_seq_file = unlist(lapply(idf, rev)), dat)

  # total time
  t0 <- proc.time()-pt0
  if(verbose){
    cat('TOTAL TIME', t0[3], 'SECONDS\n\n')
  }

  # return dat
  return(dat)
}
