
#' Search a \code{treeviewInput}
#'
#' @param inputId The id of the input object.
#' @param pattern Pattern to search for.
#' @param ignore_case Case insensitive.
#' @param exact_match Like or equals.
#' @param reveal_results Reveal matching nodes.
#' @param collapse_before Collapse all nodes before revealing results.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return None.
#' @export
#'
#' @example examples/search.R
searchTreeview <- function(inputId,
                           pattern,
                           ignore_case = TRUE,
                           exact_match = FALSE,
                           reveal_results = TRUE,
                           collapse_before = TRUE,
                           session = shiny::getDefaultReactiveDomain()) {
  message <- list(search = list(
    pattern = list1(pattern),
    collapse = collapse_before,
    options = list(
      ignoreCase = ignore_case,
      exactMatch = exact_match,
      revealResults = reveal_results
    )
  ))
  session$sendInputMessage(inputId, message)
}



#' Expand or collapse a \code{treeviewInput}
#'
#' @param inputId The id of the input object.
#' @param nodeId Id of the node to expand or collapse,
#'  use \code{input$<inputId>_nodes} to see the Ids.
#'  If \code{NULL} expand the all tree.
#' @param levels Levels to expand.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return None.
#' @export
#'
#' @name expand-collapse
#'
#' @example examples/collapse-expand.R
expandTreeview <- function(inputId,
                           nodeId = NULL,
                           levels = 1,
                           session = shiny::getDefaultReactiveDomain()) {
  message <- list(expand = dropNulls(list(
    nodeId = nodeId,
    options = list(
      levels = levels
    )
  )))
  session$sendInputMessage(inputId, message)
}

#' @export
#' @rdname expand-collapse
collapseTreeview <- function(inputId,
                             nodeId = NULL,
                             session = shiny::getDefaultReactiveDomain()) {
  message <- list(collapse = dropNulls(list(
    nodeId = nodeId
  )))
  session$sendInputMessage(inputId, message)
}







