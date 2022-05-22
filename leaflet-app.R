library(shiny)
library(sf)
library(dplyr)
library(leaflet)
library(rnaturalearth)

# load data

pop <- st_as_sf(ne_download(scale = 50, type = 'populated_places', category = 'cultural'))
reefs <- st_as_sf(ne_download(scale = 10, type = 'reefs', category = 'physical')) %>% filter(featurecla == 'Reefs')

# pop-ups

pop_up <- st_drop_geometry(pop) %>% 
  select(NAME, SOV0NAME, POP_MAX) %>% 
  mutate(popup = paste0("<span style='font-size: 120%'><strong>", NAME ,"</strong></span><br/>",
                        "<strong>", "Country: ", "</strong>", SOV0NAME, 
                        "<br/>", 
                        "<strong>", "Max population size: ", "</strong>", POP_MAX)) %>% 
  pull(popup)

# variable to zoom to country

country <- sort(unique(st_drop_geometry(pop)$SOV0NAME))

# user-interface 

ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),

  leafletOutput("map", width = '100%', height = '100%'),
  
  absolutePanel(top = 10, right = 10,
    selectInput('country', 'Country',
                choices = c('Global', country),
                selected = 'Global'))
  ) # end bootstrap page

# server

server <- function(input, output, session) {
  
  # reactive expression
  
  filt_pop <- reactive({
    if(input$country != 'Global'){
    pop %>% filter(SOV0NAME == input$country)
    }else{
      pop
    }
  }) # end reactive expression
  
  # map 
  
  output$map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(data = pop, 
                       weight = 0.1,
                       radius = ~log(as.numeric(pop$POP_MAX)/1e3),
                       popup = pop_up) %>% 
      addPolygons(data = reefs, 
                  weight = 0.7, 
                  color = 'red')
    }) # end render leaflet
  
  # updated map based on user inputs
  
  observe({
  
  d <- filt_pop()  
  bounds <- unname(st_bbox(d))
  
    leafletProxy('map') %>% 
      flyToBounds(bounds[1], bounds[2], bounds[3], bounds[4])
  }) # end observe
  
} # end server

shinyApp(ui, server)