
#Asks user for the directory of files to be worked on

form Enter Full Path + \ 
    sentence directory C:\
endform


#Sets up Data File - erases existing file with same name
filedelete 'directory$''name$'acoustics-log.csv
header_row$ = "Filename" + tab$ + "Jitter local" + tab$ + "Jitter local absolute"  + tab$ + "Jitter rap" + tab$ + "Jitter ppq5" + tab$ + "Jitter ddp"  + tab$ + "Shimmer local"  + tab$ + "Shimmer local dB"  + tab$ + "Shimmer apq3" + tab$ + "Shimmer apq5" + tab$ + "Shimmer apq11"  + tab$ + "Shimmer dda "  + tab$ + "Mean F0 female" + tab$ + "mean SD female"  + tab$ + "min pitch female" + tab$ + "max pitch female" + tab$ + "Mean HNR" + tab$ + "SD HNR" + newline$
header_row$ > 'directory$'acoustics-log.csv


#Sets up array of files to run batch process on
Create Strings as file list...  list 'directory$'*.wav
  number_files = Get number of strings
  for j from 1 to number_files
     select Strings list
     current_token$ = Get string... 'j'
     name$ = current_token$ - ".wav"
     Read from file... 'directory$''current_token$'
     

#This part measures pitch with female parameters
  select Sound 'name$'
     To Pitch... 0.0 100 500
     meanpitchfemale = Get mean... 0 0 Hertz
     meansdfemale = Get standard deviation... 0 0 Hertz
     minpitchfemale = Get minimum... 0 0 Hertz Parabolic
     maxpitchfemale = Get maximum... 0 0 Hertz Parabolic


#This part measures jitter & shimmer
     select Sound 'name$'
     To PointProcess (periodic, cc)... 100 500
     meanlocal = Get jitter (local)... 0 0 0.0001 0.02 1.3
     meanlocalabsolute = Get jitter (local, absolute)... 0 0 0.0001 0.02 1.3
     meanrap = Get jitter (rap)... 0 0 0.0001 0.02 1.3
     meanppq5 = Get jitter (ppq5)... 0 0 0.0001 0.02 1.3
     meanddp = Get jitter (ddp)... 0 0 0.0001 0.02 1.3
    select Sound 'name$'
      plus PointProcess 'name$'
      meanlocal =  Get shimmer (local)... 0 0 0.0001 0.02 1.3 1.6
      meanlocaldb = Get shimmer (local_dB)... 0 0 0.0001 0.02 1.3 1.6
     meanapq3 = Get shimmer (apq3)... 0 0 0.0001 0.02 1.3 1.6
     meanaqpq5 = Get shimmer (apq5)... 0 0 0.0001 0.02 1.3 1.6
     meanapq11 =  Get shimmer (apq11)... 0 0 0.0001 0.02 1.3 1.6
     meandda = Get shimmer (dda)... 0 0 0.0001 0.02 1.3 1.6
       

#This part measures harmoncs to noise ratio
     select Sound 'name$'
     To Harmonicity (cc)... 0.01 60 0.1 1
     meanHNR = Get mean... 0 0
     meansdHNR = Get standard deviation... 0 0
     fileappend "'directory$'acoustics-log.csv" 'current_token$' 'tab$' 'meanlocal:4' 'tab$' 'meanlocalabsolute:4' 'tab$' 'meanrap:4' 'tab$' 'meanppq5:4' 'tab$' 'meanddp:4' 'tab$' 'meanlocal:4' 'tab$' 'meanlocaldb:4' 'tab$' 'meanapq3:4' 'tab$' 'meanaqpq5:4' 'tab$' 'meanapq11:4' 'tab$' 'meandda:4' 'tab$' 'meanpitchfemale:4' 'tab$' 'meansdfemale:4' 'tab$' 'minpitchfemale:4' 'tab$' 'maxpitchfemale:4' 'tab$' 'meanHNR:4' 'tab$' 'meansdHNR:4' 'newline$'
     select all
minus Strings list
Remove
endfor
