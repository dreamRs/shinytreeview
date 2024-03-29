% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-treeview.R
\name{treeviewInput}
\alias{treeviewInput}
\title{Tree view Input}
\usage{
treeviewInput(
  inputId,
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
  width = NULL
)
}
\arguments{
\item{inputId}{The \code{input} slot that will be used to access the value.}

\item{label}{Display label for the control, or \code{NULL} for no label.}

\item{choices}{A \code{list} to be used as choices, can be created with \code{\link[=make_tree]{make_tree()}}.}

\item{selected}{Default selected value, must correspond to the Id of the node.}

\item{multiple}{Allow selection of multiple values.}

\item{levels}{Sets the number of hierarchical levels deep the tree will be expanded to by default.}

\item{borders}{Show or not borders around items.}

\item{prevent_unselect}{When \code{multiple = TRUE}, prevent user to unselect a value.}

\item{...}{Others parameters passed to JavaScript treeview method.}

\item{nodes_input}{Send nodes data through an input value : \verb{input$<inputId>_nodes}.}

\item{return_value}{Value returned server-side, default is the element name,
other possibilities are \code{"id"} (works only if nodes have an id) or
\code{"all"} to returned all the tree under the element selected.}

\item{width}{The width of the input, e.g. \code{'400px'}, or \code{'100\%'}.}
}
\value{
Server-side: A \code{character} value or a \code{list} depending on the \code{return_value} argument.
}
\description{
Represent hierarchical tree structures to select a value in a nested list.
}
\examples{
# Basic treeviewInput example --------------------------

library(shiny)
library(shinytreeview)

choices <- list(
  list(
    text = "Parent 1",
    nodes = list(
      list(text = "Child 1.1"),
      list(text = "Child 1.2")
    )
  ),
  list(text = "Parent 2"),
  list(text = "Parent 3"),
  list(
    text = "Parent 4",
    nodes = list(
      list(text = "Child 4.1"),
      list(text = "Child 4.2")
    )
  ),
  list(text = "Parent 5")
)


ui <- fluidPage(
  tags$h3("treeviewInput basic example"),
  treeviewInput(
    inputId = "tree", label = "Make a choice:",
    choices = choices, selected = "Parent 3",
    multiple = FALSE, prevent_unselect = TRUE
  ),
  verbatimTextOutput(outputId = "result")
)

server <- function(input, output, session) {
  output$result <- renderPrint({
    input$tree
  })
}

if (interactive())
  shinyApp(ui, server)


}
\seealso{
\code{\link[=updateTreeview]{updateTreeview()}} and others functions to manipulate tree server-side.
}
