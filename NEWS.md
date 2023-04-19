## version 0.4.17

---

### NEWS.md setup

- Version 0.5.0 2022-MM-DD
. Add tag `$feature_tag_n`.
. Features ordered by the listed order in `features` argument.
. Add time duration `tdur` as a column at voice::tag function return.
. Solve `acf` feature extraction at voice::extract_features.
  . Error in `dplyr::bind_cols()`:
  ! Can't recycle `..1` (size 2396) to match `..4` (size 0).
  Run `rlang::last_error()` to see where the error occurred.
. Solve @ voice::diarize.R 
  FileNotFoundError: [Errno 2] No such file or directory: '/home/fz/.cache/torch/hub/pyannote_pyannote-audio_master/hubconf.py'
. Change message @ voice::tag: 
  FROM 'Warning: no non-missing arguments to min; returning InfError in features.list.temp$f0[[j]] : subscript out of bounds' 
  TO 'File does not exist!'



- Version 0.4.21 2023-04-20
. Dropped the section 3 from `voicegnette_R` after Prof Brian Ripley's email:
Dear maintainer,
Please see the problems shown on
<https://cran.r-project.org/web/checks/check_results_voice.html>.
Please correct before 2023-05-03 to safely retain your package on CRAN.
The CRAN Team

- Version 0.4.20 2023-04-20
. `filesRange` and `features` switched. Now `filesRange` is in the 3rd and `features` in the 2nd positions in the argument vector. This change impacts the examples of `interp_df.R`, `interp_mc.R`, `smooth_df.R`, `tag.R`.
. `f0_praat`, ..., `f8_praat` implemented in `extract_features.R`.
. `pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8'` added as argument in `extract_features.R`.
. `formants` set to `fmt` in `extract_features.R`.
. `windowShift` set to `10` as default in `extract_features.R` and `feat_summary.R`.
. `extract_features_py.R` deprecated.
. `voice::conv` set to `voice::interp` at lines 45 and 50 of `interp_mc.R`.
. Functions `get_` removed from `spltw.R`.
. More information given in `voice::diarize` documentation.


- Version 0.4.19 2023-04-06
. All documentation verified.
. `voice::conv` set to `voice::interp`.
. `voice::conv_mc` set to `voice::interp_mc`.
. `voice::conv_df` set to `voice::interp_df`.
. `gender` set to `sex` as argument of `voice::extract_features`.
. `gender` set to `sex` as argument of `voice::feat_summary`.
. `gender` set to `sex` as argument of `voice::tag`.


- Version 0.4.18 2023-04-05
. Added `pycall` argument to `voice::extract_features_py`.
. References updated in `voice::extract_features`.
. References updated in `voice::extract_features_py`.
. `F0` column inferred via `voice::extract_features_py` set to `f0_praat`. Line 39 of extract_f0.py, (`df_f0_long['f0_praat']`) and line 83 of extract_features_py.R (`dplyr::select(id, file_name, interval, F0) %>%`).
. `1`,  column inferred via `voice::extract_features_py` set to `f0_praat`.
. Column `mhs` set to `f0_mhs` in `voice::extract_features`.
. Lean call to `voice::extract_features`:
  `    features = c('f0', 'formants',   # Pitch and formants`
  `                 'df', 'pf',         # Formant dispersion and position`
  `                 'rf', 'rpf', 'rcf', # Formant removals`
  `                 'rfc',              # (R)e(F)lection (C)oefficients`
  `                 'mfcc'),            # (M)el (Frequency (C)epstral (C)oefficients`
. RPf - Formant Position Removal by Zabala (2023) disentangled from Pf by Puts et al (2012) in `voice::extract_features`.
. `voice::diarize` calls directly `pyannote.audio` via `reticulate` using a token. The download and call of `libs.py` and `diarization-pyannote.py` is no longer needed.
. Reconnect to Github after 5 months.


- Version 0.4.17 2023-03-14
. voice now depends of R (>= 4.0.0), not R (>= 4.1.0) in order to allow Kaggle installation.
. Deprecated `poetry` (sent to `draft/poetry.R`), created `R/diarize` instead.
. Deprecated `data/id_path.rda` and `man/id_path.Rd` (sent to `draft/id_path.rda` and `draft/id_path.Rd`), created `/data/mozilla_id_path.rda` and `man/mozilla_id_path.Rd` instead.
. Updated .Rbuildignore:
  ^.*\.Rproj$
  ^\.Rproj\.user$
  ^cran-comments\.md$
  ^CRAN-SUBMISSION$
  ^requirements.txt$
  ^draft$
  ^revdep$
. rstudio.com became posit.co.
. Monterey became Ventura.
. `voice::diarize` exported to NAMESPACE.



- Version 0.4.16 2022-09-14
. Allow R/conv_df.R to use unitary `features` argument.


- Version 0.4.15 2022-09-07
. Removed duplicated 'must' from `autoDir` parameter documentation at poetry.R
. Updated vignettes/voicegnette_R.Rmd.
. Set `verbose = FALSE`:
  - R/feat_summary.R
  - R/tag.R
. Set `to.data.frame = to.data.frame` to `cn.li` call @ R/conv_df.R.


- Version 0.4.14 2022-09-02
As suggested by Benjamin Altmann: 
. Added `@return` to R/write_list.R. This implies adding a `\value` field to the corresponding .Rd file.
 

- Version 0.4.12
As suggested by Benjamin Altmann:  
. Reduced the length of the title to 64 characters, less than 65. In DESCRIPTION:  
`nchar('Tools for Voice Analysis, Speaker Recognition and Mood Inference')`
. Package names, software names and API names written in single quotes in title and description.
 - enrich_rttm.R: '\code{voice::read_rttm}'
 - extract_features_py.R: 'Python's' 'Parselmouth'
 - feat_summary.R: 'voice::extract_features'
 - poetry.R: 'Python's' 'pyannote-audio'
 - DESCRIPTION: 'R' and 'Python' 
. Reference "Zabala, F.J. (2022) to appear in..." removed from
 - extract_features.R
 - feat_summary.R
 - tag.R
. Added `@return` to the following .R files regarding exported methods and explaining the functions results in the documentation. This implies adding a `\value` field to the corresponding .Rd files.
 - R/audio_time.R
 - R/enrich_rttm.R
 - R/extract_features.R
 - R/extract_features_py.R
 - R/feat_summary.R
 - R/get_bit.R
 - R/get_dur.R
 - R/get_left.R
 - R/get_right.R
 - R/get_samp.rate.R
 - R/get_tbeg.R
 - R/get_tdur.R
 - R/is_mono.R
 - R/notes.R
 - R/poetry.R
 - R/read_rttm.R
 - R/splitw.R
 - R/tag.R
. Functions moved to draft directory:
 - draft/chords.R
 - draft/has_audio.R
 - draft/id_file.R
 - draft/is_can.R
 - draft/is_ext.R
 - draft/memory.R
 - draft/na_filter.R
 - draft/notes_summary.R
 - draft/plot_note.R
 - draft/plot_q.R
 - draft/rowProp.R
 - draft/rp.R
 - draft/spoken_time.R
. Functions in which `\dontrun` was replaced with or simply added `\donttest`:
 - R/conv_df.R
 - R/conv_mc.R
 - R/enrich_rttm.R
. In order to easily suppress information messages to the console, argument 'verbose' was set to \code{FALSE} as default @ R/extract_features.R .
. tempdir() used @:
 - R/enrich_rttm.R
 - R/get_tbeg.R
 - R/get_tdur.R
 - R/poetry.R
 - R/read_rttm.R
 - R/splitw.R
. `\url` added to references at
 - R/enrich_rttm.R
 - R/notes_freq.R
 - R/notes.R
 - R/read_rttm.R


- Version 0.4.11
2022-08-28
. In order to reduce the examples running time:
  - The following variables were omitted from conv_df.R example: 'zcr','mhs','rms','gain','rfc','ac','cep','dft','css','lps','mfcc'.
  - `\dontrun` added to conv_mc.R.
  - `\dontrun` added to na_filter.R.


- Version 0.4.10
2022-08-28
. "You also have to remove the licences file which is part of R anyway. Best, Uwe Ligges". 
License file removed by `unlink('LICENSE')` command.
. License set to the original 'GPL-3' (instead of 'MIT + file LICENSE', 'MIT' or 'GPL-3 + file LICENSE') @ DESCRIPTION file. 


- Version 0.4.9
2022-08-26
. License set to 'MIT + file LICENSE' (instead of either 'MIT', 'GPL-3' or 'GPL-3 + file LICENSE') @ DESCRIPTION file. 


- Version 0.4.8
2022-08-26
. License set to 'MIT' (instead of either 'GPL-3' or 'GPL-3 + file LICENSE') @ DESCRIPTION file. 


- Version 0.4.7
2022-08-26
. License set to 'GPL-3' (instead of 'GPL-3 + file LICENSE') @ DESCRIPTION file. 
As I remove it, a new note was presented:  
'File LICENSE is not mentioned in the DESCRIPTION file.'


- Version 0.4.6
2022-08-25
. Now depends: R (>= 4.1.0) in order to install on Windows.


- Version 0.4.5
2022-08-24
. Following Uwe Ligges' list.
. URL: https://www.apple.com/macos/big-sur/ moved to https://www.apple.com/macos/monterey/ @ README.md.
. Using fully specified URLs starting with the protocol for https://www.xquartz.org/ @ README.md.
. Changed http --> https for https://ffmpeg.org/ and https://www.fon.hum.uva.nl/praat/ @ README.md. Note http://filipezabala.com/ and http://www.rob-mcculloch.org/ are non-secure protocols.
. The canonical URL of the CRAN page was updated for https://cran.r-project.org/package=wrassp, https://cran.r-project.org/package=tuneR, https://cran.r-project.org/package=seewave and https://cran.r-project.org/package=gm.
. Can't find where to omit "+ file LICENSE", the DESCRIPTION file requires it.


- Version 0.4.4
2022-08-23
. The `list.txt` file was generated by `write_list.R` function. `\dontrun` environment was applied to solve the problem at `devtools::check`.


- Version 0.4.3
2022-07-18
. Replaced \url by \doi at 10.1121/1.421048 and 10.1098/rspb.2011.0829 @ extract_features.R.
. Where is list.txt?????


- Version 0.4.2
2022-07-18
. Removed “≈” U+2248 Almost Equal
. Adjusted Maintainer and Authors@R (Zabala Filipe J.):
  Maintainer: 'Zabala Filipe J. <filipezabala@gmail.com>'
  Authors@R:  'Zabala Filipe J. <filipezabala@gmail.com>'
. Where is list.txt?????


- Version 0.4.1
2022-07-18
. Many improvements after devtools::release().
. Where is list.txt?????


- Version 0.4.0
2022-07-17
. Many improvements after devtools::check().
. Where is list.txt?????


- Version 0.3.22
2022-07-15
. Update documentation @ extract_features.R.


- Version 0.3.21
2022-06-10
. Lost changes.


- Version 0.3.20
2022-05-30
. Corrected verbose = TRUE @ tag.R and @ feat_summary.R.


- Version 0.3.19
2022-05-30
. Added @ voice::extract_features in line 22: #' @param verbose Logical. Should the running status be showed?
. Verbose also added to feat_summary.R and tag.R.
. feat_summary2 set to feat_summary in line 31 @ feat_summary.R.

- Version 0.3.18
2022-05-23
. Added dplyr::tibble in line 92 @ feat_summary.R.


- Version 0.3.17
2022-05-22
. Solved summarizing problem when wav_path was a directory (and not a file name) @ feat_summary.R.


- Version 0.3.16
2022-05-22
. Lost changes.


- Version 0.3.15
2022-05-21
. Updated feat_summary.R normalizing dirnames @ Media and @ Extended (full path)
. Added extdata directory.


- Version 0.3.14
2022-05-07
. Lost changes.


- Version 0.3.13
2022-MM-DD
. Set id_path.Rda to mozilla_id_path.Rda


- Version 0.3.12
2022-02-13
. Removed toLowerGroupBy @ feat_summary.R and tag.R.


- Version 0.3.11
2022-02-11
. Set check.mono and stereo2mono to FALSE @ extract_features.R, feat_summary.R and tag.R.
. Added x <- dplyr::as_tibble(x) @ feat_summary.R.


- Version 0.3.10
2022-02-11
. Set wavFiles <- do.call(rbind, wavFiles) to  wavFiles <- do.call(rbind, as.list(unlist(wavFiles))) @ extract_features.R.

- Version 0.3.9
2022-02-10
. Tidy up tag.R documentation, removing @param subj.id, @param media.id and @param subj.id.simplify.
. Added @param wavPath in feat_summary.R and tag.R documentation.
. Added @param wavPathName in feat_summary.R and tag.R documentation.
. Normalized dirnames @ feat_summary.R


- Version 0.3.8
2022-02-09
. dplyr::vars @ feat_summary.R


- Version 0.3.7
2022-02-09
. Make Media and Extended datasets consistent in documentation.
. extract_features.R 
  . Drop 'file_name_ext' column @ output.
  . Add 'wavPath' as the third column @ extract_features.R output. 
  . Admit directories or files in the main argument x.
. feat_summary.R
  . path > wav_path, id_seq > slice_seq, id_seq_file > slice_seq_file
  . Added 'groupBy' argument
  . Check tag.R applied on Canonical data
. tag.R
  . Create examples
  . Remove arguments subj.id, media.id and subj.id.simplify
  . Disable audio_time


- Version 0.3.6
2022-01-02
. Added @references Ardila et al (2019).
. Added voice::plot_q.R, a plot_q[uality] function.
. Imports magrittr at DESCRIPTION file.


- Version 0.3.5
2022-01-02
. Removed voice_ex1.rda, 7.5MB.
. Deleted NAMESPACE.


- Version 0.3.4
2022-01-01
. id_path <- E %>% 
  select(client_id:path)
 save(id_path, file = '~/Dropbox/D_Filipe_Zabala/pacotes/voice/data/id_path.rda',
     compress = 'xz')
 voice::id_path


- Version 0.3.3
2022-01-01
. Eid <- E %>% 
  select(client_id:path)
 save(Eid, file = '~/Dropbox/D_Filipe_Zabala/pacotes/voice/data/id_path.rda',
     compress = TRUE)
 data(voice::id_path)


- Version 0.3.2
2021-12-15
. Harmonize voice::extract_features.R and voice::tag.R arguments.


- Version 0.3.1
2021-12-03
. extract_features2 set to voice::extract_features @ line 24 @ feat_summary.R.


- Version 0.3.0
2021-12-03
. Set argument 'directory' to 'x' @ extract_features.R.
. Set features colnames to lowercase @ extract_features.R.
. Added df, pf, rf, rcf and rpf as argument of 'features' @ extract_features.R.
. Deprecate argument 'extraFeatures' @ extract_features.R and, feat_summary.R and tag.R.
. Contemplate `ZCR`, `RFC`, `AC`, and `MFCC` (numbers) @ feat_summary.R.


- Version 0.2.11
2021-11-27
. Added dplyr::bind_cols to line 602 @ extract_features.R.


- Version 0.2.10
2021-11-27
. RCf <- paste0('RCf', 2:8)
. RPf <- paste0('RPf', 2:8)


- Version 0.2.9
2021-11-27
. Formant Dispersion Removal (RDf) set to Formant Cumulated Removal (RCf), line 53 @ feat_summary.R
. dat$Dfn <- dat$Fn-dat$F1 set to dat$Dfn <- (dat$Fn-dat$F1)/(n-1) @ Df - Formant Dispersion by Fitch (1997) @ extract_features.


- Version 0.2.8
2021-11-27
. Formant Dispersion Removal (RDf) set to Formant Cumulated Removal (RCf).
. RCf set from i=1,...,8 to i=2,...,8.


- Version 0.2.7
2021-11-10
. Added suppressMessages to line 61 @ smooth_df.R.
. Summary generalized to all features obtained from voice::extract_features @ voice::feat_summary.


- Version 0.2.6
2021-11-07
. Added 'rule = 2' to line 52 @ conv.R.


- Version 0.2.5
2021-10-25
. Added voice::audio_time to voice::tag.
. New tag order @ voice::feat_summary: mean, sd, vc, median, iqr, mad.


- Version 0.2.4
2021-10-14
. Added tag_F0_iqr = IQR(F0, na.rm = TRUE) @ feat_summary.R.
. Added tag_F0_mad = mad(F0, na.rm = TRUE) @ feat_summary.R.


- Version 0.2.3
2021-10-13
. Set x[,subj.id] <- as.character(cumsum(!duplicated(x[,subj.id]))) @ tag.R.


- Version 0.2.2
2021-10-13
. Added parameter subj.id.simplify and all voice::extract_features parameters @ tag.R.


- Version 0.2.1
2021-10-13
. tag.R incorporates parameter mc.cores = 1 and dropped i = 4.
. set tag.R from feat_summary2 to feat_summary at line 26.
. feat_summary.R running voice::extract_features instead of extract_features.
. feat_summary.R return(M_summ) instead of return(M).


- Version 0.2.0
2021-10-13
. Added has_audio.R.
. Added audio_time.R.
. Added spoken_time.R
. Added feat_summary.R
. Added tag.R.


- Version 0.1.1
2021-09-27
. audio_id.R set to id_file.R. audio_id(x, i = 5, drop_fn = FALSE) set to id_file(x, col = NULL, pattern = '[_.]', i = 5, drop_col = FALSE)
. id set to id_seq, id_file set to id_seq_file @ extract_features.R.


- Version 0.1.0
2021-09-26
. extract_features creates a general id and an id_file, counting by file.
. 'formant nested removal' (RNf) set to 'formant dispersion removal' (RDf) by Zabala (2021/2022) @ extract_features.R and @ data.R.
. Removed person("Salum Jr.", "Giovanni A.", email = "gsalumjr@gmail.com", role = "aut").
. splitw must show the elapsed time
. drop_fn = TRUE set to drop_fn = FALSE


- Version 0.0.0.9047
2021-09-21
. audio_id.R function created.
. Exported voice_ex1.rda and data.R.
. toFile = F set to toFile = FALSE @ extract_features.R.
. features.list[[i]] <- dplyr::tibble() set to lapply(features.list, dplyr::tibble) @ extract_features.R.
. Added 'formant dispersion' (Df) by Fitch (1997) (doi:10.1121/1.421048)
. Added 'formant position' (Pf) by Puts, Apicella & Cárdenas (2011) (https://doi.org/10.1098/rspb.2011.0829)
. Added 'formant removal' (Rf) by Zabala (2021/2022) @ extract_features.R.
. Added 'formant nested removal' (RNf) by Zabala (2021/2022) @ extract_features.R.
. Added 'formant position removal' (RPf) by Zabala (2021/2022) @ extract_features.R.


- Version 0.0.0.9046
2021-09-15
. Added .name_repair = 'unique' to tibble::as_tibble @ smooth_df.R.
This solved the Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if `.name_repair` is omitted as of tibble 2.0.0. Using compatibility `.name_repair`.


- Version 0.0.0.9045
2021-09-15
. names(rttm) <- basename(rttmFiles), or file/base names inserted as names in list @ read_rttm.R.
. Added columns ~black and ~Black to notes_freq.R.
. Added method == 'black' and method == 'Black' @ notes.R.
. Added distance <- diff(freq) @ notes.R.
. method set to measure @ notes.R.
. frequency set to freq @ notes_freq.R.
. New col order @ notes_freq.R: freq, spn.lo, spn.hi, spn, midi, black, Black, wavelength
. as_tibble set to tibble::as_tibble @ smooth_df.R. 
. xs_li set to snum_li @ smooth_df.R.
. xs_df set to snum_df @ smooth_df.R.
. xs_final set to xs @ smooth_df.R.
. Ordered Imports: dplyr, e1071, ellipse, ggfortify, ggplot2, R.utils, RColorBrewer, reticulate, seewave, tibble, tidyr, tuneR, VIM, wrassp, zoo


- Version 0.0.0.9044
2021-09-12
. Parameters fromWav, fromRttm admits either file or directory @ splitw.R.


- Version 0.0.0.9043
2021-09-12
. Added parameter as.tibble = TRUE @ enrich_rttm.R.


- Version 0.0.0.9042
2021-09-12
. Changed column name from 'id.split' to 'id_split @ enrich_rttm.R.
. is.num <- unlist(lapply(x, class)) == 'numeric' changed to is.num <- sapply(x, class) %in% c('integer', 'numeric') @ conv_df.
. Added smooth_df.R.
. Drop by.filter parameter @ conv_df.R.
. id and colnum shifted @ conv_df.R documentation.
. Added parameter as.tibble = TRUE @ enrich_rttm.R.


- Version 0.0.0.9041
2021-09-10
. Changed mc.cores = parallel::detectCores() to mc.cores = 1 @ conv_df.R, conv_mc.R, extract_features.R.
. Parameter silence.gap set from 0.4 to 0.5 (universal standard) @ splitw.R, enrich_rttm.R.
. Changed column name from 'id.min.time' to 'id.split' @ enrich_rttm.R.


- Version 0.0.0.17
. Solved the recursive issue in diarization-pyannote.py (by Sola):

import os
import re

file_list = []
for root, dirs, files in os.walk('./'):
    file_list = [f for f in files if re.findall(r'[.]wav', f, re.IGNORECASE)]
    break

print(file_list)

 . os.listdir?
 . os.walk(pathfrom, level=1)?
 . os.walk(pathfrom, recursive = FALSE)?
 . https://stackoverflow.com/questions/229186/os-walk-without-digging-into-directories-below


- Version 0.0.0.1
2018-11-21 08:30:00 GMT-3

