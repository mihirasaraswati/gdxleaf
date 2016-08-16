# Data Setup/Prep ---------------------------------------------------------

#load the libraries
library(shiny)
library(dplyr)
library(sp)
library(rgeos)
library(rgdal)
library(maptools)
library(scales)
library(leaflet)

##DATA Setup
#load the R data object of gdxcty - the FY10-15 consolidated, cleanedup, and linked to FIPS code
gdxcty15 <- readRDS("Data_Leaf_GDXCTY15.rds") 

#this helper links the GDX variables to color schemes
gdxhelper <- data.frame(
  gdxlabs = c("Medical Care",
              "Compensation & Pension",
              "Education",
              "Insurance & Indemnities",
              "Veteran Popuation",
              "Unique Patients"),
  gdxvars = names(gdxcty15[7:12]),
  divpals = c("BrBG", "RdYlBu", "PiYG", "PRGn", "RdYlGn","PuOr"),
  stringsAsFactors = FALSE)

###MAP Setup
#read census shape file
us.map <- readOGR(dsn=".", layer="cb_2015_us_county_20m", verbose = FALSE)

# Remove Virgin Islands (78), American Samoa (60) Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74), Alaska (02), Guam (66), Hawaii (15), Puerto Rico (72) == , "02", "72", "66", "15"
us.map <- us.map[!us.map$STATEFP %in% c("78", "60", "69", "64", "68", "70", "74"),]

#merge the gdx data with the spatial object
us.map <- merge(us.map, gdxcty15, by.x="GEOID", by.y="FIPS")
#clean up workspace
rm(gdxcty15)

# UI - User Interface Setup -----------------------------------------------

ui <- navbarPage("VA Expenditures in Fiscal Year 2015", 
                 tabPanel("GDX Explorer",
                          inverse = TRUE,
                          div(class="outer",
                              tags$head(
                                # Include our custom CSS
                                includeCSS("styles.css")
                              ),
                              #display the leaflet map
                              leafletOutput("mymap", width="100%", height="100%"),
                              absolutePanel(id = "controls",
                                            class = "panel panel-default",
                                            fixed = TRUE,
                                            draggable = TRUE,
                                            top = "auto",
                                            left = 275,
                                            right = "auto",
                                            bottom = 275,
                                            width = 275,
                                            height = "auto",
                                            #HEADER title
                                            h2("GDX Variables"),
                                            #drop-down to pick a gdx variable
                                            selectInput(inputId = "gdxvar",
                                                        label = "Select a variable to map",
                                                        choices = c("Medical Care" = "MedCare",
                                                                    "Compensation & Pension" = "CP",
                                                                    "Education" = "EduVoc",
                                                                    "Insurance & Indemnities" = "InsInd",
                                                                    "Veteran Popuation" = "VetPop",
                                                                    "Unique Patients" = "Uniques"),
                                                        selected = "MedCare"),
                                            tags$small(includeMarkdown("notes_interpret.md"))
                                            
                              )
                          )
                          
                 ),
                 tabPanel(HTML("About</a></li><li><a href=\"https://github.com/mihiriyer/gdxleaf\">Get code"), 
                          div(class="abouttext",
                              includeMarkdown("about.md")) 
                 )
                 
)

# SERVER logic ------------------------------------------------------------

server <- function(input, output){
  
  # Format popup data for leaflet map.
  popup_dat <- reactive({
    paste0("<strong>County: </strong>",
           paste(us.map$NAME, ", ", us.map$State, sep=""),
           "<br><b>Veteran Population: </b>",
           trimws(format(round(us.map$VetPop, digits = 0), big.mark = ",")),
           "<br><strong>Uniques: </strong>",
           trimws(format(round(us.map$Uniques, digits = 0), big.mark = ",")),
           "<br><strong>Medical Care: </strong>",
           trimws(format(round(us.map$MedCare, digits = 0), big.mark = ",")),
           "<br><strong>Comp & Pen: </strong>",
           trimws(format(round(us.map$CP, digits = 0), big.mark = ",")),
           "<br><strong>Education: </strong>",
           trimws(format(round(us.map$EduVoc, digits = 0), big.mark = ",")),
            "<br><strong>Insurance: </strong>",
           trimws(format(round(us.map$InsInd, digits = 0), big.mark = ",")),
           "<br><em>*Expenditures are in 000s</em>"
    )
  })
  
  #create a color palette
  pal <- reactive({
    colorQuantile(gdxhelper$divpals[gdxhelper$gdxvars == input$gdxvar],
                  domain = us.map@data[input$gdxvar][,1],
                  n=5)
  })

  
  #Legend title - get the readable name for the selected variable in lieu of the column name
  leg.title <- reactive(paste(gdxhelper$gdxlabs[gdxhelper$gdxvars == input$gdxvar]))
  
  #Legend key labels
  leg.key <- reactive({
    as.character(round(quantile(us.map@data[input$gdxvar][,1], seq(0,1.25,0.25))))
  })
  
  #and zee leaflet
  output$mymap <- renderLeaflet({
    leaflet(data = us.map)  %>%
      addTiles() %>%
      addPolygons(fillColor = ~pal()(us.map@data[input$gdxvar][,1]), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 0.5,
                  popup = popup_dat()) %>% 
      addLegend("bottomright", 
                pal = pal(), 
                values = ~us.map@data[input$gdxvar][,1],
                title = leg.title(),
                opacity = 1) %>% 
      setView(lng = -110.00, lat = 45.00, zoom = 4)
  })
  
  
}

shinyApp(ui = ui, server = server)