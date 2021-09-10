#' Extracts features from WAV audio files.
#' @description Extracts features from WAV audio files.
#' @param directory A directory containing audio file(s) in WAV format. If more than one directory is provided, only the first one is used.
#' @param filesRange The desired range of directory files (default: \code{NULL}, i.e., all files).
#' @param features Vector of features to be extracted. (default: 'f0','formants','zcr','mhs','rms','gain','rfc','ac','mfcc'). The following four features contain 4*257 = 1028 columns (257 each): \code{'cep'}, \code{'dft'}, \code{'css'} and \code{'lps'}.
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
#' @examples
#' library(voice)
#' library(RColorBrewer)
#' library(ellipse)
#' library(ggplot2)
#' library(grDevices)
#' library(ggfortify)
#'
#' # get path to audio file
#' path2wav <- list.files(system.file('extdata', package = 'wrassp'),
#' pattern <- glob2rx('*.wav'), full.names = TRUE)
#'
#' # getting all the 1092 features
#' ef <- extract_features(dirname(path2wav), features = c('f0','formants',
#' 'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'),
#' mc.cores = 1)
#' dim(ef)
#' ef
#'
#' # using the default, i.e., not using 'cep','dft','css' and 'lps' (4*257 = 1028 columns)
#' ef2 <- extract_features(dirname(path2wav), mc.cores = 1)
#' dim(ef2)
#' ef2
#' table(ef2$file_name)
#'
#' # limiting filesRange
#' ef3 <- extract_features(dirname(path2wav), filesRange = 3:6, mc.cores = 1)
#' dim(ef3)
#' ef3
#' table(ef3$file_name)
#'
#' # calculating correlation of ef2
#' data <- cor(ef2[-1])
#'
#' # pane with 100 colors using RcolorBrewer
#' my_colors <- brewer.pal(5, 'Spectral')
#' my_colors <- colorRampPalette(my_colors)(100)
#'
#' # ordering the correlation matrix
#' ord <- order(data[1, ])
#' data_ord <- data[ord, ord]
#' plotcorr(data_ord , col=my_colors[data_ord*50+50] , mar=c(1,1,1,1))
#'
#' # Principal Component Analysis (PCA)
#' (pc <- prcomp(na.omit(ef2[-1]), scale = TRUE))
#' stats::screeplot(pc, type = 'lines')
#'
#' autoplot(pc, data = na.omit(ef2), colour = 'file_name',
#' loadings = TRUE, loadings.label = TRUE)
#' @export
extract_features <- function(directory, filesRange = NULL,
                             features = c('f0','formants','zcr','mhs','rms',
                                          'gain','rfc','ac','mfcc'),
                             gender = 'u', windowShift = 5, numFormants = 8,
                             numcep = 12, dcttype = c('t2', 't1', 't3', 't4'),
                             fbtype = c('mel', 'htkmel', 'fcmel', 'bark'),
                             resolution = 40, usecmp = FALSE,
                             mc.cores = 1,
                             full.names = TRUE, recursive = FALSE,
                             check.mono = TRUE, stereo2mono = TRUE,
                             overwrite = FALSE, freq = 44100,
                             round.to = NULL){

  # time processing
  pt0 <- proc.time()

  # removing duplicates, using the first directory provided
  directory <- directory[1]

  # listing wav files
  wavFiles <- list.files(directory, pattern = '[[:punct:]][wW][aA][vV]$',
                         full.names = full.names, recursive = recursive)

  # filtering by fileRange
  if(!is.null(filesRange)){
    fullRange <- 1:length(wavFiles)
    filesRange <- base::intersect(fullRange,filesRange)
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
      cat('The following', ns, 'audio files are stereo and must be converted to mono: \n',
          paste0(names(mono[which.stereo]), sep = '\n'), '\n')
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
  nFe <- length(features)
  ifelse(sum(f) == 0, ind1 <- 0, ind1 <- 1)
  ifelse(sum(features == 'mfcc'), ind2 <- 0, ind2 <- 1)
  features.list.temp <- vector('list', nFe-sum(f)+ind1+ind2)
  features.list <- vector('list', nFe)
  length.list <- vector('list', nFe)
  i.temp <- 0
  i <- 0

  # 1. F0 analysis of the signal
  if('f0' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::ksvF0,
                                                       gender = gender,
                                                       toFile = F,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'f0'
    names(features.list)[i] <- 'f0'
    names(length.list)[i] <- 'f0'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 2. Formant estimation (F1:F8)
  if('formants' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::forest,
                                                       gender = gender,
                                                       toFile = F,
                                                       windowShift = windowShift,
                                                       numFormants = numFormants,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'formants'
    names(features.list)[i] <- 'formants'
    names(length.list)[i] <- 'formants'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 3. Analysis of the averages of the short-term positive and negative (Z)ero-(C)rossing (R)ates
  if('zcr' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::zcrana,
                                                       toFile = F,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'zcr'
    names(features.list)[i] <- 'zcr'
    names(length.list)[i] <- 'zcr'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 4. Pitch analysis of the speech signal using Michel’s (M)odified (H)armonic (S)ieve algorithm
  if('mhs' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::mhsF0,
                                                       toFile = F,
                                                       gender = gender,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'mhs'
    names(features.list)[i] <- 'mhs'
    names(length.list)[i] <- 'mhs'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 5. (L)inear (P)rediction (A)nalysis [rms, gain, rfc]
  if('rms' %in% features | 'gain' %in% features | 'rfc' %in% features){
    i.temp <- i.temp+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::rfcana,
                                                       toFile = F,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'lpa'

    if('rms' %in% features){
      i <- i+1
      names(features.list)[i] <- 'rms'
      names(length.list)[i] <- 'rms'
      features.list[[i]] <- dplyr::tibble()
      length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                        wrassp::numRecs.AsspDataObj))
    }

    if('gain' %in% features){
      i <- i+1
      names(features.list)[i] <- 'gain'
      names(length.list)[i] <- 'gain'
      features.list[[i]] <- dplyr::tibble()
      length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                        wrassp::numRecs.AsspDataObj))
    }

    if('rfc' %in% features){
      i <- i+1
      names(features.list)[i] <- 'rfc'
      names(length.list)[i] <- 'rfc'
      features.list[[i]] <- dplyr::tibble()
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
                                                       toFile = F,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'ac'
    names(features.list)[i] <- 'ac'
    names(length.list)[i] <- 'ac'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 7. Short-term (CEP)stral analysis
  if('cep' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::cepstrum,
                                                       toFile = F,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'cep'
    names(features.list)[i] <- 'cep'
    names(length.list)[i] <- 'cep'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 8. Short-term (DFT) spectral analysis
  if('dft' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::dftSpectrum,
                                                       toFile = F,
                                                       resolution = resolution,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'dft'
    names(features.list)[i] <- 'dft'
    names(length.list)[i] <- 'dft'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 9. (C)epstral (S)moothed version of dft(S)pectrum
  if('css' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::cssSpectrum,
                                                       toFile = F,
                                                       resolution = resolution,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'css'
    names(features.list)[i] <- 'css'
    names(length.list)[i] <- 'css'
    features.list[[i]] <- dplyr::tibble()
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]],
                                      wrassp::numRecs.AsspDataObj))
  }

  # 10. (L)inear (P)redictive (S)moothed version of dftSpectrum
  if('lps' %in% features){
    i.temp <- i.temp+1
    i <- i+1
    features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles,
                                                       wrassp::lpsSpectrum,
                                                       toFile = F,
                                                       resolution = resolution,
                                                       windowShift = windowShift,
                                                       mc.cores = mc.cores)
    names(features.list.temp)[i.temp] <- 'lps'
    names(features.list)[i] <- 'lps'
    names(length.list)[i] <- 'lps'
    features.list[[i]] <- dplyr::tibble()
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
    features.list[[i]] <- dplyr::tibble()
    names(length.list)[i] <- 'mfcc'
    length.list[[i]] <- unlist(lapply(features.list.temp[[i.temp]], nrow))
  }

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

    cat('PROGRESS', paste0(round(j/nWav*100,2),'%'), '\n')
    t1 <- proc.time()-pt1
    cat('FILE', j, 'OF', nWav, '|', t1[3], 'SECONDS\n\n')
  }

  # id, using smaller length: n_min
  id <- tibble::enframe(rep(basename(wavFiles), n_min), value = 'file_name',
                        name = NULL)

  # colnames
  if('f0' %in% features){
    colnames(features.list$f0) <- 'F0'
    }

  if('formants' %in% features){
    colnames(features.list$formants) <- paste0('F', 1:ncol(features.list$formants))
    }

  if('zcr' %in% features){
    colnames(features.list$zcr) <- paste0('ZCR', 1:ncol(features.list$zcr))
    }

  if('mhs' %in% features){
    colnames(features.list$mhs) <- paste0('MHS')
  }

  if('rms' %in% features){
    colnames(features.list$rms) <- paste0('RMS')
  }

  if('gain' %in% features){
    colnames(features.list$gain) <- paste0('GAIN')
  }

  if('rfc' %in% features){
    colnames(features.list$rfc) <- paste0('RFC', 1:ncol(features.list$rfc))
  }

  if('ac' %in% features){
    colnames(features.list$ac) <- paste0('ACF', 1:ncol(features.list$ac))
  }

  if('cep' %in% features){
    colnames(features.list$cep) <- paste0('CEP', 1:ncol(features.list$cep))
  }

  if('dft' %in% features){
    colnames(features.list$dft) <- paste0('DFT', 1:ncol(features.list$dft))
  }

  if('css' %in% features){
    colnames(features.list$css) <- paste0('CSS', 1:ncol(features.list$css))
  }

  if('lps' %in% features){
    colnames(features.list$lps) <- paste0('LPS', 1:ncol(features.list$lps))
  }

  if('mfcc' %in% features){
    colnames(features.list$mfcc) <- paste0('MFCC', 1:ncol(features.list$mfcc))
  }

  # final data frame
  dat <- dplyr::bind_cols(id, features.list)

  # rounding
  if(!is.null(round.to)){
    dat[-1] <- round(dat[-1], round.to)
  }

  # replacing 0 by NA
  dat[-1][sapply(dat[-1], R.utils::isZero)] <- NA

  # total time
  t0 <- proc.time()-pt0
  cat('TOTAL TIME', t0[3], 'SECONDS\n\n')

  # return dat
  return(dat)
}
