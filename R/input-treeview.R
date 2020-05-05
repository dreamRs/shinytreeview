
#' Title
#'
#' @param inputId
#' @param label
#' @param choices
#' @param width
#'
#' @return
#' @export
#'
#' @examples
treeviewInput <- function(inputId, label = NULL, choices, width = NULL) {

  options <- list(
    data = choices
  )

  tags$div(
    class = "form-group shiny-input-container",
    style = if(!is.null(width)) paste("width:", validateCssUnit(width)),
    if (!is.null(label)) {
      tags$label(class = "control-label", `for` = inputId, label)
    },
    tags$div(
      id = inputId, class = "treeview-input",
      tags$script(
        type = "application/json", `data-for` = inputId,
        jsonlite::toJSON(options, auto_unbox = TRUE, json_verbatim = TRUE)
      )
    ),
    html_dependency_treeview()
  )
}



#' @importFrom htmltools htmlDependency
html_dependency_treeview <- function() {
  htmltools::htmlDependency(
    name = "bootstrap-treeview",
    version = "2.1.7",
    src = c(href = "shinytreeview/bootstrap-treeview"),
    script = c("bootstrap-treeview.min.js", "treeview-bindings.js"),
    stylesheet = "bootstrap-treeview.min.css",
    all_files = FALSE
  )
}

