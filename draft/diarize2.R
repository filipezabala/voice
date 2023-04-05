wavDir <- list.files(system.file('extdata', package = 'wrassp'),
                     pattern <- glob2rx('*.wav'), full.names = TRUE)

diarize2(fromWav = unique(dirname(wavDir)),
         toRttm = tempdir(),
         token = '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')
dir(tempdir())



diarize2(
  fromWav = unique(dirname(wavDir)),
  toRttm = tempdir(),
  autoDir = FALSE,
  pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8',
  token = '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'
  )
