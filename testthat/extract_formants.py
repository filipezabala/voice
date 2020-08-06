import os
import sys
import numpy
import pandas
import parselmouth  # pip3 install praat-parselmouth
from parselmouth.praat import call

pandas.set_option('display.max_rows', None)
pandas.set_option('display.max_columns', None)
pandas.set_option('display.width', None)
pandas.set_option('display.max_colwidth', None)
dfs = []

# for file in os.listdir('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/'):
for file in os.listdir(sys.argv[1]):
  if file.endswith(".wav"):
    # file_list = os.path.join('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/', file)
    file_list = os.path.join(sys.argv[1], file)
    snd = parselmouth.Sound(file_list)
    max_formants = 8
    formant = snd.to_formant_burg(time_step = 5/1000, max_number_of_formants = max_formants)
    n_formants = numpy.arange(1, max_formants+1, 1)
    interval = numpy.arange(formant.start_time, formant.end_time, 5/1000)
    n_interval = len(interval)
    formant_values = numpy.zeros((n_interval, max_formants))
    
    df_formants_long = pandas.DataFrame(data=[[n, i] for n in n_formants for i in interval], columns=['formant','interval'])
    df_formants_long['file_name'] = file
    df_formants_long['formant'] = df_formants_long['formant'].astype(int)
    df_formants_long['interval'] = df_formants_long['interval'].astype(float)
    df_formants_long['value'] = df_formants_long.apply(lambda x: formant.get_value_at_time(formant_number=int(x['formant']), time=x['interval']), axis=1)
    # print(df_formants_long)
    
    df_formants_wide = df_formants_long.pivot_table(index=['interval','file_name'], columns='formant', values='value', dropna=False).reset_index().sort_values(['interval','file_name'])
    df_formants_wide.columns.rename('', inplace=True)
    
    # <<<<
    dfs.append(df_formants_wide)

# <<<<
df_final = pandas.concat(dfs, axis=0)
print(df_final)
# df_final.shape
