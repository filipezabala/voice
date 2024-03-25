# https://cran.r-project.org/web/packages/policies.html
# CRAN-submissions@R-project.org (for submissions) or CRAN@R-project.org (for published packages)

# main file
# http://r-pkgs.had.co.nz/

# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

# packs
# sudo apt-get install libgit2-dev
# library(devtools)

# session_info
# session_info()

# remove old voice
remove.packages('voice', lib='/usr/local/lib/R/site-library')

# updating and creating manual
# devtools::document(getwd())
devtools::document('~/MEGA/MEGAsync/D_Filipe_Zabala/pacotes/voice/')

# install voice
devtools::install_github('filipezabala/voice')
# install.packages('voice', dep = T)

# # loading
# devtools::load_all()

# checking
# https://kalimu.github.io/post/checklist-for-r-package-submission-to-cran/

# sudo find / -name list.txt
unlink('/tmp/RtmpHB5Esg/voice.Rcheck/list.txt')
unlink('LICENSE')
unlink('__pycache__', recursive = TRUE)
unlink('sherlock0')
unlink('sherlock0.rttm')
unlink('sherlock0.rttm')
unlink('temp_diarization-pyannote.py')
unlink('temp_extract_f0.py')
unlink('temp_extract_formants.py')
unlink('temp_libs.py')
unlink('tempfile.rttm')
unlink('./vignettes/temp_diarization-pyannote.py')
unlink('./vignettes/temp_libs.py')
unlink('./vignettes/__pycache__', recursive = TRUE)
unlink('~/temp_diarization-pyannote.py')
unlink('~/temp_libs.py')
unlink('~/__pycache__', recursive = TRUE)
unlink('/tmp/RtmpdR6Vve/voice.Rcheck/temp_diarization-pyannote.py')
unlink('/tmp/RtmpdR6Vve/voice.Rcheck/temp_libs.py')
unlink('/tmp/RtmpdR6Vve/voice.Rcheck/__pycache__', recursive = TRUE)
unlink('/tmp/qtsingleapp-mscore-64b8-3e8-lockfile', recursive = TRUE)
unlink('/tmp/runtime-filipe', recursive = TRUE)

# sudo find / -name qtsingleapp-mscore-7531-1f5-lockfile
# sudo find / -name runtime-filipe
# sudo find / -name qtsingleapp-mscore-64b8-3e8-lockfil
# sudo find / -name temp_diarization-pyannote.py
# sudo find / -name lastMiKTeXException
# sudo find / -type d -name 'lastMiKTeXException'
# sudo find / -type f -name 'lastMiKTeXException'

nchar('Tools for Voice Analysis, Speaker Recognition and Mood Inference')

# # news.md
# devtools::install_github("Dschaykib/newsmd")
# library(newsmd)
# my_news <- news$new()
# my_news <- newsmd()
# my_news$write()

# usethis::use_build_ignore(c('draft', 'cran-comments.md'))
devtools::check(args = c('--as-cran'))
# devtools::check()
devtools::check_win_devel()
devtools::check_win_release()
devtools::check_win_oldrelease()

# send to CRAN
devtools::spell_check()
# rhub::validate_email()
devtools::check_rhub()
# devtools::check_rhub(env_vars = c(`_R_CHECK_FORCE_SUGGESTS_` = "false"))

# finally, releasing
devtools::release()



## OLD
# Run R CMD check on all downstream dependencies
dep = tools::package_dependencies(reverse = TRUE, which = 'Depends', recursive = TRUE)
deplgc = sapply(dep, is.chr0)
depT = which(!deplgc)
listFull = vector('list', length(depT))
j = 0
for(i in depT){
  j = j+1
  listFull[[j]] = dep[[i]]
  names(listFull)[[j]] = names(depT[j])
}
listUn = sort(unique(unlist(listFull)))
# tools::package_dependencies(reverse = TRUE)
# tools::check_packages_in_dir('~/Dropbox/D_Filipe_Zabala/pacotes/voice/', reverse = list())
# https://github.com/r-lib/revdepcheck
revdepcheck::revdep_check(num_workers = 4)
revdepcheck::revdep_reset()

#
# # OLD
# revdep_check(libpath = "../revdep")
# chooseCRANmirror(ind = 11)
#
# library(revdepcheck)
# path = '/Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice'
# revdep_check(path, num_workers = 4, quiet = FALSE)
# revdep_check(num_workers = 4)
# revdep_summary()                 # table of results by package
# revdep_details(".", "<package>") # full details for the specified package
# revdep_report()
#
# devtools::revdep_check()
# devtools::revdep_check_save_summary()
# devtools::revdep_check_print_problems()
# devtools::check_cran()


# https://cran.r-project.org/submit.html

devtools::install()
# sending to CRAN
devtools::spell_check()

.libPaths()

# $ R CMD check /Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice
# $ R CMD build /Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice
# $ R CMD INSTALL /Users/filipezabala/Dropbox/D_Filipe_Zabala/pacotes/voice/voice_0.0.0.9000.tar.gz

# https://stackoverflow.com/questions/14358814/error-in-r-cmd-check-packages-required-but-not-available/59894631#59894631
# https://stackoverflow.com/questions/7505547/detach-all-packages-while-working-in-r
sessionInfo()
invisible(suppressMessages(suppressWarnings(lapply(c("gsl","fBasics","stringr","stringi","Rmpfr"), require, character.only = TRUE))))
invisible(suppressMessages(suppressWarnings(lapply(names(sessionInfo()$loadedOnly), require, character.only = TRUE))))
sessionInfo()

# https://community.rstudio.com/t/r-hub-builder-there-is-no-package-called-utf8/65694
rhub::check(platform="windows-x86_64-devel",
            env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always") )

devtools::check_rhub()
devtools::release()


# 54 #' my_colors <- RColorBrewer::brewer.pal(5, 'Spectral')
# 55 #' my_colors <- grDevices::colorRampPalette(my_colors)(100)
# 61 #' ellipse::plotcorr(data_ord , col=my_colors[data_ord*50+50] , mar=c(1,1,1,1))
# 68 #' ggplot2::autoplot(pc, data = na.omit(ef2), colour = 'file_name',

# installing
update.packages(ask=F)
devtools::install_github('filipezabala/voice')

# attaching
library(voice)
?diarize
?interp_df
?interp_mc
?extract_features
?expand_model
?is_mono
find.package('voice')
packageDescription('voice')
citation('voice')


# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern = glob2rx('*.wav'), full.names = TRUE)

# minimal usage
M1 <- extract_features(path2wav, c('f0','f0_praat','fmt','fmt_praat'))
M1

?voice::tag
?feat_summary
# get path to audio file
path2wav <- list.files(system.file('extdata', package = 'wrassp'),
                       pattern <- glob2rx('*.wav'), full.names = TRUE)

# creating Extended synthetic data
E <- dplyr::tibble(subject_id = c(1,1,1,2,2,2,3,3,3),
                   wav_path = path2wav)

# minimal usage
tag(E)
feat_summary(E)

# canonical data
tag(E, groupBy = 'subject_id')

# limiting filesRange
tag(E, filesRange = 3:6)

# Several files per directory (Mac)
E <- dplyr::tibble(subject_id = c('1snoke', '2old2play', '23yipikaye'),
                   wav_path = c('/Users/fz/MEGAsync/D_Filipe_Zabala/pacotes/voiceAudios/voxforge/1snoke-20120412-hge/wav',
                                '/Users/fz/MEGAsync/D_Filipe_Zabala/pacotes/voiceAudios/voxforge/2old2play-20110606-hcn/wav',
                                '/Users/fz/MEGAsync/D_Filipe_Zabala/pacotes/voiceAudios/voxforge/23yipikaye-20100807-ujm/wav'))
voice::tag(E)
voice::feat_summary(E)

# Several files per directory (Linuxth  )
E <- dplyr::tibble(subject_id = c('1snoke', '2old2play', '23yipikaye'),
                   wav_path = c('/home/filipe/MEGAsync/pacotes/voiceAudios/voxforge/1snoke-20120412-hge/wav',
                                '/home/filipe/MEGAsync/pacotes/voiceAudios/voxforge/2old2play-20110606-hcn/wav',
                                '/home/filipe/MEGAsync/pacotes/voiceAudios/voxforge/23yipikaye-20100807-ujm/wav'))
voice::tag(E)
voice::tag(E, 'subject_id')
voice::feat_summary(E)
voice::feat_summary(E, 'subject_id')


# minimal usage
feat_summary(E)

# canonical data
feat_summary(E, 'subject_id')
