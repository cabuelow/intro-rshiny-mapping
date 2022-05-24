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
  
  absolutePanel(top = 10, right = 10,
  selectInput('country', 'Country',
                choices = c('Global', sort(unique(st_drop_geometry(pop)$SOV0NAME))),
                selected = NULL)
  ),# end absolute panel
  
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
  
  # updated map based on user inputs
  
  observe({
    if(input$country == 'Global'){
      bounds <- unname(st_bbox(pop))
      leafletProxy('map') %>% 
        flyToBounds(bounds[1], bounds[2], bounds[3], bounds[4])
    }else{
      bounds <- unname(st_bbox(st_buffer((pop %>% filter(SOV0NAME == input$country)), 1)))
      leafletProxy('map') %>% 
        flyToBounds(bounds[1], bounds[2], bounds[3], bounds[4])
    }
  }) # end observe
  
} # end server

shinyApp(ui, server)
