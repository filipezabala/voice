Read from file: "../audio/1_b.wav"
Read from file: "../audio/2_b.wav"
Read from file: "../audio/3_b.wav"
Read from file: "../audio/4_b.wav"
Read from file: "../audio/5_b.wav"

stopwatch
for j to 10000
	selectObject: "Sound 1_b", "Sound 2_b", "Sound 3_b", "Sound 4_b", "Sound 5_b"
	Concatenate
	
	To Intensity: 100.0, 0.0, 1
	n = Get number of frames
	tot = 0
	for i to n
		tot += Get value in frame... i
	endfor
	mean = tot / n
#	appendInfoLine: string$(j+1), " - Mean = ", string$(mean)

	selectObject: "Sound chain"
	Remove

	selectObject: "Intensity chain"
	Remove
endfor

time = stopwatch
appendInfoLine: "Took ", string$(time), " seconds"

selectObject: "Sound 1_b", "Sound 2_b", "Sound 3_b", "Sound 4_b", "Sound 5_b"
Remove

