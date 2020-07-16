# Use Parselmouth as Python library in this script
import parselmouth

# Use the numpy library to do matrix and vector operations on some arrays returned by Parselmouth
import numpy as np
# Use the common visualization/plotting libraries for Python
import matplotlib.pyplot as plt
import seaborn as sns
sns.set() # Use seaborn's default style to make attractive graphs


# Let's define how we would like to draw a spectrogram, given a Parselmouth Spectrogram object and optionally the dynamic range
def draw_spectrogram(spect, dynamic_range=70):
    # Objects that are sampled have three different ways of accessing the x-/y-values of the samples:
    # 1. object.xs()/.ys() returns the x-/y-values of the samples
    # 2. object.x_grid()/.y_grid() returns the x-/y-values that form an equally spaced grid around
    #         the samples (i.e., nx + 1 samples from (x1 - 0.5 * dx) to (x1 + (nx + 0.5) * dx))
    # 3. object.x_bins()/.y_bins() returns a 2D array of x-/y-values, each time containing the left
    #         and right boundary of the grid returned by object.x_grid()/.y_grid()
    #
    # In this case, since we are using matplotlib's pcolormesh, we need the x_grid() and y_grid()
    #         to indicate the extent of each little square of the spectrogram to be drawn
    X, Y = spect.x_grid(), spect.y_grid()
    
    # We then convert the raw values of the spectrogram to decibel
    # spect.values is a 2D numpy array of all sample values in the Spectrogram, the rows being frequencies and the columns 
    # The decibel calculation applied to all values in this array is then stored in the sg_db variable
    sg_db = 10 * np.log10(spect.values)
    
    # To limit the dynamic range to be plotted, we calculate the minimum value of the scale:
    #         this is the maximum dB intensity minus the dynamic range parameter
    min_db = sg_db.max() - dynamic_range
    
    # We now plot the main part of the spectrogram
    # X and Y are combined into a 2D grid, and sg_db will determine the value represented as a color
    #         (cfr. https://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.pcolormesh)
    # In order to stick to a certain dynamic range, we set the minimal value to min_db such that
    #         matplotlib will use the minimal color of the colorscale/-map for anything less than min_db
    # We customize the color scale with the 'afmhot' colormap
    #         (cfr. https://matplotlib.org/tutorials/colors/colormaps.html)
    plt.pcolormesh(X, Y, sg_db, vmin=min_db, cmap='afmhot')
    
    # Just to be sure, we tell matplotlib to limit the range of the y-axis from the spectrogram's ymin to ymax
    plt.ylim([spect.ymin, spect.ymax])
    
    # Label the two axes
    plt.xlabel("time [s]")
    plt.ylabel("frequency [Hz]")


# Let's define how we would like to draw a pitch, given a Parselmouth Pitch object
def draw_pitch(pitch):
    # Extract selected pitch contour, and
    # replace unvoiced samples by NaN to not plot
    
    # Extract a numpy array containing the 'selected' frequency candidates per time sample
    # This 'selected_array' is a so-called 'structured array' with each entry consisting of frequency and strength
    #         (cfr. http://www.fon.hum.uva.nl/praat/manual/Pitch.html and https://docs.scipy.org/doc/numpy/user/basics.rec.html)
    # We are only interested in the estimated frequencies to plot, in this example
    pitch_values = pitch.selected_array['frequency']
    
    # Where these pitch values are 0, the best estimate is that the analysis window of this sample is unvoiced
    # Putting the entries of this array where the pitch is zero to NaN (not-a-number, an 'undefined' value)
    #         will tell matplotlib to not plot these points
    pitch_values[pitch_values==0] = np.nan
    
    # We now plot the estimates at the pitch's x-values as dots, not making any interpolation or extrapolation claims
    # To do so, we pass the pitch.xs() as x values, the values (with NaNs), and configure the markers, the size, and the color
    # For a nicer visualization, we plot the data points twice, putting bigger dots in white in the background to make them stand out better
    plt.plot(pitch.xs(), pitch_values, 'o', markersize=5, color='w')
    plt.plot(pitch.xs(), pitch_values, 'o', markersize=2)
    
    # We don't want matplotlib to draw the plot (as it will clutter the spectrogram behind)
    plt.grid(False)
    
    # Set the range of the y-axis from 0 to the maximal pitch that Praat used in its algorithms
    plt.ylim(0, pitch.ceiling)
    
    # Label the y-axis
    plt.ylabel("fundamental frequency [Hz]")




# Read a single sound file into a Parselmouth Sound (i.e., a Praat Sound object)
# The result can just be assigned to a normal Python variable
snd = parselmouth.Sound("audio/4_b.wav")

# Perform Praat's Pitch analysis on this sound file, using the default parameters
pitch = snd.to_pitch()

# Optionally pre-emphasize the sound before calculating the spectrogram
snd.pre_emphasize()

# Analyze the sound as Praat Spectrogram, using the default parameters except for the maximum frequency
spectrogram = snd.to_spectrogram(maximum_frequency=8000.0)


# Start drawing a new figure
plt.figure()

# Draw the spectrogram using the function we defined before
draw_spectrogram(spectrogram)

# Switch to the other y-axis (the one on the right)
plt.twinx()

# Now draw the pitch using the other function we defined before
draw_pitch(pitch)

# Set the range of the x-axis for both the spectrogram and the pitch
plt.xlim([snd.xmin, snd.xmax])

# Show the plot! (Or save it to file, or ...)
plt.show() # Or plt.savefig(my_plot.png)



# For the next part, we also need the pandas library to read a CSV file
import pandas as pd

# Let's define how to draw a single panel of our structured grid of visualizations
# This function will later be called for each part of the data that is part of the same panel
def facet_util(data, **kwargs):
    # Extract the 'digit' and 'speaker_id' value from the part of the data
    digit, speaker_id = data[['digit', 'speaker_id']].iloc[0]
    
    # Read the sound file corresponding to this data, to be found by putting the digit
    #         and speaker ID in the filename pattern
    sound = parselmouth.Sound("audio/{0}_{1}.wav".format(digit, speaker_id))
    
    # Now draw the spectrogram and pitch as before
    pitch = sound.to_pitch()
    sound.pre_emphasize()
    draw_spectrogram(sound.to_spectrogram())
    plt.twinx()
    draw_pitch(pitch)
    
    # If not the rightmost column, then clear the right side axis
    # This seems to be an error in seaborn/matplotlib, and we only want to draw
    #         the right y-axis if this is the rightmost part of the grid
    if speaker_id != 'y':
        plt.ylabel("")
        plt.yticks([])


# Read the CSV to a pandas DataFrame
results = pd.read_csv("audio/digit_list.csv")

# We create a new figure that will be a seaborn FacetGrid
# I.e., this figure will consist of a grid of plots, organized in a certain way
# In this case, the rows are the different digits and the columns represent different speakers
grid = sns.FacetGrid(results, row='digit', col='speaker_id')

# We 'map' the facet_util function we defined before over this grid
# This means that for every entry in this grid, the plot at that location will be drawn
#         using that function we have just defined
grid.map_dataframe(facet_util)

# Set titles of the different plots, and set the axis labels
grid.set_titles(col_template="{col_name}", row_template="{row_name}")
grid.set_axis_labels("time [s]", "frequency [Hz]")

# Make the x-axis of all subplots start at 0, but use an automatically calculated maximum
grid.set(xlim=(0, None))

# If seaborn/matplotlib support this feature, you can make the background of the spectrograms white
# Optionally: grid.set(facecolor='white')

# Show the plot!
plt.show()

