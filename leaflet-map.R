library(sf)
library(dplyr)
library(leaflet) # javascript library for interactive maps
library(rnaturalearth)

# make an interactive leaflet map

m <- leaflet() %>% 
  addTiles()
m

# where are people and reefs?

pop <- st_as_sf(ne_download(scale = 50, type = 'populated_places', category = 'cultural'))
reefs <- st_as_sf(ne_download(scale = 10, type = 'reefs', category = 'physical')) %>% filter(featurecla == 'Reefs')

m <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = pop, 
                   weight = 0.1,
                   radius = ~log(as.numeric(pop$POP_MAX)/1e3)) %>% 
  addPolygons(data = reefs, 
              weight = 0.7, 
              color = 'red')
m

# add some pop-ups

pop_up <- st_drop_geometry(pop) %>% 
  select(NAME, SOV0NAME, POP_MAX) %>% 
  mutate(popup = paste0("<span style='font-size: 120%'><strong>", NAME ,"</strong></span><br/>",
                        "<strong>", "Country: ", "</strong>", SOV0NAME, 
                        "<br/>", 
                        "<strong>", "Max population size: ", "</strong>", POP_MAX)) %>% 
  pull(popup)

m <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = pop, 
                   weight = 0.1,
                   radius = ~log(as.numeric(pop$POP_MAX)/1e3),
                   popup = pop_up) %>% 
  addPolygons(data = reefs, 
              weight = 0.7, 
              color = 'red')
m
