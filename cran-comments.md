## R CMD check results
There were no ERRORs or WARNINGs.

There was eventually (!) 1 ERROR and three 1 NOTES:

- `devtools::check(args = c('--as-cran'))` return `0 errors ✔ | 0 warnings ✔ | 0 notes ✔` in 1m 43.5s.
- `devtools::check_win_devel` and `devtools::check_win_oldrelease` return `Status: 1 NOTE`.
- Can't find the error source from `devtools::check_win_release`:
```Error(s) in re-building vignettes:
--- re-building 'voicegnette_R.Rmd' using rmarkdown
trying URL 'https://github.com/filipezabala/voiceAudios/raw/refs/heads/main/wav/doremi.wav'
Content type 'audio/wav' length 521396 bytes (509 KB)
==================================================
downloaded 509 KB
```
