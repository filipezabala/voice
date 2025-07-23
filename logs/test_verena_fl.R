library(futile.logger)

# Configure logger
flog.appender(appender.file(file.path("logs", "r_session_fl.log")))
flog.threshold(INFO)

for(i in 1:2){
  tryCatch({
    flog.info("Starting R session processing")

    # START main code
    library(voice)
    library(tidyverse)

    wavDir <- list.files(system.file('extdata', package = 'wrassp'),
                         pattern = glob2rx('*.wav'), full.names = TRUE)

    M <- voice::extract_features(wavDir)
    glimpse(M)

    E <- dplyr::tibble(subject_id = c(1,1,1,2,2,2,3,3,3), wav_path = wavDir)
    E

    voice::tag(E)

    voice::tag(E, groupBy = 'subject_id')


    url0 <- 'https://github.com/filipezabala/voiceAudios/raw/refs/heads/main/wav/doremi.wav'
    download.file(url0, paste0(tempdir(), '/doremi.wav'), mode = 'wb')
    # voice::embed_audio(url0) # See https://github.com/mccarthy-m-g/embedr for more details.


    M <- voice::extract_features(tempdir())
    summary(M)
    # END main code

    flog.info("Processing completed successfully")
  }, error = function(e) {
    flog.fatal("Fatal error: %s", e$message)
    flog.fatal("Traceback:\n%s", paste(capture.output(traceback()), collapse = "\n"))
    flog.fatal("Session info:\n%s", paste(capture.output(sessionInfo()), collapse = "\n"))

    if (!interactive()) q(status = 1)
  })
}
