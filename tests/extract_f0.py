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

# for file in sorted(os.listdir('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/')):
for file in dirlist:
  if file.endswith('.wav'):
    # file_list = os.path.join('/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/', file)
    file_list = os.path.join(sys.argv[1], file)
    snd = parselmouth.Sound(file_list)
    pitch = snd.to_pitch(time_step = float(sys.argv[2]))
    interval = numpy.arange(pitch.start_time, pitch.end_time, float(sys.argv[2]))
    df_f0_long = pandas.DataFrame(data=[[i] for i in interval], columns=['interval'])
    df_f0_long['interval'] = df_f0_long['interval'].astype(float)
    df_f0_long['file_name'] = file
    df_f0_long['F0'] = df_f0_long.apply(lambda x: pitch.get_value_at_time(time=x['interval']), axis=1)
    # df_f0_long['F0'] = pitch.selected_array['frequency']
    dfs.append(df_f0_long)

df_final = pandas.concat(dfs, axis=0)
print(df_final)

# pitch_strength = pitch.selected_array['strength']
