#' Extracts features from WAV or MP3 audio.
#' @description Extracts features from WAV or MP3 audio.
#' @usage \code{extract_features <- function(x,
#' features = c('f0','formants','zcr','rms','mhs',
#'              'gain','rfc,','ac','cep','dft','css',
#'              'lps','mfcc'),
#'              gender = 'u', windowShift = 5, numFormants = 8,
#'              numcep = 12, dcttype = c('t2', 't1', 't3', 't4'),
#'              fbtype = c('mel', 'htkmel', 'fcmel', 'bark'),
#'              resolution = 40, usecmp = FALSE,
#'              mc.cores = parallel::detectCores(), convert.mp3 = FALSE,
#'              dest.path = NULL, full.names = TRUE, recursive = FALSE,
#'              as.tibble = TRUE)}
#' @param \code{x} A directory containing audio file(s) in WAV or MP3 formats. If more than one directory is provided, only the first one is used.
#' @param \code{features} Vector of features to be extracted. (default: f0, formants). The following four features contain 257 columns each: \code{'cep'}, \code{'dft'}, \code{'css'} and \code{'lps'}.
#' @param \code{gender} = <code>: set gender specific parameters where <code> = \code{'f'}[emale], \code{'m'}[ale] or \code{'u'}[nknown] (default: \code{'u'}). Used by \code{wrassp::ksvF0}, \code{wrassp::forest} and \code{wrassp::mhsF0}.
#' @param \code{windowShift} = <dur>: set analysis window shift to <dur>ation in ms (default: 5.0). Used by \code{wrassp::ksvF0}, \code{wrassp::forest}, \code{wrassp::mhsF0}, \code{wrassp::zcrana}, \code{wrassp::rfcana}, \code{wrassp::acfana}, \code{wrassp::cepstrum}, \code{wrassp::dftSpectrum}, \code{wrassp::cssSpectrum} and \code{wrassp::lpsSpectrum}.
#' @param \code{numFormants} = <num>: <num>ber of formants (default: 8). Used by \code{wrassp::forest}.
#' @param \code{numcep} Number of Mel-frequency cepstral coefficients (cepstra) to return (default: 12). Used by \code{tuneR::melfcc}.
#' @param \code{dcttype} Type of DCT used. \code{'t1'} or \code{'t2'}, \code{'t3'} for HTK \code{'t4'} for feacalc (default = \code{'t2'}). Used by \code{tuneR::melfcc}.
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
#' pattern = glob2rx("*.wav"), full.names = TRUE)
#'
#'# getting all the 1092 features
#' xx <- extract_features(dirname(path2wav))
#' ncol(xx)
#' xx
#'
#' # dropping 'cep','dft','css' and 'lps' (4*257 = 1028 columns)
#' xx2 <- extract_features(dirname(path2wav),
#'  features = c('f0','formants','zcr','rms','mhs',
#'  'gain','rfc','ac','mfcc'))
#'  ncol(xx2)
#'  xx2
#' @export
extract_features <- function(x,
                             features = c('f0','formants','zcr','rms','mhs',
                                          'gain','rfc','ac','cep','dft','css',
                                          'lps','mfcc'),
                             gender = 'u', windowShift = 5, numFormants = 8,
                             numcep = 12, dcttype = c('t2', 't1', 't3', 't4'),
                             fbtype = c('mel', 'htkmel', 'fcmel', 'bark'),
                             resolution = 40, usecmp = FALSE,
                             mc.cores = parallel::detectCores(), convert.mp3 = FALSE,
                             dest.path = NULL, full.names = TRUE, recursive = FALSE,
                             as.tibble = TRUE){

  # time processing
  pt0 <- proc.time()

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

    # list of features
    nFe <- length(features)
    features.list.temp <- vector('list', nFe-2)
    features.list <- vector('list', nFe)
    i.temp <- 0
    i <- 0

    # 1. F0 analysis of the signal
    if('f0' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::ksvF0,
                                                         gender = gender, toFile = F,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'f0'
      names(features.list)[i] <- 'f0'
      features.list[[i]] <- dplyr::tibble()
      f0_le <- vector(length = nWav)
    }

    # 2. Formant estimation (F1:F8)
    if('formants' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::forest,
                                                         gender = gender, toFile = F,
                                                         windowShift = windowShift,
                                                         numFormants = numFormants,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'formants'
      names(features.list)[i] <- 'formants'
      features.list[[i]] <- dplyr::tibble()
      fo_le <- vector(length = nWav)
    }

    # 3. Analysis of the averages of the short-term positive and negative (Z)ero-(C)rossing (R)ates
    if('zcr' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::zcrana,
                                                         toFile = F,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'zcr'
      names(features.list)[i] <- 'zcr'
      features.list[[i]] <- dplyr::tibble()
      zcr_le <- vector(length = nWav)
    }

    # 4. Pitch analysis of the speech signal using Michel’s (M)odified (H)armonic (S)ieve algorithm
    if('mhs' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::mhsF0,
                                                         toFile = F, gender = gender,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'mhs'
      names(features.list)[i] <- 'mhs'
      features.list[[i]] <- dplyr::tibble()
      mhs_le <- vector(length = nWav)
    }

    # 5. (L)inear (P)rediction (A)nalysis [rms, gain, rfc]
    if('rms' %in% features | 'gain' %in% features | 'rfc' %in% features){
      i.temp <- i.temp+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::rfcana,
                                                         toFile = F,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'lpa'

      if('rms' %in% features){
        i <- i+1
        names(features.list)[i] <- 'rms'
        features.list[[i]] <- dplyr::tibble()
        rms_le <- vector(length = nWav)
      }

      if('gain' %in% features){
        i <- i+1
        names(features.list)[i] <- 'gain'
        features.list[[i]] <- dplyr::tibble()
        gain_le <- vector(length = nWav)
      }

      if('rfc' %in% features){
        i <- i+1
        names(features.list)[i] <- 'rfc'
        features.list[[i]] <- dplyr::tibble()
        rfc_le <- vector(length = nWav)
      }
    }

    # 6. Analysis of short-term (A)uto(C)orrelation function
    if('ac' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::acfana,
                                                         toFile = F,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'ac'
      names(features.list)[i] <- 'ac'
      features.list[[i]] <- dplyr::tibble()
      ac_le <- vector(length = nWav)
    }

    # 7. Short-term (CEP)stral analysis
    if('cep' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::cepstrum,
                                                         toFile = F,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'cep'
      names(features.list)[i] <- 'cep'
      features.list[[i]] <- dplyr::tibble()
      cep_le <- vector(length = nWav)
    }

    # 8. Short-term (DFT) spectral analysis
    if('dft' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::dftSpectrum,
                                                         toFile = F, resolution = resolution,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'dft'
      names(features.list)[i] <- 'dft'
      features.list[[i]] <- dplyr::tibble()
      dft_le <- vector(length = nWav)
    }

    # 9. (C)epstral (S)moothed version of dft(S)pectrum
    if('css' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::cssSpectrum,
                                                         toFile = F, resolution = resolution,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'css'
      names(features.list)[i] <- 'css'
      features.list[[i]] <- dplyr::tibble()
      css_le <- vector(length = nWav)
    }

    # 10. (L)inear (P)redictive (S)moothed version of dftSpectrum
    if('lps' %in% features){
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(wavFiles, wrassp::lpsSpectrum,
                                                         toFile = F, resolution = resolution,
                                                         windowShift = windowShift,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'lps'
      names(features.list)[i] <- 'lps'
      features.list[[i]] <- dplyr::tibble()
      lps_le <- vector(length = nWav)
    }

    # 11. Mel-Frequency Cepstral Coefficients (MFCC)
    if('mfcc' %in% features){
      rWave <- parallel::mclapply(wavFiles, tuneR::readWave, mc.cores = mc.cores)
      i.temp <- i.temp+1
      i <- i+1
      features.list.temp[[i.temp]] <- parallel::mclapply(rWave, tuneR::melfcc,
                                                         wintime = windowShift/1000,
                                                         hoptime = windowShift/1000,
                                                         dcttype = dcttype,
                                                         numcep = numcep,
                                                         fbtype = fbtype,
                                                         usecmp = usecmp,
                                                         mc.cores = mc.cores)
      names(features.list.temp)[i.temp] <- 'mfcc'
      names(features.list)[i] <- 'mfcc'
      features.list[[i]] <- dplyr::tibble()
      mf_le <- unlist(lapply(features.list.temp[[i.temp]], nrow))
    }


    # concatenating
    for(j in 1:nWav){ # upgrade: use bind_rows

      # time processing
      pt1 <- proc.time()

      if('f0' %in% features){
        f0_temp <- as.matrix(features.list.temp$f0[[j]]$F0[1:mf_le[j]], ncol = 1)
        features.list$f0 <- rbind(features.list$f0, f0_temp)
        f0_le[j] <- nrow(features.list.temp$f0[[j]]$F0)
      }

      if('formants' %in% features){
        fo_temp <- as.matrix(features.list.temp$fo[[j]]$fm[1:mf_le[j],], ncol = numFormants)
        features.list$formants <- rbind(features.list$formants, fo_temp)
        fo_le[j] <- nrow(features.list.temp$fo[[j]]$fm)
      }

      if('zcr' %in% features){
        zcr_temp <- as.matrix(features.list.temp$zcr[[j]]$zcr[1:mf_le[j],], ncol = 1)
        features.list$zcr <- rbind(features.list$zcr, zcr_temp)
        zcr_le[j] <- nrow(features.list.temp$zcr[[j]]$zcr)
      }

      if('mhs' %in% features){
        mhs_temp <- as.matrix(features.list.temp$mhs[[j]]$pitch[1:mf_le[j],], ncol = 1)
        features.list$mhs <- rbind(features.list$mhs, mhs_temp)
        mhs_le[j] <- nrow(features.list.temp$mhs[[j]]$pitch)
      }

      if('rms' %in% features){
        rms_temp <- as.matrix(features.list.temp$lpa[[j]]$rms[1:mf_le[j],], ncol = 1)
        features.list$rms <- rbind(features.list$rms, rms_temp)
        rms_le[j] <- nrow(features.list.temp$lpa[[j]]$rms)
      }

      if('gain' %in% features){
        gain_temp <- as.matrix(features.list.temp$lpa[[j]]$gain[1:mf_le[j],], ncol = 1)
        features.list$gain <- rbind(features.list$gain, gain_temp)
        gain_le[j] <- nrow(features.list.temp$lpa[[j]]$gain)
      }

      if('rfc' %in% features){
        rfc_temp <- as.matrix(features.list.temp$lpa[[j]]$rfc[1:mf_le[j],], ncol = 19)
        features.list$rfc <- rbind(features.list$rfc, rfc_temp)
        rfc_le[j] <- nrow(features.list.temp$lpa[[j]]$rfc)
      }

      if('ac' %in% features){
        ac_temp <- as.matrix(features.list.temp$ac[[j]]$acf[1:mf_le[j],], ncol = 20)
        features.list$ac <- rbind(features.list$ac, ac_temp)
        ac_le[j] <- nrow(features.list.temp$ac[[j]]$acf)
      }

      if('cep' %in% features){
        cep_temp <- as.matrix(features.list.temp$cep[[j]]$cep[1:mf_le[j],], ncol = 257)
        features.list$cep <- rbind(features.list$cep, cep_temp)
        cep_le[j] <- nrow(features.list.temp$cep[[j]]$cep)
      }

      if('dft' %in% features){
        dft_temp <- as.matrix(features.list.temp$dft[[j]]$dft[1:mf_le[j],], ncol = 257)
        features.list$dft <- rbind(features.list$dft, dft_temp)
        dft_le[j] <- nrow(features.list.temp$dft[[j]]$dft)
      }

      if('css' %in% features){
        css_temp <- as.matrix(features.list.temp$css[[j]]$css[1:mf_le[j],], ncol = 257)
        features.list$css <- rbind(features.list$css, css_temp)
        css_le[j] <- nrow(features.list.temp$css[[j]]$css)
      }

      if('lps' %in% features){
        lps_temp <- as.matrix(features.list.temp$lps[[j]]$lps[1:mf_le[j],], ncol = 257)
        features.list$lps <- rbind(features.list$lps, lps_temp)
        lps_le[j] <- nrow(features.list.temp$lps[[j]]$lps)
      }

      if('mfcc' %in% features){
        features.list$mfcc <- rbind(features.list$mfcc, features.list.temp$mfcc[[j]])
      }

      cat('PROGRESS', paste0(round(j/nWav*100,2),'%'), '\n')
      t1 <- proc.time()-pt1
      cat('FILE', j, 'OF', nWav, '|', t1[3], 'SECONDS\n\n')
    }

    # id, using smaller length: mf_le
    id <- tibble::enframe(rep(basename(wavFiles), mf_le), value = 'audio', name = NULL)

    # colnames
    if('f0' %in% features){
      colnames(features.list$f0) <- 'F0'
      }

    if('formants' %in% features){
      colnames(features.list$formants) <- paste0('F', 1:numFormants)
      }

    if('zcr' %in% features){
      colnames(features.list$zcr) <- paste0('ZCR')
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
      colnames(features.list$rfc) <- paste0('RFC', 1:19)
    }

    if('ac' %in% features){
      colnames(features.list$ac) <- paste0('ACF', 1:20)
    }

    if('cep' %in% features){
      colnames(features.list$cep) <- paste0('CEP', 1:257)
    }

    if('dft' %in% features){
      colnames(features.list$dft) <- paste0('DFT', 1:257)
    }

    if('css' %in% features){
      colnames(features.list$css) <- paste0('CSS', 1:257)
    }

    if('lps' %in% features){
      colnames(features.list$lps) <- paste0('LPS', 1:257)
    }

    if('mfcc' %in% features){
      colnames(features.list$mfcc) <- paste0('MFCC', 1:numcep)
    }

    # final data frame
    df <- dplyr::bind_cols(id, features.list)

    # total time
    t0 <- proc.time()-pt0
    cat('TOTAL TIME', t0[3], 'SECONDS\n\n')

    # return df
    if(as.tibble){
       return(as_tibble(df))
    } else{return(df)}
}
