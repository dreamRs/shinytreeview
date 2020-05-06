
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
    pattern = pattern,
    collapse = collapse_before,
    options = list(
      ignoreCase = ignore_case,
      exactMatch = exact_match,
      revealResults = reveal_results
    )
  ))
  session$sendInputMessage(inputId, message)
}

