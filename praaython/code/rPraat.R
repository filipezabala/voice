# install.packages('rPraat', dep =T)
library(rPraat)

formant <- formant.sample()
formant.plot(formant, drawBandwidth = TRUE)
formant2 <- formant.cut(formant, tStart = 3)
formant.plot(formant2, drawBandwidth = TRUE)
