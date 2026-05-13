#' These functions are sourced from the `embedr` package by Michael McCarthy, under
#' MIT License: https://github.com/mccarthy-m-g/embedr/blob/master/LICENSE.md
#' This inclusion is temporary and will be discontinued once `embedr` is available on CRAN.
#' See https://github.com/mccarthy-m-g/embedr for more details.
#'
#' Embed audio in R Markdown documents
#'
#' `embed_audio()` provides a standard way to embed audio in R Markdown
#' documents when the output format is HTML, and to print placeholder text
#' when the output format is not HTML.
#'
#' `embed_audio()` is a wrapper for the HTML5 `<audio>` element that prints
#' HTML `<audio>` code in HTML documents built by R Markdown and placeholder
#' text in non-HTML documents built by R Markdown. This function may be useful
#' for conditional output that depends on the output format. For example, you
#' may embed audio in an R Markdown document when the output format is HTML,
#' and print placeholder text when the output format is LaTeX.
#'
#' The function determines output format using [knitr::is_html_output()]. By
#' default, these formats are considered as HTML formats: `c('markdown',
#' 'epub', 'html', 'html5', 'revealjs', 's5', 'slideous', 'slidy')`.
#'
#' @param src A path or URL to the media file.
#' @param type The type of media file specified in `src`.
#' @param attribute A character vector specifying which attributes to use.
#'   "none" can be used if no attributes are desired.
#' @param id A character string specifying a unique ID for the element.
#'   Can be used by CSS or JavaScript to perform certain tasks for
#'   the element with the specific ID.
#' @param placeholder The placeholder text to use when the output format is
#'   not HTML.
#' @return If `knitr::is_html_output()` is `TRUE`, returns HTML `<audio>` code.
#'   If `knitr::is_html_output()` is `FALSE`, returns placeholder text.
#' @note This function is supposed to be used in R code chunks or inline R code
#'   expressions. You are recommended to use forward slashes (/) as path
#'   separators instead of backslashes in the file paths.
#' @examples
#' # By default, embed_audio() embeds an audio element with playback controls
#' embed_audio(mp3)
#'
#' # To change the attributes of the audio element, use `attribute`
#' embed_audio(mp3, attribute = c("controls", "loop"))
#'
#' # To add placeholder text for non-HTML documents, use `placeholder`
#' embed_audio(mp3, placeholder = "This is placeholder text.")
#'
#' \dontrun{
#' # embed_audio() is intended to be used in R Markdown code chunks or inline
#' # expressions. The following creates and knits an R Markdown document to
#' # HTML and PDF in your current working directory for you to inspect:
#' library(rmarkdown)
#' writeLines(c("# Hello embedr!",
#' "```{r embed-audio, echo=TRUE}",
#' "embed_audio(mp3, placeholder = 'This is placeholder text.')",
#' "```"), "test.Rmd")
#' render("test.Rmd", output_format = c('html_document', 'pdf_document'))
#'
#' # Delete test files created by example code
#' unlink(c("test.Rmd", "test.html", "test.pdf"))
#' }
#' @export
embed_audio <- function(src,
                        type = c("mpeg", "ogg", "wav"),
                        attribute = c("controls", "autoplay", "loop",
                                      "muted", "preload", "none"),
                        id = "",
                        placeholder = "") {
  # check if src has a valid media file extension
  is.audio(src)
  # check if the audio sources exist
  is.local(src)
  is.hosted(src)
  # check whether default values should be used for type or attribute
  if(missing(type)) {type <- "mpeg"}
  if(missing(attribute)) {attribute <- "controls"}
  # evaluate choices
  type <- match.arg(type,
                    c("mpeg", "ogg", "wav"),
                    several.ok = TRUE)
  attribute <- match.arg(attribute,
                         c("controls", "autoplay", "loop",
                           "muted", "preload", "none"),
                         several.ok = TRUE)
  # collapse attribute choices to a character string
  attribute <- paste(attribute, sep = " ", collapse = " ")
  # make attribute empty if "none" is in the character string
  if (all(grepl("none", attribute))) {attribute <- ""}
  # compare length of src and type character vectors
  if (length(src) != length(type)) {
    message("Arguments `src` and `type` are different lengths; ",
            "recycling the shorter vector.")
  }
  # print output
  if (knitr::is_html_output()) {
    # open <audio> tag
    if (missing(id)) {
      audio <- sprintf("<audio %1$s>", attribute)
    } else {
      audio <- sprintf("<audio id='%2$s' %1$s>", attribute, id)
    }
    # create <source> strings from vectors, then collapse to single string
    audio_source <- paste(sprintf("<source src='%1$s' type='audio/%2$s'>",
                                  src, type), sep = "", collapse = "")
    # print the completed HTML <audio> output
    htmltools::HTML(audio, audio_source,
                    "Your browser does not support the audio tag; ",
                    "for browser support, please see: ",
                    "https://www.w3schools.com/tags/tag_audio.asp",
                    "</audio>")
  } else htmltools::HTML(placeholder)
}

#' Embed video in R Markdown documents
#'
#' `embed_video()` provides a standard way to embed video in R Markdown
#' documents when the output format is HTML, and to print placeholder text
#' when the output format is not HTML.
#'
#' `embed_video()` is a wrapper for the HTML5 `<video>` element that prints
#' HTML `<video>` code in HTML documents built by R Markdown and placeholder
#' text in non-HTML documents built by R Markdown. This function may be useful
#' for conditional output that depends on the output format. For example, you
#' may embed video in an R Markdown document when the output format is HTML,
#' and print placeholder text when the output format is LaTeX.
#'
#' The function determines output format using [knitr::is_html_output()]. By
#' default, these formats are considered as HTML formats: `c('markdown',
#' 'epub', 'html', 'html5', 'revealjs', 's5', 'slideous', 'slidy')`.
#'
#' @inheritParams embed_audio
#' @param width The width of the video, in pixels.
#' @param height The height of the video, in pixels.
#' @param thumbnail A path to an image.
#' @return If `knitr::is_html_output()` is `TRUE`, returns HTML `<video>` code.
#'   If `knitr::is_html_output()` is `FALSE`, returns placeholder text.
#' @note This function is supposed to be used in R code chunks or inline R code
#'   expressions. You are recommended to use forward slashes (/) as path
#'   separators instead of backslashes in the file paths.
#' @examples
#' # By default, embed_video() embeds a video element with playback controls
#' embed_video(mp4)
#'
#' # To change the attributes of the video element, use `attribute`
#' embed_video(mp4, attribute = c("controls", "loop"))
#'
#' # To add a thumbnail to the video element, use `thumbnail`
#' embed_video(mp4, thumbnail = png)
#'
#' # To add placeholder text for non-HTML documents, use `placeholder`
#' embed_video(mp4, placeholder = "This is placeholder text.")
#'
#' \dontrun{
#' # embed_video() is intended to be used in R Markdown code chunks or inline
#' # expressions. The following creates and knits an R Markdown document to
#' # HTML and PDF in your current working directory for you to inspect:
#' library(rmarkdown)
#' writeLines(c("# Hello embedr!",
#' "```{r embed-video, echo=TRUE}",
#' "embed_video(mp4, thumbnail = png, placeholder = 'This is placeholder text.')",
#' "```"), "test.Rmd")
#' render("test.Rmd", output_format = c('html_document', 'pdf_document'))
#'
#' # Delete test files created by example code
#' unlink(c("test.Rmd", "test.html", "test.pdf"))
#' }
#' @export
embed_video <- function(src,
                        type = c("mp4", "webm", "ogg"),
                        width = "320",
                        height = "240",
                        attribute = c("controls", "autoplay", "loop",
                                      "muted", "preload", "none"),
                        thumbnail = NULL,
                        id = "",
                        placeholder = "") {
  # check if src has a valid media file extension
  is.video(src)
  # check if the video sources exist
  is.local(src)
  is.hosted(src)
  # check whether default values should be used for type or attribute
  if(missing(type)) {type <- "mp4"}
  if(missing(attribute)) {attribute <- "controls"}
  # evaluate choices
  type <- match.arg(type,
                    c("mp4", "webm", "ogg"),
                    several.ok = TRUE)
  attribute <- match.arg(attribute,
                         c("controls", "autoplay", "loop",
                           "muted", "preload", "none"),
                         several.ok = TRUE)
  # collapse attribute choices to a character string
  attribute <- paste(attribute, sep = " ", collapse = " ")
  # make attribute empty if "none" is in the character string
  if (all(grepl("none", attribute))) {attribute <- ""}
  # compare length of src and type character vectors
  if (length(src) != length(type)) {
    message("Vectors `src` and `type` are different lengths; ",
            "recycling the shorter vector.")
  }
  # print output
  if (knitr::is_html_output()) {
    # decide whether to include thumbnail and id
    if (!missing(thumbnail) & !missing(id)) {
      # thumbnail and id
      video <- sprintf("<video id='%5$s' width='%1$s'
                       height='%2$s' %3$s poster='%4$s'>",
                       width, height, attribute, thumbnail, id)
    } else if (!missing(thumbnail) & missing(id)) {
      # thumbnail
      video <- sprintf("<video width='%1$s' height='%2$s' %3$s poster='%4$s'>",
                       width, height, attribute, thumbnail)
    } else if (missing(thumbnail) & !missing(id)) {
      # id
      video <- sprintf("<video id='%4$s' width='%1$s' height='%2$s' %3$s>",
                       width, height, attribute, id)
    } else {
      # no thumbnail or id
      video <- sprintf("<video width='%1$s' height='%2$s' %3$s>",
                       width, height, attribute)
    }
    # create <source> strings from vectors, then collapse to single string
    video_source <- paste(sprintf("<source src='%1$s' type='video/%2$s'>",
                                  src, type), sep = "", collapse = "")
    # print the completed HTML <video> output
    htmltools::HTML(video, video_source,
                    "Your browser does not support the video tag; ",
                    "for browser support, please see: ",
                    "https://www.w3schools.com/tags/tag_video.asp",
                    "</video>")
  } else htmltools::HTML(placeholder)
}
