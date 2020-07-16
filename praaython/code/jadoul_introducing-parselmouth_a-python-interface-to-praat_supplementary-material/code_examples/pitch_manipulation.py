import parselmouth
from parselmouth.praat import call

sound = parselmouth.Sound("audio/4_b.wav")

manipulation = call(sound, "To Manipulation", 0.001, 75, 600)
pitch_tier = call(manipulation, "Extract pitch tier")

call(pitch_tier, "Multiply frequencies", sound.xmin, sound.xmax, 2)

call([pitch_tier, manipulation], "Replace pitch tier")
sound_octave_up = call(manipulation, "Get resynthesis (overlap-add)")

sound_octave_up.save("4_b_octave_up.wav", "WAV")

