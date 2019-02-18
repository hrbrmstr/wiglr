#' Get WiGLE named map of general statistics
#'
#' @param lat1,lat2,lon1,lon2 lower/upper lat/lon search area
#' @param only_mine <lgl> def: `FALSE`; Search only for points first discovered by the current user. Use any string to set, leave unset for general search. Can’t be used with COMMAPI auth, since these are points you have locally.
#' @param search_after if not `NULL` then the record to search after in paginated
#'        responses which is returned in the results list as `search_after`.
#' @param api_key WiGLE API Key. See [wigle_api_key()]
#' @return list or invisible JSON API response if unsuccessful
#'         and a 2xx.
#' @export
#' @examples \dontrun{
#' wigle_bbox_search(43.2468, 43.2806, -70.9282, -70.8025)
#' }
wigle_bbox_search <- function(lat1, lat2, lon1, lon2,
                              only_mine = FALSE,
                              search_after = NULL,
                              api_key=wigle_api_key()) {
  httr::GET(
    url = "https://api.wigle.net/api/v2/network/search",
    query = list (
      onlymine = tolower(only_mine[1]),
      latrange1 = lat1,
      latrange2 = lat2,
      longrange1 = lon1,
      longrange2 = lon2,
      searchAfter = search_after
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
    if (inherits(out$results, "data.frame")) {
      class(out$results) <- c("tbl_df", "tbl", "data.frame")
    }
    out
  } else {
    message("API call unsuccessful. Invisibly returning JSON API response.")
    invisible(out)
  }

}