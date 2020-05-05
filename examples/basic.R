
# Basic treeviewInput example ---------------------------------------------

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
  list(text = "Parent 2", state = list(selected = TRUE)),
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
  tags$h3("shinytreeview basic example"),
  treeviewInput(
    inputId = "tree", label = "Make a choice:",
    choices = choices
  ),
  verbatimTextOutput(outputId = "result")
)

server <- function(input, output, session) {
  output$result <- renderPrint({
    input$tree
  })
}

shinyApp(ui, server)


