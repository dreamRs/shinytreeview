% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/server-treeview.R
\name{searchTreeview}
\alias{searchTreeview}
\title{Search a \code{treeviewInput}}
\usage{
searchTreeview(
  inputId,
  pattern,
  ignore_case = TRUE,
  exact_match = FALSE,
  reveal_results = TRUE,
  collapse_before = TRUE,
  session = shiny::getDefaultReactiveDomain()
)
}
\arguments{
\item{inputId}{The id of the input object.}

\item{pattern}{Pattern to search for.}

\item{ignore_case}{Case insensitive.}

\item{exact_match}{Like or equals.}

\item{reveal_results}{Reveal matching nodes.}

\item{collapse_before}{Collapse all nodes before revealing results.}

\item{session}{The session object passed to function given to shinyServer.}
}
\value{
None.
}
\description{
Search a \code{treeviewInput}
}
\examples{

library(shiny)
library(shinytreeview)

data("countries")

ui <- fluidPage(
  tags$h3("treeviewInput search example"),
  fluidRow(
    column(
      width = 4,
      treeviewInput(
        inputId = "country",
        label = "Choose a country:",
        choices = make_tree(
          countries, c("continent", "subregion", "name")
        ),
        width = "100\%"
      )
    ),
    column(
      width = 8,
      textInput("search", "Search a country"),
      tags$b("Selected country:"),
      verbatimTextOutput(outputId = "result")
    )
  )
)

server <- function(input, output, session) {
  output$result <- renderPrint({
    input$country
  })

  observeEvent(input$search, {
    searchTreeview(
      inputId = "country",
      pattern = input$search,
      reveal_results = TRUE
    )
  })
}

if (interactive())
  shinyApp(ui, server)
}
