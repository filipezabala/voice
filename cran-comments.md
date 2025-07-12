## R CMD check results
There were no ERRORs or WARNINGs.

There was three `Status: 2 NOTES`:

- `devtools::check_win_devel`
- `devtools::check_win_release`
- `devtools::check_win_oldrelease`

NOTE 1: 

- 'diarization' is a current expression in the specialized literature.
- https://apps.dtic.mil/sti/pdfs/ADA303368.pdf is OK.
- Can't find out what is the CRAN URL canonical form for https://cloud.r-project.org/bin/macosx/.
- https://www.ee.columbia.edu/~dpwe/resources/matlab/rastamat/ is OK.
```
Possibly misspelled words in DESCRIPTION:
  diarization (12:32)
  
Found the following (possibly) invalid URLs:
  URL: https://apps.dtic.mil/sti/pdfs/ADA303368.pdf
    From: man/extract_features.Rd
    Status: 403
    Message: Forbidden
  URL: https://cloud.r-project.org/bin/macosx/
    From: inst/doc/voicegnette_CRAN.html
    Status: 200
    Message: OK
    CRAN URL not in canonical form
  URL: https://www.ee.columbia.edu/~dpwe/resources/matlab/rastamat/
    From: man/extract_features.Rd
    Status: 403
    Message: Forbidden
 ```

 NOTE 2: Mr. Ligges ask me to "Please omit "+ file LICENSE" and the file itself which is part of R anyway. It is only used to specify additional restrictions to the GPL such as attribution requirements."
 ```
❯ checking top-level files ... NOTE
  File
    LICENSE
  is not mentioned in the DESCRIPTION file.
  Non-standard files/directories found at top level:
    ‘CRAN-SUBMISSION’ ‘cran-comments.md’ ‘requirements.txt’
```


## `devtools::check(args = c('--as-cran'))` results
- Return `0 errors ✔ | 0 warnings ✔ | 1 note ✔` in 38.9s.
```
❯ checking top-level files ... NOTE
  File
    LICENSE
  is not mentioned in the DESCRIPTION file.
  Non-standard files/directories found at top level:
    ‘CRAN-SUBMISSION’ ‘cran-comments.md’ ‘requirements.txt’
```
