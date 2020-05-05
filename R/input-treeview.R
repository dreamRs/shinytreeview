
#' @title Tree view Input
#'
#' @description Represent hierarchical tree structures to select a value in a nested list.
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param choices A \code{list} to be used as choices.
#' @param selected Default selected value.
#' @param multiple Allow selection of multiple values.
#' @param levels Sets the number of hierarchical levels deep the tree will be expanded to by default.
#' @param borders Show or not borders around items.
#' @param prevent_unselect When \code{multiple = TRUE}, prevent user to unselect a value.
#' @param return_value Value returned server-side, default is the element name,
#'  other possibility is to returned all the tree under the element selected.
#' @param width The width of the input, e.g. \code{'400px'}, or \code{'100\%'}.
#'
#' @return A \code{character} value or a \code{list} depending on the \code{return_value} argument.
#' @export
#'
#' @importFrom htmltools tags validateCssUnit
#' @importFrom jsonlite toJSON
#'
#' @example examples/basic.R
treeviewInput <- function(inputId,
                          label = NULL,
                          choices,
                          selected = NULL,
                          multiple = FALSE,
                          levels = 1,
                          borders = TRUE,
                          prevent_unselect = FALSE,
                          return_value = c("name", "all"),
                          width = NULL) {
  return_value <- match.arg(return_value)
  options <- dropNulls(list(
    config = list(
      data = choices,
      multiSelect = multiple,
      preventUnselect = prevent_unselect,
      levels = levels,
      showBorder = borders
    ),
    selected = list1(selected)
  ))

  tags$div(
    class = "form-group shiny-input-container",
    style = if(!is.null(width)) paste("width:", validateCssUnit(width)),
    if (!is.null(label)) {
      tags$label(class = "control-label", `for` = inputId, label)
    },
    tags$div(
      id = inputId, class = "treeview-input",
      `data-return` = return_value,
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

