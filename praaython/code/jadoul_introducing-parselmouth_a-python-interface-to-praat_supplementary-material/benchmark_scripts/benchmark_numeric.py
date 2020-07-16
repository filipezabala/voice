import time

now = time.time()

for j in range(1000):
	tot = 0
	for i in range(1, 100001):
		tot += i
#	print("{} - Total = {}".format(j+1, tot))

time = time.time() - now
print("Took {} seconds".format(time))
