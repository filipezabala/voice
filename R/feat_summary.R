#' Returns summary measures of voice::extract_features
#'
#' @param x Either a WAV file or a directory containing WAV files.
#' @param get.id Logical. Should the ID must be extracted from file name? Default: \code{FALSE}.
#' @param i ID position in file name. Default: \code{4}.
#' @export
feat_summary <- function(x, filesRange = NULL, features = 'f0',
                         extraFeatures = FALSE,
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
                         round.to = 4,
                         get.id = FALSE, i = 4){
  M <- voice::extract_features(x, filesRange = filesRange,
                               features = features,
                               extraFeatures = extraFeatures,
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
  M$file_name <- unlist(strsplit(M$file_name_ext, '.[Ww][Aa][Vv]$')) # add this functionality to extract_features!
  M <- dplyr::select(M, id_seq:file_name_ext, file_name, F0:dplyr::last_col())
  M_summ <- M %>%
    dplyr::group_by(file_name) %>%
    dplyr::summarise(tag_F0_mean = mean(F0, na.rm = TRUE), # Mean
                     tag_F0_median = median(F0, na.rm = TRUE), # Median
                     tag_F0_sd = sd(F0, na.rm = TRUE), # Standard Deviation
                     tag_F0_vc = tag_F0_sd/tag_F0_mean, # Variation Coefficient
                     tag_F0_iqr = IQR(F0, na.rm = TRUE), # InterQuartile Range
                     tag_F0_mad = mad(F0, na.rm = TRUE)) # Median Absolute Deviation
  return(M_summ)
  # M <- dplyr::left_join(M, M_summ, by = 'file_name')
  # M$spn <- voice::notes(M$F0, measure = 'spn')
  # dur <- by(ef$spn, ef$id_file, voice::duration)
  # get_note <- function(x){ as.character(x[,'note']) }
  # note <- lapply(dur, get_note)
  # nd <- lapply(dur, music::noteDistance)
  # lapply(nd, summary)
}
