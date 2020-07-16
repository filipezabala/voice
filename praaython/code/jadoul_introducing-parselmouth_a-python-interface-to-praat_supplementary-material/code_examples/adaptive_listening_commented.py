# The following three fragements of code can be inserted into the PsychoPy Builder
#         experiment through a 'Code component'


# -- Begin experiment --
# This code is executed once, at the start of the experiment and initializes some things

# We need the 'parselmouth' and 'numpy' library, and Python built-in module 'random'
import parselmouth
import numpy as np
import random

# There are two conditions in this experiment: 'bat' ("a") and 'bet' ("e")
#         and there are also two corresponding audio files
# The 'stimulus_files' maps the different conditions to the right audio file
conditions = ['a', 'e']
stimulus_files = {'a': 'audio/bat.wav', 'e': 'audio/bet.wav'}

# We are defining a constant: the intensity in dB to which we will normalize all audio
STANDARD_INTENSITY = 70.

# Now we will read in all the conditions' audio files, normalize their intensity,
#         and store them in the dictionary variable 'stimuli'
stimuli = {}

# Loop over all conditions
for condition in conditions:
    # Read the audio file corresponding to the condition into a Praat/Parselmouth object
    stimulus = parselmouth.Sound(stimulus_files[condition])
    
    # Scale the intensity of this Sound objet
    stimulus.scale_intensity(STANDARD_INTENSITY)
    
    # And store it as the stimulus for the current condition
    stimuli[condition] = stimulus





# -- Begin Routine --
# This code is executed at the start of the routine, so for every loop of the experiment

# For the current trial/routine of the experiment, select a condition (uniformly) at random
random_condition = random.choice(conditions)

# Get the stimulus that corresponds to this randomly chosen condition
random_stimulus = stimuli[random_condition]


# Now, we need to add noise
# In order to do so, we first generate as many random, normally-distributed samples
#         as there are samples in the Sound object
noise_samples = np.random.normal(size=random_stimulus.n_samples)

# We use these samples to create a new Sound object with the same sampling frequency
#         and consequently also the same time length
noisy_stimulus = parselmouth.Sound(noise_samples,
                     sampling_frequency=random_stimulus.sampling_frequency)

# The 'level' variable contains the current level of the PsychoPy staircase loop
# We use this level as the signal-to-noise ratio, subtract it from the standard
#         intensity that the stimuli have, and scale the noise to this intensity
noisy_stimulus.scale_intensity(STANDARD_INTENSITY - level)

# Since the intensity of 'random_stimulus' is now 'STANDARD_INTENSITY' and the intensity
#         of 'noisy_stimulus' is 'STANDARD_INTENSITY - level' we have the desired
#         signal-to-noise ratio, and we add the values of the samples in 'noisy_stimulus'
noisy_stimulus.values += random_stimulus.values

# And to make sure all the noisy stimuli have the same intensity, we normalize once again
noisy_stimulus.scale_intensity(STANDARD_INTENSITY)


# 'filename' variable is set by PsychoPy and contains base file name
# of saved log/output files, so we'll use that to save our custom stimuli
# This way, we save all our generated stimuli into the output folder
stimulus_file_name = filename + '_stimulus_' + str(trials.thisTrialN) + '.wav'

# Since PsychoPy seems to expect audio files with 44100 Hz sample rate, we resample
#         the noisy stimulus and save it to the desired file name
noisy_stimulus.resample(44100).save(stimulus_file_name, "WAV")

# Finally, we set this newly save file in the PsychoPy Sound stimulus component
#         that will be played in this trial
sound_1.setSound(stimulus_file_name)





# -- End routine --
# This code is executed at the end of the routine, so for every loop of the experiment

# After the participant has responded, we need tell the PsychoPy experiment whether the response
# was correct, i.e. whether the pressed key was equal to the randomly selected condition
trials.addResponse(key_resp_2.keys == random_condition)
