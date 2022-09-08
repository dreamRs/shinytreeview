


# expand/collapse ---------------------------------------------------------


library(shiny)
library(shinytreeview)

data("countries")

ui <- fluidPage(
  tags$h3("treeviewInput expand/collapse example"),
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
      actionButton("expandAll", "Expand all"),
      actionButton("expandWAfrica", "Expand Western Africa"),
      actionButton("collapseAll", "Collapse all"),
      tags$br(),
      tags$b("Selected country:"),
      verbatimTextOutput(outputId = "result")
    )
  )
)

server <- function(input, output, session) {

  output$result <- renderPrint({
    input$country
  })

  observeEvent(input$expandAll, {
    expandTreeview("country", levels = 3)
  })

  observeEvent(input$expandWAfrica, {
    nodes <- input$country_nodes
    w_africa <- nodes[nodes$text == "Western Africa", "nodeId"]
    print(w_africa)
    expandTreeview("country", nodeId = w_africa, levels = 3)
  })

  observeEvent(input$collapseAll, {
    collapseTreeview("country")
  })
}

if (interactive())
  shinyApp(ui, server)
