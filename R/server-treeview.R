
#' @title Manipulate a tree server-side
#'
#' @description Interact with a tree contructed with [treeviewInput()] or [treecheckInput()] from the server.
#'
#' @param inputId The id of the input object.
#' @param pattern Pattern to search for.
#' @param ignore_case Case insensitive.
#' @param exact_match Like or equals.
#' @param reveal_results Reveal matching nodes.
#' @param collapse_before Collapse all nodes before revealing results.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return No value, side-effects only.
#' @export
#'
#' @name tree-server
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


#' @export
#'
#' @rdname tree-server
clearSearchTreeview <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  message <- list(clearSearch = list(clearSearch = TRUE))
  session$sendInputMessage(inputId, message)
}


#' @param nodeId Id of the node to expand or collapse,
#'  use `input$<inputId>_nodes` to see the Ids.
#'  If `NULL` expand the all tree.
#' @param levels Levels to expand.
#'
#' @export
#'
#' @rdname tree-server
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
#' @rdname tree-server
collapseTreeview <- function(inputId,
                             nodeId = NULL,
                             session = shiny::getDefaultReactiveDomain()) {
  message <- list(collapse = dropNulls(list(
    nodeId = nodeId
  )))
  session$sendInputMessage(inputId, message)
}


#' @inheritParams treeviewInput
#' @export
#' @rdname tree-server
#'
#' @example examples/update.R
updateTreeview <- function(inputId,
                           label = NULL,
                           selected = NULL,
                           session = shiny::getDefaultReactiveDomain()) {
  session$sendInputMessage(inputId, dropNulls(list(label = label, selected = list1(selected))))
}




