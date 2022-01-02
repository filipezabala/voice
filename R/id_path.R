#' Sample IDs and paths
#'
#' A dataset containing sample IDs and paths used in
#' Zabala (2022) voice: new approaches to audio analysis.
#' The considered sample contains 34,425 rows associated with
#' 838 IDs ($p_{s} \approx 2.4\%$).
#'
#' @usage \code{data(id_path)}
#' @references Ardila R, Branson M, Davis K, Henretty M, Kohler M, Meyer J, Morais R, Saunders L, Tyers FM, Weber G (2019). “Common voice: A massively-multilingual speech corpus.” arXiv preprint arXiv:1912.06670. URL https://arxiv.org/abs/1912.06670.
#' @format A tibble with 34,425 rows and 2 variables:
#' \describe{
#'   \item{client_id}{Hash containing client ID.}
#'   \item{path}{Media file names.}
#' }
'id_path'

