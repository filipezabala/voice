import parselmouth
import pandas as pd

def analyse_sound(row):
    condition, pp_id = row['condition'], row['pp_id']
    filepath = 'audio/{}_{}.wav'.format(condition, pp_id)
    harmonicity = parselmouth.Sound(filepath).to_harmonicity()
    return harmonicity.get_value(row['time'])

# Read in the experimental results file
dataframe = pd.read_csv('results.csv')

# Apply parselmouth wrapper function row-wise
dataframe['harmonics_to_noise'] = dataframe.apply(analyse_sound, axis='columns') 

# Write out the updated dataframe
dataframe.to_csv('processed_results.csv', index=False)
