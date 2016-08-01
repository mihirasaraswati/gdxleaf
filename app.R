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
us.map <- readOGR(dsn=".", layer="cb_2015_us_county_20m", verbose = FALSE)

# Remove Virgin Islands (78), American Samoa (60) Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74), Alaska (02), Guam (66), Hawaii (15), Puerto Rico (72) == , "02", "72", "66", "15"
us.map <- us.map[!us.map$STATEFP %in% c("78", "60", "69", "64", "68", "70", "74"),]


##DATA Setup
#load the R data object of gdxcty - the FY10-15 consolidated, cleanedup, and linked to FIPS code
gdxcty15 <- readRDS("gdxcty15.Rda") 

#Concatenate StateFP and CountyFP for a unique ID that can be matched with GEOID in us.map
gdxcty15 <- mutate(gdxcty15, FIPS=paste(StateFP, CountyFP, sep="")) %>% 
  select(c(1, 18, 9, 16, 10, 12, 11, 15,14, 8, 17))



#As of FY15 - Shannon County SD (Fips: 46-113) is now Ogmerge(us.map, county_dat, by.x="GEOID", by.y="FIPS")alala-Lakota County (Fips: 46-102)
gdxcty15$FIPS[gdxcty15$FIPS == "46113"] <- "46102"

#create a vector with col names to allow selecting a variable to view
gdxhelper <- data.frame(
  gdxvars= names(gdxcty15[3:11]),
  divpals=c("BrBG", "RdBu", "PiYG", "RdGy", "RdYlBu", "PRGn", "RdYlGn","PuOr", "Spectral"),
  stringsAsFactors = FALSE)


# c("BuGn", "YlOrRd", "BuPu", "YlGnBu", "GnBu", "PuBuGn", "OrRd", "YlOrBr", "PuBu")
# gdxvars= names(gdxcty15[3:11])

#merge the gdx data with the spatial object
us.map <- merge(us.map, gdxcty15, by.x="GEOID", by.y="FIPS")
rm(gdxcty15)


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
                                                        choices = c("Total Expenditures" = "TotX",
                                                                    "Medical Care" = "MedCare",
                                                                    "Comp & Pen" = "CP",
                                                                    "Education" = "EduVoc",
                                                                    "Construction" = "Cons",
                                                                    "Insurance" = "InsInd",
                                                                    "Operations" = "GOE",
                                                                    "Veteran Popuation" = "VetPop",
                                                                    "Uniques" = "Uniques"),
                                                        selected = "TotX")
                              )
                          )
                          
                 ),
                 tabPanel("Tab 01"),
                 tabPanel("Tab 02")
)


#SERVER logic
server <- function(input, output){

  # Format popup data for leaflet map.
  popup_dat <- reactive({
    paste0("<strong>County: </strong>",
           us.map$NAME,
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
           "<br><strong>VetPop: </strong>",
           trimws(format(round(us.map$VetPop, digits = 0), big.mark = ",")),
           "<br><strong>Uniques: </strong>",
           trimws(format(round(us.map$Uniques, digits = 0), big.mark = ","))
           )
    })
  
  #create a color palette
  pal <- reactive({
    colorQuantile(gdxhelper$divpals[gdxhelper$gdxvars == input$gdxvar],
                  domain = as.numeric(us.map@data[input$gdxvar][,1]),
                  n = 7)
  })

  # pal <- reactive({
  #   colorBin(gdxhelper$divpals[gdxvars == input$gdxvar], 
  #            domain = as.numeric(us.map@data[input$gdxvar][,1]),
  #            bins = 7
  #            )
  # })
    
  #and zee eaflet
  output$mymap <- renderLeaflet({
        leaflet(data = us.map)  %>%
      addTiles() %>%
      addPolygons(fillColor = ~pal()(as.numeric(us.map@data[input$gdxvar][,1])), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 1,
                  popup = popup_dat()) %>% 
      addLegend("bottomright", pal = pal(), values = ~as.numeric(us.map@data[input$gdxvar][,1]),
                title = input$gdxvar,
                labFormat = labelFormat(prefix = ""),
                opacity = 1) %>% 
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
}

shinyApp(ui = ui, server = server)