import parselmouth

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set() # Use seaborn's default style to make attractive graphs

def draw_spectrogram(spect, dynamic_range=70):
    X, Y = spect.x_grid(), spect.y_grid()
    sg_db = 10 * np.log10(spect.values)
    min_db = sg_db.max() - dynamic_range
    plt.pcolormesh(X, Y, sg_db, vmin=min_db, cmap='afmhot')
    plt.ylim([spect.ymin, spect.ymax])
    plt.xlabel("time [s]")
    plt.ylabel("frequency [Hz]")

def draw_pitch(pitch):
    # Extract selected pitch contour, and
    # replace unvoiced samples by NaN to not plot
    pitch_values = pitch.selected_array['frequency']
    pitch_values[pitch_values==0] = np.nan
    plt.plot(pitch.xs(), pitch_values, 'o', markersize=5, color='w')
    plt.plot(pitch.xs(), pitch_values, 'o', markersize=2)
    plt.grid(False)
    plt.ylim(0, pitch.ceiling)
    plt.ylabel("fundamental frequency [Hz]")

snd = parselmouth.Sound("audio/4_b.wav")
pitch = snd.to_pitch()
# Optionally pre-emphasize the sound before calculating the spectrogram
snd.pre_emphasize()
spectrogram = snd.to_spectrogram(maximum_frequency=8000.0)

plt.figure()
draw_spectrogram(spectrogram)
plt.twinx()
draw_pitch(pitch)
plt.xlim([snd.xmin, snd.xmax])
plt.show()


import pandas as pd

def facet_util(data, **kwargs):
    digit, speaker_id = data[['digit', 'speaker_id']].iloc[0]
    sound = parselmouth.Sound("audio/{0}_{1}.wav".format(digit, speaker_id))
    pitch = sound.to_pitch()
    sound.pre_emphasize()
    draw_spectrogram(sound.to_spectrogram())
    plt.twinx()
    draw_pitch(pitch)
    # If not the rightmost column, then clear the right side axis
    if speaker_id != 'y':
        plt.ylabel("")
        plt.yticks([])

results = pd.read_csv("audio/digit_list.csv")

grid = sns.FacetGrid(results, row='digit', col='speaker_id')
grid.map_dataframe(facet_util)
grid.set_titles(col_template="{col_name}", row_template="{row_name}")
grid.set_axis_labels("time [s]", "frequency [Hz]")
grid.set(xlim=(0, None))
# Optionally: grid.set(facecolor='white')
plt.show()
