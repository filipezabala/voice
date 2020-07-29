import os
import sys
import numpy
import parselmouth
from parselmouth.praat import call

for file in os.listdir(sys.argv[1]):
  if file.endswith(".wav"):
    file_list = os.path.join(sys.argv[1], file)
    snd = parselmouth.Sound(file_list)
    pitch = snd.to_pitch(time_step=5/1000)
    pitch_values = pitch.selected_array['frequency']
    pv = numpy.savetxt(sys.stdout, pitch_values, newline=',', fmt="%.8f")
    print(pv)

# pitch_strength = pitch.selected_array['strength']
