
#' Tree check Input
#'
#' @inheritParams treeviewInput
#' @param hierarchical When a level is selected, also select all levels below it?
#'
#' @return Server-side: A `character` value or a `list` depending on the `return_value` argument.
#' @export
#'
#' @seealso [updateTreeview()] and others functions to manipulate tree server-side.
#'
#' @importFrom htmltools tags validateCssUnit htmlDependencies HTML
#' @importFrom shiny icon restoreInput
#' @importFrom jsonlite toJSON
#'
#' @example examples/treecheck.R
treecheckInput <- function(inputId,
                           label = NULL,
                           choices,
                           selected = NULL,
                           hierarchical = TRUE,
                           levels = 1,
                           borders = TRUE,
                           ...,
                           nodes_input = FALSE,
                           return_value = c("name", "id", "all"),
                           width = NULL) {
  selected <- shiny::restoreInput(id = inputId, default = selected)
  return_value <- match.arg(return_value)
  config <- list(
    data = choices,
    levels = levels,
    showBorder = borders,
    showCheckbox = TRUE,
    highlightSelected = FALSE,
    propagateCheckEvent = hierarchical,
    hierarchicalCheck = hierarchical,
    uncheckedIcon = "ph-square ph-light ph-shinytreeview",
    partiallyCheckedIcon = "ph-square-logo ph-light ph-shinytreeview",
    checkedIcon = "ph-check-square ph-light ph-shinytreeview",
    expandIcon = "ph-caret-right ph-light ph-shinytreeview",
    collapseIcon = "ph-caret-down ph-light ph-shinytreeview",
    ...
  )
  options <- dropNulls(list(
    config = config[!duplicated(names(config), fromLast = TRUE)],
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
      id = inputId, class = "treecheck-input",
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
