
#' Tree check Input
#'
#' @inheritParams treeviewInput
#' @param hierarchical When a level is selected, also select all levels below it?
#'
#' @return Server-side: A \code{character} value or a \code{list} depending on the \code{return_value} argument.
#' @export
#'
#' @importFrom htmltools tags validateCssUnit htmlDependencies
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
                           return_value = c("name", "id", "all"),
                           width = NULL) {
  selected <- shiny::restoreInput(id = inputId, default = selected)
  return_value <- match.arg(return_value)
  options <- dropNulls(list(
    config = c(
      list(
        data = choices,
        levels = levels,
        showBorder = borders,
        showCheckbox = TRUE,
        highlightSelected = FALSE,
        propagateCheckEvent = hierarchical,
        hierarchicalCheck = hierarchical,
        uncheckedIcon = "fa fa-square-o",
        partiallyCheckedIcon = "fa fa-minus-square-o",
        checkedIcon = "fa fa-check-square-o",
        expandIcon = "fa fa-chevron-right",
        collapseIcon = "fa fa-chevron-down"
      )
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
      id = inputId, class = "treecheck-input",
      `data-return` = return_value,
      tags$script(
        type = "application/json", `data-for` = inputId,
        jsonlite::toJSON(options, auto_unbox = TRUE, json_verbatim = TRUE)
      )
    ),
    html_dependency_treeview(),
    htmlDependencies(icon("home"))
  )
}
