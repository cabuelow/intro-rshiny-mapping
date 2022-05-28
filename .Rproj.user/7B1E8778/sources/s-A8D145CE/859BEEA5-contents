library(tmap)
library(shiny)
data('World')

ui <- fluidPage(
  tmapOutput('map')
)

server <- function(input, output, session) {
  output$map <- renderTmap({
    qtm(World, 'name')
  })
}

shinyApp(ui, server)
