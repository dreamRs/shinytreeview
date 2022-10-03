
#' @title Tree view Input
#'
#' @description Represent hierarchical tree structures to select a value in a nested list.
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param choices A \code{list} to be used as choices, can be created with [make_tree()].
#' @param selected Default selected value, must correspond to the Id of the node.
#' @param multiple Allow selection of multiple values.
#' @param levels Sets the number of hierarchical levels deep the tree will be expanded to by default.
#' @param borders Show or not borders around items.
#' @param prevent_unselect When \code{multiple = TRUE}, prevent user to unselect a value.
#' @param ... Others parameters passed to JavaScript treeview method.
#' @param nodes_input Send nodes data through an input value : `input$<inputId>_nodes`.
#' @param return_value Value returned server-side, default is the element name,
#'  other possibilities are \code{"id"} (works only if nodes have an id) or
#'  \code{"all"} to returned all the tree under the element selected.
#' @param width The width of the input, e.g. \code{'400px'}, or \code{'100\%'}.
#'
#' @return Server-side: A \code{character} value or a \code{list} depending on the \code{return_value} argument.
#' @export
#'
#' @seealso [updateTreeview()] and others functions to manipulate tree server-side.
#'
#' @importFrom htmltools tags validateCssUnit HTML
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
                          nodes_input = FALSE,
                          return_value = c("name", "id", "all"),
                          width = NULL) {
  selected <- shiny::restoreInput(id = inputId, default = selected)
  return_value <- match.arg(return_value)
  if (!isTRUE(multiple) && length(selected) > 1) {
    warning("Multiple selected values used but multiple = FALSE, only first one will be selected.")
    selected <- selected[1]
  }
  config <- list(
    data = choices,
    multiSelect = multiple,
    preventUnselect = prevent_unselect,
    levels = levels,
    showBorder = borders,
    expandIcon = "ph-plus-light ph-shinytreeview",
    collapseIcon = "ph-minus-light ph-shinytreeview",
    ...
  )
  options <- dropNulls(list(
    config = config,
    selected = list1(selected),
    nodes_input = nodes_input
  ))

  tags$div(
    class = "form-group shiny-input-container",
    style = if (!is.null(width)) paste("width:", validateCssUnit(width)),
    tags$label(
      id = paste0(inputId, "-label"),
      class = "control-label",
      class = if (is.null(label)) "shiny-label-null",
      `for` = inputId,
      label
    ),
    tags$div(
      id = inputId, class = "treeview-input",
      `data-return` = return_value,
      tags$script(
        type = "application/json", `data-for` = inputId,
        HTML(jsonlite::toJSON(options, auto_unbox = TRUE, json_verbatim = TRUE))
      )
    ),
    html_dependency_treeview(),
    phosphoricons::html_dependency_phosphor()
  )
}



#' @importFrom htmltools htmlDependency
#' @importFrom utils packageVersion
html_dependency_treeview <- function() {
  htmlDependency(
    name = "bootstrap-treeview",
    version = packageVersion("shinytreeview"),
    src = list(file = "packer"),
    package = "shinytreeview",
    script = "treeview.js"
  )
}







#' Create choice structure for [treeviewInput()]
#'
#' @param data A `data.frame`.
#' @param levels Variables identifying hierarchical levels,
#'  values of those variables will be used as text displayed.
#' @param selected Default selected value(s).
#' @param levels_id Variable to use as ID, thos values wont't
#'  be displayed but can be retrieved server-side with `return_value = "id"`.
#' @param ... Named arguments with `list` of attributes
#'  to apply to a certain level. Names must be the same as the `levels`.
#'  See
#'  [full list of attributes](https://github.com/patternfly/patternfly-bootstrap-treeview#node-properties).
#'
#' @return a \code{list} that can be used in [treeviewInput()] or [treecheckInput()].
#' @export
#'
#' @example examples/make_tree.R
make_tree <- function(data, levels, selected = NULL, levels_id = NULL, ...) {
  args <- list(...)
  data <- as.data.frame(data)
  if (!all(levels %in% names(data)))
    stop("All levels must be valid variables in data", call. = FALSE)
  data[levels] <- lapply(data[levels], as.character)
  data <- unique(x = data)
  if (is.null(levels_id)) {
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
  } else {
    stopifnot(
      "levels and levels_id must be of same length" = length(levels) == length(levels_id)
    )
    if (!all(levels_id %in% names(data)))
      stop("All levels_id must be valid variables in data", call. = FALSE)
    mapply(
      SIMPLIFY = FALSE,
      USE.NAMES = FALSE,
      text = unique(data[[levels[1]]][!is.na(data[[levels[1]]])]),
      id = unique(data[[levels_id[1]]][!is.na(data[[levels_id[1]]])]),
      FUN = function(text, id) {
        dat <- data[data[[levels[1]]] == text, , drop = FALSE]
        args_level <- args[[levels[1]]]
        if (!is.null(selected)) {
          if (text %in% selected) {
            args_level$state$selected <- TRUE
          }
        }
        if (length(levels) == 1) {
          c(list(text = text, id = id), args_level)
        } else {
          c(
            list(
              text = text,
              id = id,
              nodes = make_tree(
                data = dat,
                levels = levels[-1],
                levels_id = levels_id[-1],
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
}












