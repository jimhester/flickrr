the <- new.env(parent = emptyenv())

the$url <- "https://api.flickr.com/services/rest"
the$key <- "ed724990662ac2b8c236726a34226ea9"
the$secret <- "6f53c97ac97a0d78"

#' Authenticate a session
#'
#' This will spawn a browser window to allow the user to accept the
#' authentication.
#' @param permission The desired permission for the session.
#' @param key The API key, a default one is provided, but please register a new
#'   one yourself if you will be doing many requests.
#' @param secret The API secret.
#' @export
authenticate <- function(permission = c("read", "write", "delete"),
                         key = the$key, secret = the$secret) {

  permission <- match.arg(permission)

  app <- httr::oauth_app("R to flickr", key, secret)

  endpoint <- httr::oauth_endpoint(
    request = "https://www.flickr.com/services/oauth/request_token",
    authorize = "https://www.flickr.com/services/oauth/authorize",
    access = "https://www.flickr.com/services/oauth/access_token")

  the$token <- httr::oauth1.0_token(endpoint, app)
  invisible()
}

flickr_VERB <- function(verb) {
  function(method, ...) {
    if (is.null(the$token)) {
      stop("First authenticate with `authenticate()`", call. = FALSE)
    }

    query <- list(...)

    signature <- httr::oauth_signature(the$url,
      method = verb,
      app = the$token$app,
      token = the$token$credentials$oauth_token,
      token_secret = the$token$credentials$oauth_token_secret,
      other_params = c(list(method = method, format = "json", "nojsoncallback" = 1), query))

    response <- httr::VERB(verb, the$url, query = signature, query = query)

    heads <- httr::headers(response)

    if (httr::status_code(response) >= 300) {
      cond <- structure(list(
          call = sys.call(-1),
          content = httr::content(response),
          headers = httr::headers(response),
          message = paste0("flickr API error:", heads$status)),
        class = c("condition", "error"))
      stop(cond)
    }
    httr::content(response)
  }
}

#' Perform a flickr request
#'
#' \code{flickr_GET} performs a GET request, \code{flickr_POST} performs a POST
#' request. Use \code{\link{authenticate}} to authenticate your session prior
#' to connecting.
#' @param method The flickr API method to use \url{https://www.flickr.com/services/api/}.
#' @param ... additional arguments passed to \code{\link[httr]{VERB}}.
#' @rdname flickr_request
#' @examples
#' \dontrun{
#' flickr_GET("flickr.photo.search", text = "UseR2016")
#' }
#' @export
flickr_GET <- flickr_VERB("GET")

#' @rdname flickr_request
#' @export
flickr_POST <- flickr_VERB("POST")
