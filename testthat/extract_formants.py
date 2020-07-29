import os
import sys
import numpy as np
import parselmouth
from parselmouth.praat import call

for file in os.listdir('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte'):
  if file.endswith(".wav"):
    file_list = os.path.join('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte', file)
    # snd = parselmouth.Sound(file_list)
    snd = parselmouth.Sound('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte/10001_Palavras.wav')
    max_formants = 8
    formant = snd.to_formant_burg(time_step=5/1000, max_number_of_formants = max_formants)
    print(formant)

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
