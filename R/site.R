#' Get WiGLE named map of site-level statistics
#'
#' @param api_key WiGLE API Key. See [wigle_api_key()]
#' @return data frame (tibble) or invisible JSON API response if unsuccessful
#'         and a 2xx.
#' @export
wigle_site_stats <- function(api_key=wigle_api_key()) {
  httr::GET(
    url = "https://api.wigle.net/api/v2/stats/site",
    .WIGLRUA,
    httr::add_headers(
      `Authorization` = sprintf("Basic %s", api_key)
    ),
    httr::accept_json()
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  if (out$success) {
    out <- out$countries
    class(out) <- c("tbl_df", "tbl", "data.frame")
    out
  } else {
    message("API call unsuccessful. Invisibly returning JSON API response.")
    invisible(out)
  }

}