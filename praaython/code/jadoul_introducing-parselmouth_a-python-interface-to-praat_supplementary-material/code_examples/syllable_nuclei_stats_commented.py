# Import parselmouth, and get the shorthand names for call and run_file
import parselmouth
from parselmouth.praat import call, run_file

# We will also use numpy and pandas functionality
import numpy as np
import pandas as pd

def extract_syllable_intervals(file_name):
	print("Extracting syllable intervals from '{}'...".format(file_name))

	# Use Praat script to extract syllables
        # For each file name, we first run the Praat script, passing the desired parameters
	# This script was slightly adapted, as it used to take a directory as argument and loop
	#         over the audio files in that directory but now only takes a single file name
	#         and executes the algorithm for that file
        # As described in the script file, these parameters are: 'Silence threshold (dB)',
        #         'Minimum dip between peaks (dB)', 'Minimum pause duration', and the filename
	objects = run_file('syllable_nuclei.praat', -25, 2, 0.3, file_name)

	# The script selects two objects at the end, the Sound object and the TextGrid
	# These two objects are returned in a list, and now we assign the second one to the variable 'textgrid'
	textgrid = objects[1]

	# Call the Praat command "Get number of points" to query the amount of points in the first tier
	n = call(textgrid, "Get number of points", 1)

	# Make a list that queries the time of the point in the TextGrid for all points 1 to n
	#         (through a Python 'list comprehension', in this case, but one could also repeatedly 'append')
	syllable_nuclei = [call(textgrid, "Get time of point", 1, i + 1)
	                      for i in range(n)]

	# Use NumPy to calculate intervals between the syllable nuclei
	syllable_intervals = np.diff(syllable_nuclei)
	return syllable_intervals


def syllable_intervals_data(row):
	# Get file name of corpus audio file
	# We can construct the file name based on the 'audio_id' and 'speaker' entries of the CSV line
	file_name_format = "corpus/dialectaccent_vol_01_{:02}{}_64kb.mp3"
	file_name = file_name_format.format(row['audio_id'], row['speaker'])
	
	# Extract syllables and intervals with previously defined function
	intervals = extract_syllable_intervals(file_name)	
	
	# Return a new data frame with a row for each extracted interval
	# 'intervals' is a list and pandas will turn each element of this list into a new row
	return pd.DataFrame({'speaker': row['speaker'],
	                     'native': row['native'],
	                     'interval': intervals})


# Read the comma-separated values file containing metadata of our corpus
corpus = pd.read_csv("corpus/corpus.csv")
# Concatenate all data from the corpus into one big pandas DataFrame
# To do so, loop over all rows of the corpus, get the syllable intervals DataFrames, and concatenate them all
data = pd.concat([syllable_intervals_data(row) for _, row in corpus.iterrows()])



# Maximum likelihood (ML/REML) estimation of mixed-effects linear model
import statsmodels.formula.api as smf

# Construct and fit the StatsModels model, with 'native' a fixed effect and 'speaker' a random effect
# For details, see http://www.statsmodels.org/devel/mixed_linear.html
model = smf.mixedlm('interval ~ native', data, groups=data['speaker'])
results = model.fit()
# Print the results (or they could be saved, or further queried)
print(results.summary())


# Bayesian estimation of mixed-effects linear model
import bambi

# Construct and fit a Bayesian version of the same mixed-effect model
# For details, see https://github.com/bambinos/bambi#user-guide
model = bambi.Model(data)
results = model.fit('interval ~ native', random=['1|speaker'])
# And again print those results
print(results.summary())
