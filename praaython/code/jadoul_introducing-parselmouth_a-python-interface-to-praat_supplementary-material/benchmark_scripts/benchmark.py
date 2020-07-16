import parselmouth
import time

sounds = [parselmouth.Sound("../audio/" + fn) for fn in ("1_b.wav", "2_b.wav", "3_b.wav", "4_b.wav", "5_b.wav")]

now = time.time()

for j in range(10000):
	concatenated = parselmouth.Sound.concatenate(sounds)
	intensity = concatenated.to_intensity()

	n = intensity.get_number_of_frames()
	tot = 0.0
	for i in range(n):
		tot += intensity.values[i,0]
	mean = tot / n
#	print("{} - Mean = {}".format(j+1, mean))

time = time.time() - now
print("Took {} seconds".format(time))
