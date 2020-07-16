stopwatch

for j to 1000
	tot = 0
	for i to 100000
		tot += i
	endfor
#	appendInfoLine: string$(j+1), " - Total = ", string$(tot)
endfor

time = stopwatch
appendInfoLine: "Took ", string$(time), " seconds"

