library(shinytreeview)

data("cities")
head(cities)

# Create choices that can be used in treeviewInput
make_tree(cities, c("continent", "country", "city"))

# Custom attributes for continent level
make_tree(cities, c("continent", "country", "city"), continent = list(selectable = FALSE))




library(shiny)
ui <- fluidPage(
  tags$h3("treeviewInput cities example"),
  fluidRow(
    column(
      width = 6,
      treeviewInput(
        inputId = "tree1",
        label = "Choose an area:",
        choices = make_tree(cities, c("continent", "country", "city")),
        multiple = FALSE,
        prevent_unselect = TRUE
      ),
      verbatimTextOutput(outputId = "result1")
    ),
    column(
      width = 6,
      treeviewInput(
        inputId = "tree2",
        label = "Choose an area (continent not selectable):",
        choices = make_tree(
          cities, c("continent", "country", "city"),
          continent = list(selectable = FALSE)
        ),
        multiple = FALSE,
        prevent_unselect = TRUE
      ),
      verbatimTextOutput(outputId = "result2")
    )
  )
)

server <- function(input, output, session) {
  output$result1 <- renderPrint({
    input$tree1
  })
  output$result2 <- renderPrint({
    input$tree2
  })
}

if (interactive())
  shinyApp(ui, server)
