#load the libraries
library(shiny)
library(dplyr)
library(sp)
library(rgeos)
library(rgdal)
library(maptools)
library(scales)
library(leaflet)

###MAP Setup
#read census shape file
us.map <- readRDS("us.map.Rda")

# Remove Virgin Islands (78), American Samoa (60) Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74), Alaska (02), Guam (66), Hawaii (15), Puerto Rico (72) == , "02", "72", "66", "15"
us.map <- us.map[!us.map$STATEFP %in% c("78", "60", "69", "64", "68", "70", "74"),]

##DATA Setup
#load the R data object of gdxcty - the FY10-15 consolidated, cleanedup, and linked to FIPS code
gdxcty15 <- readRDS("gdxcty15.Rda") 

#Concatenate StateFP and CountyFP for a unique ID that can be matched with GEOID in us.map
gdxcty15 <- mutate(gdxcty15, FIPS=paste(StateFP, CountyFP, sep="")) %>% 
  select(c(18, 8:12,14:17))

#As of FY15 - Shannon County SD (Fips: 46-113) is now Ogmerge(us.map, county_dat, by.x="GEOID", by.y="FIPS")alala-Lakota County (Fips: 46-102)
gdxcty15$FIPS[gdxcty15$FIPS == "46113"] <- "46102"

#reshape
gdxcty15 <- tidyr::gather(gdxcty15, Var, Val, 2:8)

#create a vector with col names to allow selecting a variable to view
gdxvars <- unique(gdxcty15$Var)
  # c("VetPop", "TotX", "C&P", "EduVoc", "GOE", "InsInd", "MedCare", "Uniques")

#create a color palette
pal <- colorQuantile("YlGnBu", NULL, n = 9)

#User Interface
ui <- navbarPage("GDX 2015", theme = "bootstrap.css",
                 tabPanel("My Application",
                          div(class="outer",
                              tags$head(
                                # Include our custom CSS
                                includeCSS("styles.css"),
                                includeScript("gomap.js")
                              ),
                              #display the leaflet map
                              leafletOutput("mymap", width="100%", height="100%"),
                              absolutePanel(id = "controls",
                                            class = "panel panel-default",
                                            fixed = TRUE,
                                            draggable = TRUE,
                                            top = "auto",
                                            left = 20,
                                            right = "auto",
                                            bottom = "700",
                                            width = 330,
                                            height = "auto",
                                            
                                            #header title
                                            h2("GDX explorer"),
                                            
                                            #drop-down to pick a gdx variable
                                            selectInput(inputId = "gdxvar",
                                                        label = "Select a variable to map",
                                                        choices = gdxvars,
                                                        selected = gdxvars[1]),
                                            
                                            textOutput("Mihir")
                              )
                          )
                          
                 ),
                 tabPanel("Tab 01"),
                 tabPanel("Tab 02")
)


#SERVER ogic
server <- function(input, output){
  
  mydata <- reactive({
    filter(gdxcty15, Var == input$gdxvar) %>% select(FIPS, Val) 
  })
  
  leafmap <- reactive(merge(us.map, mydata(), by.x="GEOID", by.y="FIPS"))
  
  # Format popup data for leaflet map.
  popup_dat <- reactive({
    paste0("<strong>County: </strong>", 
           leafmap()$NAME, 
           "<br><strong>Value: </strong>", 
           trimws(format(round(leafmap()$Val, digits = 0), big.mark = ",")))
  })

  
  
  output$mymap <- renderLeaflet({
    leaflet(data = leafmap())  %>%
      addTiles() %>%
      addPolygons(fillColor = ~pal(leafmap()$Val), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 1,
                  popup = popup_dat()) %>% 
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
}

shinyApp(ui = ui, server = server)