library(voice)
library(tidyverse)
library(log4r)

# Set up directory first
if (!dir.exists("logs")) {
  dir.create("logs", recursive = TRUE)
}

# Then create logger
logger <- create.logger(
  logfile = file.path("logs", "r_session_log4r.log"),
  level = "INFO"
)

for(i in 1:2){
  # Wrap your main code in tryCatch
  tryCatch({
    info(logger, "Starting R session processing")

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

    info(logger, "Processing completed successfully")
  }, error = function(e) {
    error(logger, paste("Fatal error:", e$message))
    error(logger, "Traceback:")
    error(logger, paste(capture.output(traceback()), collapse = "\n"))
    error(logger, "Session info:")
    error(logger, paste(capture.output(sessionInfo()), collapse = "\n"))

    # Save workspace for debugging
    save.image(file = file.path("logs", "error_workspace.RData"))

    if (!interactive()) q(status = 1)
  })
  print(i)
}
