library(sf)
library(dplyr)
library(leaflet) # javascript library for interactive maps

# make an interactive leaflet map

m <- leaflet() %>% 
  addTiles()
m

# read in spatial data

pop <- st_read('data/population.gpkg')
reefs <- st_read('data/reefs.gpkg')

# make interactive leaflet map

m <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = pop, 
                   weight = 0.1,
                   radius = ~log(as.numeric(pop$POP_MAX)/1e5)) %>% 
  addPolygons(data = reefs, 
              weight = 0.7, 
              color = 'red')
m

# add some pop-ups

pop_up <- st_drop_geometry(pop) %>% 
  mutate(popup = paste0("<span style='font-size: 120%'><strong>", NAME ,"</strong></span><br/>",
                        "<strong>", "Country: ", "</strong>", SOV0NAME, 
                        "<br/>", 
                        "<strong>", "Max population size: ", "</strong>", POP_MAX)) %>% 
  pull(popup)

m <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = pop, 
                   weight = 0.1,
                   radius = ~log(as.numeric(pop$POP_MAX)/1e5),
                   popup = pop_up) %>% 
  addPolygons(data = reefs, 
              weight = 0.7, 
              color = 'red')
m
