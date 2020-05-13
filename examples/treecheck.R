
library(shiny)
library(shinytreeview)

data("cities")

ui <- fluidPage(
  tags$h3("treeviewInput cities example"),
  treecheckInput(
    inputId = "tree",
    label = "Choose a city:",
    choices = make_tree(
      cities, c("continent", "country", "city")
    )
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
