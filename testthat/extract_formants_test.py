# SOLA
import os
import sys
import numpy        # pip3 install numpy
import pandas
import parselmouth  # pip3 install praat-parselmouth
from parselmouth.praat import call

file_name = '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/wrassp/extdata/lbo001.wav'
snd = parselmouth.Sound(file_name)

max_formants = 8
formant = snd.to_formant_burg(time_step=5/1000, max_number_of_formants=max_formants)
formant.get_number_of_frames()
n_formants = numpy.arange(1, max_formants+1,1)
interval = numpy.arange(formant.start_time, formant.end_time-5/100, 5/1000)
n_interval = len(interval)
formant_values = numpy.zeros((n_interval, max_formants))

df_formants = pandas.DataFrame(data=[[n, i] for n in n_formants for i in interval], columns=['formant','interval'])
df_formants['formant'] = df_formants['formant'].astype(int)
df_formants['interval'] = df_formants['interval'].astype(float)
df_formants['value'] = df_formants.apply(lambda x: formant.get_value_at_time(formant_number=int(x['formant']), time=x['interval']), axis=1)
df_formants.head()

df_formants_01 = df_formants.pivot_table(index='interval', columns='formant', values='value', dropna=False).reset_index().sort_values('interval')
df_formants_01.columns.rename('', inplace=True)
df_formants_01.head()
df_formants_01.tail()


# OLD MEU
import os
import sys
import numpy        # pip3 install numpy
import parselmouth  # pip3 install praat-parselmouth
from parselmouth.praat import call

for file in os.listdir('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte'):
  if file.endswith(".wav"):
    file_list = os.path.join('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte', file)
    # print(file_list)
    snd = parselmouth.Sound(file_list)
    max_formants = 8
    formant = snd.to_formant_burg(time_step=5/1000, max_number_of_formants = max_formants)
    # snd = parselmouth.Sound('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte/10001_Palavras.wav')
    
    # daqui pra baixo tá muito podre, não operante
    formant.get_number_of_frames()
    n_formants = np.arange(1, max_formants+1,1)
    interval = np.arange(formant.start_time, formant.end_time-5/100, 5/1000)
    n_interval = len(interval)
    formant_values = np.zeros((n_interval, max_formants))

    j = 0
    for f in n_formants:
      for i in interval:
        formant_values[j,f] = formant.get_value_at_time(formant_number = f, time = i)
        j = j+1
    
    # pv = np.savetxt(sys.stdout, pitch_values, newline=',', fmt="%.8f")
    print(formant_values)

# pitch_strength = pitch.selected_array['strength']
