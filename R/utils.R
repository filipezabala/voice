#' These functions are sourced from the `embedr` package by Michael McCarthy, under
#' MIT License: https://github.com/mccarthy-m-g/embedr/blob/master/LICENSE.md
#' This inclusion is temporary and will be discontinued once `embedr` is available on CRAN.
#' See https://github.com/mccarthy-m-g/embedr for more details.
#'
#' Check if URL exists
#'
#' Given a character string, returns a logical vector indicating
#' whether a request for a specific URL responds without error.
#'
#' @param x A character vector.
#' @return `TRUE` if the URL responds without error, otherwise `FALSE`.
url.exists <- function(x) {
  tryCatch(!httr::http_error(x), error=function(e) FALSE)
}

#' Match string for URL prefix
#'
#' Given a character vector, returns a logical vector indicating
#' which elements have a URL scheme.
#'
#' @param x A character vector.
is.url <- function(x) {
  grepl("www.|http://|https://|ftp://|file://", x)
}


#' Return strings without a URL scheme
#'
#' Given a character vector, returns a logical indicating whether the
#' paths in the vector point to existing local files.
#'
#' @param x A character vector.
is.local <- function(x) {
  # check if paths have a URL scheme
  paths <- is.url(x)
  # name paths
  names(paths) <- x
  # remove paths with a URL scheme
  paths <- paths[(paths %in% FALSE)]
  # check which paths exist
  paths.exist <- file.exists(names(paths))
  # name path.exists
  names(paths.exist) <- names(paths)
  # return result or error
  if (length(paths) == 0) {
    # default to NULL if no path names without a URL scheme are present
    NULL
  } else if (!all(paths.exist)) {
    # remove paths that exist
    paths.exist <- paths.exist[(paths.exist %in% FALSE)]
    # notify user of the paths causing the error
    if (length(paths.exist) > 1) {
      stop("The files: ", paste(names(paths.exist), sep = ", ",
                                collapse = ", "), " do not exist. Please use valid filepaths.")
    } else {
      stop("The file: ", paste0(names(paths.exist)), " does not exist. ",
           "Please use a valid filepath.")
    }
  } else all(file.exists(names(paths))) # return TRUE
}

#' Return strings with a URL scheme
#'
#' Given a character vector, returns a logical indicating whether the
#' URLs in the vector respond without error.
#'
#' @param x A character vector.
is.hosted <- function(x) {
  # check if paths have a URL scheme
  paths <- is.url(x)
  # name paths
  names(paths) <- x
  # remove paths with a URL scheme
  paths <- paths[!(paths %in% FALSE)]
  # check which paths exist
  paths.exist <- sapply(names(paths), url.exists)
  # name path.exists
  names(paths.exist) <- names(paths)
  # return result or error
  if (length(paths) == 0) {
    # default to NULL if no path names without a URL scheme are present
    NULL
  } else if (!all(paths.exist)) {
    # remove paths that exist
    paths.exist <- paths.exist[(paths.exist %in% FALSE)]
    # notify user of the paths causing the error
    if (length(paths.exist) > 1) {
      stop("The URLs: ", paste(names(paths.exist), sep = ", ",
                               collapse = ", "), " do not exist. Please use valid URLs.")
    } else {
      stop("The URL: ", paste0(names(paths.exist)), " does not exist. ",
           "Please use a valid URL.")
    }
  } else all(sapply(names(paths), url.exists)) # return TRUE
}

#' Match string for audio suffix
#'
#' Given a character vector, returns a logical vector indicating
#' which elements have a valid audio file extension.
#'
#' @param x A character vector.
is.audio <- function(x) {
  # check if paths have a valid media file extension
  paths <- grepl(".mp3|.ogg|.wav", x)
  # name paths
  names(paths) <- x
  # check if all paths have valid media file extensions
  if (!all(grepl(".mp3|.ogg|.wav", x))) {
    # remove paths with a valid media file extension
    paths <- paths[(paths %in% FALSE)]
    # notify user of the paths causing the error
    if (length(paths) > 1) {
      stop(paste(names(paths), sep = ", ", collapse = ", "),
           " do not end with a valid audio file extension; ",
           "valid extensions are .mp3, .ogg, and .wav.")
    } else {
      stop(names(paths), " does not end with a valid audio file extension; ",
           "valid extensions are .mp3, .ogg, and .wav.")
    }
  } else all(grepl(".mp3|.ogg|.wav", x)) # return TRUE
}

#' Match string for video suffix
#'
#' Given a character vector, returns a logical vector indicating
#' which elements have a valid video file extension.
#'
#' @param x A character vector.
is.video <- function(x) {
  # check if paths have a valid media file extension
  paths <- grepl(".mp4|.webm|.ogg", x)
  # name paths
  names(paths) <- x
  # check if all paths have valid media file extensions
  if (!all(grepl(".mp4|.webm|.ogg", x))) {
    # remove paths with a valid media file extension
    paths <- paths[(paths %in% FALSE)]
    # notify user of the paths causing the error
    if (length(paths) > 1) {
      stop(paste(names(paths), sep = ", ", collapse = ", "),
           " do not end with a valid video file extension; ",
           "valid extensions are .mp4, .webm, and .ogg.")
    } else {
      stop(names(paths), " does not end with a valid video file extension; ",
           "valid extensions are .mp4, .webm, and .ogg.")
    }
  } else all(grepl(".mp4|.webm|.ogg", x)) # return TRUE
}
