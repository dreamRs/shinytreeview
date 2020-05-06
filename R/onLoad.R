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
      return(unlist(lapply(data, `[[`, "text")))
    }
  }, force = TRUE)
  shiny::registerInputHandler("treeview.all", function(data, ...) {
    if (is.null(data)) {
      NULL
    } else {
      return(data)
    }
  }, force = TRUE)
  shiny::registerInputHandler("treeview.nodes", function(data, ...) {
    if (is.null(data)) {
      NULL
    } else {
      tryCatch({
        do.call("rbind", lapply(data, function(x) {
          x <- as.data.frame(x, stringsAsFactors = FALSE)
          if (is.null(x$parentId))
            x$parentId <- NA_character_
          x
        }))
      }, error = function(e) {
        warning("shinytreeview error: ", e$message)
        data.frame(
          text = character(0),
          nodeId = character(0),
          parentId = character(0),
          stringsAsFactors = FALSE
        )
      })
    }
  }, force = TRUE)
}
