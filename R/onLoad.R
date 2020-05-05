#' Adds the content of assets/ to shinytreeview/
#'
#' @importFrom shiny addResourcePath registerInputHandler
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath("shinytreeview", system.file("assets", package = "shinytreeview"))
  shiny::registerInputHandler("treeview.name", function(data, ...) {
    if (is.null(data) || length(data) < 1) {
      NULL
    } else {
      return(data[[1]]$text)
    }
  }, force = TRUE)
  shiny::registerInputHandler("treeview.all", function(data, ...) {
    if (is.null(data)) {
      NULL
    } else {
      return(data)
    }
  }, force = TRUE)
}
