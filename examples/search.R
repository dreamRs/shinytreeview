# searchTreeview ----------------------------------------------------------


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
        width = "100%"
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
