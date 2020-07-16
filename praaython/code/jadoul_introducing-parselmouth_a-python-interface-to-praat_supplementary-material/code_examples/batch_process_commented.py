# Use the Parselmouth and pandas Python libraries in this script
import parselmouth
import pandas as pd


# Let's define the analysis for a single data of the CSV file
# This function will later be run for every row of the data
def analyse_sound(row):
    # Extract the 'condition' and 'pp_id' value from the current row
    condition, pp_id = row['condition'], row['pp_id']
    
    # Use these two variables to determine what audio file to read
    filepath = 'audio/{}_{}.wav'.format(condition, pp_id)
    
    # Use Parselmouth to read the sound file and to run Praat's harmonicity analysis
    harmonicity = parselmouth.Sound(filepath).to_harmonicity()
    
    # Extract and return the value at the time in the 'time' column of the current row
    return harmonicity.get_value(row['time'])

# Read in the experimental results file
# This will return a pandas DataFrame
#         (cfr. https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html)
dataframe = pd.read_csv('results.csv')

# Apply parselmouth wrapper function row-wise
#         (cfr. https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.apply.html)
dataframe['harmonics_to_noise'] = dataframe.apply(analyse_sound, axis='columns') 

# Write out the updated dataframe (without putting a first column with the pandas 'index')
dataframe.to_csv('processed_results.csv', index=False)
