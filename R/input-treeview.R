
#' @title Tree view Input
#'
#' @description Represent hierarchical tree structures to select a value in a nested list.
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param choices A \code{list} to be used as choices, can be created with \code{\link{make_tree}}.
#' @param selected Default selected value, must correspond to the Id of the node.
#' @param multiple Allow selection of multiple values.
#' @param levels Sets the number of hierarchical levels deep the tree will be expanded to by default.
#' @param borders Show or not borders around items.
#' @param prevent_unselect When \code{multiple = TRUE}, prevent user to unselect a value.
#' @param ... Others parameters passed to JavaScript treeview method.
#' @param return_value Value returned server-side, default is the element name,
#'  other possibilities are \code{"id"} (works only if nodes have an id) or
#'  \code{"all"} to returned all the tree under the element selected.
#' @param width The width of the input, e.g. \code{'400px'}, or \code{'100\%'}.
#'
#' @return Server-side: A \code{character} value or a \code{list} depending on the \code{return_value} argument.
#' @export
#'
#' @importFrom htmltools tags validateCssUnit
#' @importFrom jsonlite toJSON
#' @importFrom shiny restoreInput
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
                          ...,
                          return_value = c("name", "id", "all"),
                          width = NULL) {
  selected <- shiny::restoreInput(id = inputId, default = selected)
  return_value <- match.arg(return_value)
  options <- dropNulls(list(
    config = c(
      list(
        data = choices,
        multiSelect = multiple,
        preventUnselect = prevent_unselect,
        levels = levels,
        showBorder = borders
      ),
      list(...)
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








#' Create choice structure for \code{treeviewInput}
#'
#' @param data A \code{data.frame}.
#' @param levels Variables identifying hierarchical levels.
#' @param selected Default selected value(s).
#' @param ... Named arguments with \code{list} of attributes
#'  to apply to a certain level. Names must be the same as the \code{levels}.
#'  Full list of attributes is available at the following URL :
#'  \url{https://github.com/patternfly/patternfly-bootstrap-treeview#node-properties}.
#'
#' @return a \code{list} that can be used in \code{\link{treeviewInput}}.
#' @export
#'
#' @example examples/make_tree.R
make_tree <- function(data, levels, selected = NULL, ...) {
  args <- list(...)
  data <- as.data.frame(data)
  if (!all(levels %in% names(data)))
    stop("All levels must be valid variables in data", call. = FALSE)
  data[levels] <- lapply(data[levels], as.character)
  data <- unique(x = data)
  lapply(
    X = unique(data[[levels[1]]][!is.na(data[[levels[1]]])]),
    FUN = function(var) {
      dat <- data[data[[levels[1]]] == var, , drop = FALSE]
      args_level <- args[[levels[1]]]
      if (!is.null(selected)) {
        if (var %in% selected) {
          args_level$state$selected <- TRUE
        }
      }
      if (length(levels) == 1) {
        c(list(text = var), args_level)
      } else {
        c(
          list(
            text = var,
            nodes = make_tree(
              data = dat,
              levels = levels[-1],
              selected = selected,
              ...
            )
          ),
          args_level
        )
      }
    }
  )
}












