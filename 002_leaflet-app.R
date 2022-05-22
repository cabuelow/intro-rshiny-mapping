library(shiny)
library(sf)
library(dplyr)
library(leaflet)

# load data

pop <- st_read('data/population.gpkg')
reefs <- st_read('data/reefs.gpkg')

# pop-ups

pop_up <- st_drop_geometry(pop) %>% 
  mutate(popup = paste0("<span style='font-size: 120%'><strong>", NAME ,"</strong></span><br/>",
                        "<strong>", "Country: ", "</strong>", SOV0NAME, 
                        "<br/>", 
                        "<strong>", "Max population size: ", "</strong>", POP_MAX)) %>% 
  pull(popup)

# user-interface 

ui <- fillPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  absolutePanel(top = 10, right = 10,
    selectInput('country', 'Country',
                choices = c('No country selected', sort(unique(st_drop_geometry(pop)$SOV0NAME))),
                selected = NULL)),
  
  leafletOutput("map", width = '100%', height = '100%')
  
  ) # end page

# server

server <- function(input, output, session) {
 
  # map 
  
  output$map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(data = pop, 
                       weight = 0.1,
                       radius = ~log(as.numeric(pop$POP_MAX)/1e5),
                       popup = pop_up) %>% 
      addPolygons(data = reefs, 
                  weight = 0.7, 
                  color = 'red')
  }) # end render leaflet
  
  # reactive expression
  
  pop2 <- reactive({
      pop %>% filter(SOV0NAME == input$country)
  }) # end reactive expression
  
  # updated map based on user inputs
  
  observe({
    d <- pop2()  
    bounds <- unname(st_bbox(st_buffer(d, 1)))
  
    leafletProxy('map') %>% 
      flyToBounds(bounds[1], bounds[2], bounds[3], bounds[4])
  }) # end observe
  
} # end server

shinyApp(ui, server)
