## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
    

## Non-existent file
I just couldn't find the 'lastMiKTeXException' file/directory. I used  
`sudo find / -name lastMiKTeXException`  
`sudo find / -type d -name 'lastMiKTeXException'`  
`sudo find / -type f -name 'lastMiKTeXException`  
at linux terminal but there is no clue of this file/directory.
