#' Transcribe audio to text
#'
#' @description Transcribe audio to text.
#' @param file Audio file to trinscribe.
#' @param server Default: http://localhost:8080.
#' @param wait Default: \code{TRUE}.
#' @param poll_interval Default: 2.
#' @param timeout Default: 300.
#' @references https://github.com/rishikanthc/scriberr
#' @export
transcribe <- function(
    file,
    server = "http://localhost:8080",
    wait = TRUE,
    poll_interval = 2,
    timeout = 300
) {
  stopifnot(file.exists(file))

  # 1. Upload file
  upload_resp <- httr2::request(paste0(server, "/api/upload")) |>
    httr2::req_body_multipart(file = file) |>
    httr2::req_perform()

  upload_data <- httr2::resp_body_json(upload_resp)
  file_id <- upload_data$id

  # 2. Trigger transcription
  transcribe_resp <- httr2::request(paste0(server, "/api/transcribe")) |>
    httr2::req_body_json(list(file_id = file_id)) |>
    httr2::req_perform()

  job_data <- httr2::resp_body_json(transcribe_resp)
  job_id <- job_data$job_id

  # 3. Poll for result
  if (!wait) return(job_id)

  start_time <- Sys.time()

  repeat {
    status_resp <- httr2::request(
      paste0(server, "/api/transcripts/", job_id)
    ) |>
      httr2::req_perform()

    status_data <- httr2::resp_body_json(status_resp)

    if (status_data$status == "completed") {
      return(list(
        text = status_data$text,
        segments = status_data$segments,
        speakers = status_data$speakers
      ))
    }

    if (difftime(Sys.time(), start_time, units = "secs") > timeout) {
      stop("Transcription timed out")
    }

    Sys.sleep(poll_interval)
  }
}
