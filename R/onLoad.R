#' Adds the content of www to shinyWidgets/
#'
#' @importFrom shiny addResourcePath
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath("shinytreeview", system.file("assets", package = "shinytreeview"))
}
