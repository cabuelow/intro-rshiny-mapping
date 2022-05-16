library(shiny)
library(mapdeck)
library(sf)
library(tmap)
data('World')

# load data

basins <- st_read('data/hydrobasins_lev07_aus.gpkg')

#key <- "pk.eyJ1IjoidXRqaW1teXgiLCJhIjoiY2tnMmI1OWRpMDZsdDJxb2Y4MjdnZmxpMyJ9.ImwwUvDQpod7-B0YnIUytw"  
key <- 'pk.eyJ1IjoiY2hyaXN0aW5hYnVlbG93IiwiYSI6ImNreHNqYjJtODMxbHcybnBuejVpOXl2YnYifQ.vX0OuLpDzU1vSWKs-L4Nhw'
mapdeck(token = key) %>%
  add_polygon(
    data = basins
    , layer = "polygon_layer"
    #, fill_colour = "SA2_NAME16"
  )

library(sf)
library(geojsonsf)

sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
sf$e <- sf$AREASQKM16 * 10

mapdeck(token = key, style = mapdeck_style("dark")) %>%
  add_polygon(
    data = sf[ data.table::`%like%`(sf$SA4_NAME16, "Melbourne"), ]
    , layer = "polygon_layer"
    , fill_colour = "SA2_NAME16"
    , elevation = "e"
  )

ui <- fluidPage(
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)