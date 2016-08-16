# Using the application:

This application can be used online by visiting https://mihiriyer.shinyapps.io/gdxleaf/

Alternatively, you run the application locally in RStudio by executing the following command in the console window:

`shiny::runGitHub(repo = 'mihiriyer/gdxleaf')`

You will need to have these packages installed: shiny, dplyr, sp, rgeos, rgdal, maptools, scales, leaflet. Ubuntu users may need to install (via apt-get) libgeo-dev prior to installing the rgeos library and libgdal.dev before installing rgdal.