### Mapping interactively with RShiny

##### RLadies Brisbane
##### May 26, 2022

#### Aims

1. To show how Rshiny can open our science to end-users by allowing them to engage interactively with research outputs in web applications.

2. To provide an overview of the pros and cons of different R packages available for making interactive maps.

3. To learn how to make a basic interactive map and tips for speeding up when using large datasets.

#### Required R packages

Please install the following R packages and their dependencies:

`install.packages(c('shiny', 'leaflet', 'sf', 'tmap', 'dplyr'))`

***Note** that installing spatial packages (e.g. `sf`) can be challenging on macs with an M1 chip and the Monterey OS*

#### Repository contents

1. Presentation slides for the tutorial: 'intro-rshiny-mapping.html'

2. Script for making an interactive {leaflet} map: 'leaflet-map.R'

3. Script for turning the {leaflet} map into a dynamic and share-able web app: 'leaflet-app.R'

4. Shiny cheat-sheet for helpful tips: 'shiny-cheatsheet.pdf'

#### TODO

- [ ] save rnaturalearth data once downloaded initially
