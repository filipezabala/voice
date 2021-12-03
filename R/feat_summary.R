#' Returns summary measures of voice::extract_features
#'
#' @param x Either a WAV file or a directory containing WAV files.
#' @details Except for \code{x}, all the parameters are shared with \code{voice::extract_features}.
#' @export
feat_summary <- function(x, filesRange = NULL, features = 'f0',
                         gender = "u",
                         windowShift = 5,
                         numFormants = 8,
                         numcep = 12,
                         dcttype = c("t2", "t1", "t3", "t4"),
                         fbtype = c("mel", "htkmel", "fcmel", "bark"),
                         resolution = 40,
                         usecmp = FALSE,
                         mc.cores = 1,
                         full.names = TRUE,
                         recursive = FALSE,
                         check.mono = TRUE,
                         stereo2mono = TRUE,
                         overwrite = FALSE,
                         freq = 44100,
                         round.to = 4){

  M <- extract_features2(x, filesRange = filesRange,
                               features = features,
                               gender = gender,
                               windowShift = windowShift,
                               numFormants = numFormants,
                               numcep = numcep,
                               dcttype = dcttype,
                               fbtype = fbtype,
                               resolution = resolution,
                               usecmp = usecmp,
                               mc.cores = mc.cores,
                               full.names = full.names,
                               recursive = recursive,
                               check.mono = check.mono,
                               stereo2mono = stereo2mono,
                               overwrite = overwrite,
                               freq = freq,
                               round.to = round.to)

  featFull <- colnames(M[,-(1:3)])
  # if('f0' %in% features & 'formants' %in% features){
  #   moreFeat <- toupper(dplyr::setdiff(features, c('f0', 'formants')))
  #   f <- paste0('F',0:8)
  #   featFull <- c(f, moreFeat)
  #   if(extraFeatures){
  #     Df <- paste0('Df', 2:8) # Df - Formant Dispersion by Fitch (1997)
  #     Pf <- paste0('Pf', 1:8) # Pf - Formant Position by Puts, Apicella & Cárdenas (2011)
  #     Rf <- paste0('Rf', 1:8) # Rf - Formant Removal by Zabala (2021/2022)
  #     RCf <- paste0('RCf', 2:8) # RCf - Formant Cumulated Removal by Zabala (2021/2022)
  #     RPf <- paste0('RPf', 2:8) # RPf - Formant Position Removal by Zabala (2021/2022)
  #     featFull <- c(featFull, Df, Pf, Rf, RCf, RPf)
  #   }
  # }

  # Variation Coefficient function
  vc <- function(x, na.rm = TRUE){
    return(sd(x, na.rm = na.rm)/mean(x, na.rm = na.rm))
  }

  # get file_name and reorder columns
  M$file_name <- unlist(strsplit(M$file_name_ext, '.[Ww][Aa][Vv]$')) # add this functionality to extract_features!
  M <- dplyr::select(M, id_seq:file_name_ext, file_name, all_of(featFull))

  # group by file_name
  Mg <- M %>%
    dplyr::group_by(file_name)

  # Mean
  M_mean <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), mean, na.rm = TRUE)
  colnames(M_mean)[-1] <- paste0(colnames(M_mean)[-1], '_tag_mean')

  # (Sample) Standard Deviation
  M_sd <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), sd, na.rm = TRUE)
  colnames(M_sd)[-1] <- paste0(colnames(M_sd)[-1], '_tag_sd')

  # (Sample) Variation Coefficient
  M_vc <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), vc, na.rm = TRUE)
  colnames(M_vc)[-1] <- paste0(colnames(M_vc)[-1], '_tag_vc')

  # Median
  M_median <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), median, na.rm = TRUE)
  colnames(M_median)[-1] <- paste0(colnames(M_median)[-1], '_tag_median')

  # InterQuartile Range
  M_iqr <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), IQR, na.rm = TRUE)
  colnames(M_iqr)[-1] <- paste0(colnames(M_iqr)[-1], '_tag_iqr')

  # Median Absolute Deviation
  M_mad <- Mg %>%
    dplyr::summarise_at(vars(all_of(featFull)), mad, na.rm = TRUE)
  colnames(M_mad)[-1] <- paste0(colnames(M_mad)[-1], '_tag_mad')

  # left_join
  M_summ <- dplyr::left_join(M_mean, M_sd, by = 'file_name')
  M_summ <- dplyr::left_join(M_summ, M_vc, by = 'file_name')
  M_summ <- dplyr::left_join(M_summ, M_median, by = 'file_name')
  M_summ <- dplyr::left_join(M_summ, M_iqr, by = 'file_name')
  M_summ <- dplyr::left_join(M_summ, M_mad, by = 'file_name')

  return(M_summ)
}
