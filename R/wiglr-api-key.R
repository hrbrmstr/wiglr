#' Get or set WIGLE_API_KEY value
#'
#' The API wrapper functions in this package all rely on a WiGLE API
#' key residing in the environment variable \code{WIGLE_API_KEY}. The
#' easiest way to accomplish this is to set it in the `.Renviron` file in your
#' home directory.
#'
#' @param force Force setting a new WiGLE API key for the current environment?
#' @return atomic character vector containing the WiGLE API key
#' @references <https://wigle.net/account>
#' @export
wigle_api_key <- function(force = FALSE) {
  env <- Sys.getenv("WIGLE_API_KEY")
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop(
      "Please set env var WIGLE_API_KEY to your WiGLE API key",
      call. = FALSE
    )
  }

  message("Couldn't find env var WIGLE_API_KEY See ?wigle_api_key for more details.")
  message("Please enter your WiGLE API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("WiGLE API key entry failed", call. = FALSE)
  }

  message("Updating WIGLE_API_KEY env var to PAT")
  Sys.setenv(WIGLE_API_KEY = pat)

  pat
}
