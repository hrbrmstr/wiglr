#' Get WiGLE statistics for a specified country, organized by region
#'
#' @param country iso2c two-letter country code; defaults to `US`
#' @param api_key WiGLE API Key. See [wigle_api_key()]
#' @return `list` of three data frames (tibbles) containing `region`, `encryption` and
#'         `postal_code` stats or invisible JSON API response if unsuccessful
#'         and a 2xx.
#' @export
wigle_region_stats <- function(country="US", api_key=wigle_api_key()) {
  httr::GET(
    url = "https://api.wigle.net/api/v2/stats/regions",
    query = list(
      country = toupper(country[1])
    ),
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

    reg <- out$regions
    pos <- out$postalCode
    enc <- out$encryption

    reg$country <- out$country
    pos$country <- pos$country
    enc$country <- enc$country

    class(reg) <- c("tbl_df", "tbl", "data.frame")
    class(pos) <- c("tbl_df", "tbl", "data.frame")
    class(enc) <- c("tbl_df", "tbl", "data.frame")

    list(
      regions = reg,
      encryption = enc,
      postal_code = pos
    )

  } else {
    message("API call unsuccessful. Invisibly returning JSON API response.")
    invisible(out)
  }

}