## R CMD check results
There were no ERRORs or WARNINGs.

There was 2 NOTES:


❯ checking CRAN incoming feasibility ... [17s] NOTE
  Maintainer: 'Zabala Filipe J. <filipezabala@gmail.com>'
  
  Days since last update: 1
  
## Prof Brian Ripley's sent an email:
"Please see the problems shown on
<https://cran.r-project.org/web/checks/check_results_voice.html>.
Please correct before 2023-05-03 to safely retain your package on CRAN."

So I dropped the section 3 from `voicegnette_R`.
  

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'qtsingleapp-mscore-7531-1f5-lockfil'
    'lastMiKTeXException'
    

## Non-existent file
I just couldn't find the 'qtsingleapp-mscore-7531-1f5-lockfil'/'lastMiKTeXException' file/directory. I used  
`sudo find / -name qtsingleapp-mscore-7531-1f5-lockfil/'lastMiKTeXException'`  
`sudo find / -type d -name 'qtsingleapp-mscore-7531-1f5-lockfil/'lastMiKTeXException''`  
`sudo find / -type f -name 'qtsingleapp-mscore-7531-1f5-lockfil/'lastMiKTeXException'`  
at linux terminal but there is no clue of this file/directory.
