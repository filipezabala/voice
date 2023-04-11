import os
import sys
import numpy
import pandas
import parselmouth  # pip3 install praat-parselmouth
from parselmouth.praat import call

# setting options
pandas.set_option('display.max_rows', None)
pandas.set_option('display.max_columns', None)
pandas.set_option('display.width', None)
pandas.set_option('display.max_colwidth', None)
dfs = []

# listing directory files
dirlist = sorted(os.listdir(sys.argv[1]))
n_dir = len(dirlist)

# filtering by fileRange
if(sys.argv[3] != '0'):
  fullRange = numpy.arange(1, n_dir+1, 1)
  filesRange = numpy.arange(int(sys.argv[3]), int(sys.argv[4])+1, 1)
  filesRange = set(fullRange).intersection(filesRange)
  start = min(filesRange)
  end = max(filesRange)
  dirlist = dirlist[start-1:end]

# for file in os.listdir('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/'):
for file in dirlist:
  if file.endswith('.wav'):
    # file_list = os.path.join('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/', file)
    file_list = os.path.join(sys.argv[1], file)
    snd = parselmouth.Sound(file_list)
    max_formants = 8
    formant = snd.to_formant_burg(time_step = float(sys.argv[2]), max_number_of_formants = max_formants)
    n_formants = numpy.arange(1, max_formants+1, 1)
    interval = numpy.arange(formant.start_time, formant.end_time, float(sys.argv[2]))
    n_interval = len(interval)
    formant_values = numpy.zeros((n_interval, max_formants))
    
    df_formants_long = pandas.DataFrame(data=[[n, i] for n in n_formants for i in interval], columns=['formant','interval'])
    df_formants_long['file_name'] = file
    df_formants_long['formant'] = df_formants_long['formant'].astype(int)
    df_formants_long['interval'] = df_formants_long['interval'].astype(float)
    df_formants_long['value'] = df_formants_long.apply(lambda x: formant.get_value_at_time(formant_number=int(x['formant']), time=x['interval']), axis=1)
    
    df_formants_wide = df_formants_long.pivot_table(index=['interval','file_name'], columns='formant', values='value', dropna=False).reset_index().sort_values(['interval','file_name'])
    df_formants_wide.columns.rename('', inplace=True)
    
    dfs.append(df_formants_wide)

df_final = pandas.concat(dfs, axis=0)
print(df_final)
