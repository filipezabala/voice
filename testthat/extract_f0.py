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

for file in os.listdir('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/'):
# for file in os.listdir(sys.argv[1]):
  if file.endswith(".wav"):
    file_list = os.path.join('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/', file)
    # file_list = os.path.join(sys.argv[1], file)
    snd = parselmouth.Sound(file_list)
    pitch = snd.to_pitch(time_step = 5/1000)
    interval = numpy.arange(pitch.start_time, pitch.end_time-4/100, 5/1000)
    n_interval = len(interval)
    df_f0_long = pandas.DataFrame(data=[[i] for i in interval], columns=['interval'])
    df_f0_long['file_name'] = file
    df_f0_long['F0'] = pitch.selected_array['frequency']
    
    dfs.append(df_f0_long)

# <<<<
df_final = pandas.concat(dfs, axis=0)
print(df_final)

# pitch_strength = pitch.selected_array['strength']
