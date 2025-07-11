#' These functions are sourced from the `embedr` package by Michael McCarthy, under
#' MIT License: https://github.com/mccarthy-m-g/embedr/blob/master/LICENSE.md
#' This inclusion is temporary and will be discontinued once `embedr` is available on CRAN.
#' See https://github.com/mccarthy-m-g/embedr for more details.
#'
#' Example Media Files
#'
#' Example media files included with embedr.
#'
#'  - `mp3`: MP3 audio
#'  - `mp4`: MP4 video
#'  - `png`: PNG thumbnail
#'
#' @rdname media-files
#' @name media-files
#' @aliases mp3 mp4 png
#' @export mp3 mp4 png
delayedAssign('mp3', system.file("media", "audio-vignette.mp3", package = "voice"))
delayedAssign('mp4', system.file("media", "video-vignette.mp4", package = "voice"))
delayedAssign('png', system.file("media", "thumbnail-vignette.png", package = "voice"))
