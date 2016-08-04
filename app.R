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
gdxcty15 <- readRDS("Data_GDXCTY15.rds") 
#ROUND all numbers (remove decimal places)
#REMEMBER Expenditures are in 000s and VetPop and Uniques are as-is
gdxcty15[,8:17] <- round(gdxcty15[,8:17], digits = 0)

#Concatenate StateFP and CountyFP for a unique ID that can be matched with GEOID in us.map
gdxcty15 <- mutate(gdxcty15, FIPS=paste(StateFP, CountyFP, sep="")) %>% 
  select(c(1, 18, 9, 16, 10, 12, 11, 15,14, 8, 17))

#As of FY15 - Shannon County SD (Fips: 46-113) is now Ogmerge(us.map, county_dat, by.x="GEOID", by.y="FIPS")alala-Lakota County (Fips: 46-102)
gdxcty15$FIPS[gdxcty15$FIPS == "46113"] <- "46102"

#converting NA because General Operating Expenditures only take place in certain locations.
gdxcty15$GOE[gdxcty15$GOE == 0] <- NA
# gdxcty15$Cons[gdxcty15$Cons == 0] <- NA

#this helper links the GDX variables to color schemes
gdxhelper <- data.frame(
  gdxlabs = c("Total Expenditures",
              "Medical Care",
              "Compensation & Pension",
              "Education",
              "Construction",
              "Insurance & Indemnities",
              "General Operating Expenses",
              "Veteran Popuation",
              "Unique Patients"),
  gdxvars = names(gdxcty15[3:11]),
  divpals = c("BrBG", "RdYlBu", "PiYG", "RdGy", "Blues", "PRGn", "RdYlGn","PuOr", "Spectral"),
  stringsAsFactors = FALSE)

###MAP Setup
#read census shape file
us.map <- readOGR(dsn=".", layer="cb_2015_us_county_20m", verbose = FALSE)

# Remove Virgin Islands (78), American Samoa (60) Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74), Alaska (02), Guam (66), Hawaii (15), Puerto Rico (72) == , "02", "72", "66", "15"
us.map <- us.map[!us.map$STATEFP %in% c("78", "60", "69", "64", "68", "70", "74"),]

#merge the gdx data with the spatial object
us.map <- merge(us.map, gdxcty15, by.x="GEOID", by.y="FIPS")
# rm(gdxcty15)

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
                                            left = 200,
                                            right = "auto",
                                            bottom = 400,
                                            width = 330,
                                            height = "auto",
                                            #HEADER title
                                            h2("GDX Variables"),
                                            #drop-down to pick a gdx variable
                                            selectInput(inputId = "gdxvar",
                                                        label = "Select a variable to map",
                                                        choices = c("Total Expenditures" = "TotX",
                                                                    "Medical Care" = "MedCare",
                                                                    "Compensation & Pension" = "CP",
                                                                    "Education" = "EduVoc",
                                                                    "Construction" = "Cons",
                                                                    "Insurance & Indemnities" = "InsInd",
                                                                    "General Operating Expenses" = "GOE",
                                                                    "Veteran Popuation" = "VetPop",
                                                                    "Unique Patients" = "Uniques"),
                                                        selected = "TotX")
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
           "<br><strong>Total: </strong>",
           trimws(format(round(us.map$TotX, digits = 0), big.mark = ",")),
           "<br><strong>Medical Care: </strong>",
           trimws(format(round(us.map$MedCare, digits = 0), big.mark = ",")),
           "<br><strong>Comp & Pen: </strong>",
           trimws(format(round(us.map$CP, digits = 0), big.mark = ",")),
           "<br><strong>Education: </strong>",
           trimws(format(round(us.map$EduVoc, digits = 0), big.mark = ",")),
           "<br><strong>Construction: </strong>",
           trimws(format(round(us.map$Cons, digits = 0), big.mark = ",")),
           "<br><strong>Insurance: </strong>",
           trimws(format(round(us.map$InsInd, digits = 0), big.mark = ",")),
           "<br><strong>Operations: </strong>",
           trimws(format(round(us.map$GOE, digits = 0), big.mark = ",")),
           "<br><em>*Expenditures are in 000s</em>"
           )
    })
  
  #create a color palette
  pal <- reactive({
    colorQuantile(gdxhelper$divpals[gdxhelper$gdxvars == input$gdxvar],
                  domain = us.map@data[input$gdxvar][,1],
                  n=4)
  })

  # pal <- reactive({
  #   colorBin(gdxhelper$divpals[gdxhelper$gdxvars == input$gdxvar],
  #            domain = us.map@data[input$gdxvar][,1],
  #            bins = 4,
  #            pretty = TRUE
  #            )
  # })

  # pal <- reactive({
  #   colorNumeric(gdxhelper$divpals[gdxhelper$gdxvars == input$gdxvar],
  #            domain = us.map@data[input$gdxvar][,1]
  #   )
  # })

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