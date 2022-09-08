


# updateTreeview ----------------------------------------------------------


library(shiny)
library(shinytreeview)

data("cities")

ui <- fluidPage(
  tags$h3("Update label & selected value"),
  treeviewInput(
    inputId = "tree",
    label = "Choose a city:",
    choices = make_tree(cities, c("continent", "country", "city")),
    multiple = FALSE,
    prevent_unselect = TRUE
  ),
  verbatimTextOutput(outputId = "result"),
  textInput("label", "New label:", "Choose a city:"),
  radioButtons(
    "selected", "Selected:",
    choices = unique(c(cities$continent, cities$country, cities$city)),
    inline = TRUE
  )
)

server <- function(input, output, session) {
  output$result <- renderPrint({
    input$tree
  })
  observe(updateTreeview(inputId = "tree", label = input$label))
  observe(updateTreeview(inputId = "tree", selected = input$selected))
}

if (interactive())
  shinyApp(ui, server)
