library(sp)
library(rgeos)
library(rgdal)
library(maptools)
library(dplyr)
library(leaflet)
library(scales)

###MAP Setup
#read census shape file
us.map <- readOGR(dsn="/home/shellbu/Dropbox/Rprojects/gdxleaf/cb_2015_us_county_20m", layer="cb_2015_us_county_20m")

# Remove Virgin Islands (78), American Samoa (60) Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74), Alaska (02), Guam (66), Hawaii (15), Puerto Rico (72) == , "02", "72", "66", "15"
us.map <- us.map[!us.map$STATEFP %in% c("78", "60", "69", "64", "68", "70", "74"),]

##DATA Setup
#load the R data object of gdxcty - the FY10-15 consolidated, cleanedup, and linked to FIPS code
gdxcty15 <- readRDS("gdxcty15.Rda") 

#subset gdxcty for FY 15 == !State %in% c("AK", "GU", "HI", "PR"),
county_dat <- filter(gdxcty15,  FY=="2015") %>% 
  mutate(FIPS=paste(StateFP, CountyFP, sep="")) %>% 
  select(c(7, 18, 9)) %>% 
  arrange(TotX)

#As of FY15 - Shannon County SD (Fips: 46-113) is now Ogalala-Lakota County (Fips: 46-102)
county_dat$FIPS[county_dat$FIPS == "46113"] <- "46102"

# Merge spatial df with downloade ddata.
leafmap <- merge(us.map, county_dat, by.x="GEOID", by.y="FIPS")

# Format popup data for leaflet map.
popup_dat <- paste0("<strong>County: </strong>", 
                    leafmap$NAME, 
                    "<br><strong>Value: </strong>", 
                    trimws(format(round(leafmap$TotX, digits = 0), big.mark = ",")))

pal <- colorQuantile("YlGnBu", NULL, n = 9)
# Render final map in leaflet.
leaflet(data = leafmap) %>% addTiles() %>%
  addPolygons(fillColor = ~pal(TotX), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1,
              popup = popup_dat)
