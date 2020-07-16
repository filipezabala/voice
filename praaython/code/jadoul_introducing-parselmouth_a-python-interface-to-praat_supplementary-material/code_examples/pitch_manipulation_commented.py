# Use parselmouth, and use the shorthand 'call' for 'parselmouth.praat.call'
import parselmouth
from parselmouth.praat import call


# Use the normal Parslemouth/Python interface to load the audio file
sound = parselmouth.Sound("audio/4_b.wav")

# As we don't have a 'Sound.to_manipulation' method and a 'Manipulation' class (yet)
#         in Parselmouth, we call the desired Praat command through the 'call' interface
# The first argument is the object (or list of objects) that would normally be selected
#         in the Praat object list (through a click or 'selectObject' for example)
# The second argument is a string with the name of the command/button in Praat
# The rest of the arguments are the arguments to this Praat command/action. Parselmouth will
#         convert Python numbers (integers and floats), booleans, strings, vectors and matrices
#         to their equivalent Praat argument type
# Finally, the object that is created is returned, in this case
# Knowing all this, this line converts the Sound object to a Manipulation object
manipulation = call(sound, "To Manipulation", 0.001, 75, 600)

# Next, we extract the PitchTier from this manipulation
pitch_tier = call(manipulation, "Extract pitch tier")


# We then multiply all of the pitch frequencies in this Tier by 2, effectively increasing
#         the pitch by one octave
call(pitch_tier, "Multiply frequencies", sound.xmin, sound.xmax, 2)


# Selecting the PitchTier and Manipulation object, we replace the PitchTier in the Manipulation
# This is once again equivalent with what one would do in the Praat user interface or a Praat script
call([pitch_tier, manipulation], "Replace pitch tier")

# Finally, we resyntesize a Sound, that now has a pitch track of one octave higher
# Since this new Praat Sound object is created, it is then also returned, and we have a
#         variable of type parselmouth.Sound again
sound_octave_up = call(manipulation, "Get resynthesis (overlap-add)")


# As we have a parselmouth.Sound object again, we can now use the normal Python interface
#         to for example save the sound again as a .wav file (or plot it, or ...)
sound_octave_up.save("4_b_octave_up.wav", "WAV")

