#this program is based on Code_GDX_Explore_DataPrep_County.R
#ATTENTION - this command should be run before loading xlsx library, i.e you should start a new session if already in one
options(java.parameters = "-Xmx8000m")
library(xlsx)
library(dplyr)

# Data Read & Consolidate -------------------------------------------------

#create empty dataframe to store data from xl files
gdxcty15 <- data.frame()

#create a vector of state names by reading the worksheet names. exclude the first and sometomes last sheet
wb <- loadWorkbook("GDX_FY15.xlsx")
states <- names(getSheets(wb))
states <- states[2:54]
rm(wb)

#Read FY15 files 

#read up to 53, 50 state plus DC, PR, and GU
for(i in 1:53){
  tmpdfCty <- read.xlsx("GDX_FY15.xlsx",
                        sheetName = states[i],
                        colIndex = c(1:11),
                        header=FALSE,
                        startRow = 4,
                        stringsAsFactors = FALSE)
  
  blankrows <- rownames(tmpdfCty[which(tmpdfCty$X1 %in% c("", NA)),])
  
  tmpdfCty <- tmpdfCty[c(1:blankrows[1]-1),]
  
  state <- rep(states[i], nrow(tmpdfCty))
  
  tmpdfCty <- cbind(state, tmpdfCty, stringsAsFactors = FALSE)
  
  gdxcty15 <- rbind(gdxcty15, tmpdfCty, stringsAsFactors = FALSE)
  
}


#add shortened column names
names(gdxcty15) <- c("State", "GDXCountyName", "VetPop", "TotX", "CP", "Cons", "EduVoc", "Loan", "GOE", "InsInd", "MedCare", "Uniques")

#convert to numeric
gdxcty15$VetPop <- as.numeric(gdxcty15$VetPop)
gdxcty15$CP <- as.numeric(gdxcty15$CP)
gdxcty15$Cons <- as.numeric(gdxcty15$Cons)
gdxcty15$Uniques <- as.numeric(gdxcty15$Uniques)

# Remove temp variables
rm(tmpdfCty,  blankrows,i, state, states)

# GDX County Names nead moar work - Cleanup/Standardization --------

#some of the files use eg MCLEAN and some MC CLEAN and the crosswalk can't store two variations
#AK
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "FAIRBANKS NORTH STAR"] <-  "FAIRBANKS N. STAR"
#GA 
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCDUFFIE"] <-  "MC DUFFIE"
#IL
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCDONOUGH"] <- "MC DONOUGH"
#IN
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "ST JOSEPH"] <- "ST. JOSEPH"
#KS & NE & SD
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCPHERSON"] <- "MC PHERSON"
#KY
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCRACKEN"] <- "MC CRACKEN"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCREARY"] <- "MC CREARY"
#KY & ND
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCLEAN"] <- "MC LEAN"
#MI
# gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "ST.  JOSEPH"] <- "ST. JOSEPH"
#MN
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCLEOD"] <- "MC LEOD"
#MO
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCDONALD"] <- "MC DONALD"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "SAINT LOUIS CITY (CITY)"] <- "ST. LOUIS (CITY)"
#MT
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCONE"] <- "MC CONE"
#NC & WV
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCDOWELL"] <- "MC DOWELL"
#ND & IL 
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCHENRY"] <- "MC HENRY"
#ND & GA & OK
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCINTOSH"] <- "MC INTOSH"
#ND
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCKENZIE"] <- "MC KENZIE"
#OK
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCLAIN"] <- "MC CLAIN"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCURTAIN"] <- "MC CURTAIN"
#PA
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCKEAN"] <- "MC KEAN"
#SC
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCORMICK"] <- "MC CORMICK"
#SD
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCOOK"] <- "MC COOK"
#TN
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCMINN"] <- "MC MINN"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCNAIRY"] <- "MC NAIRY"
#TX
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCCULLOCH"] <- "MC CULLOCH"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCLENNAN"] <- "MC LENNAN"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "MCMULLEN"] <- "MC MULLEN"
#VA
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "CHESAPEAKE CITY (CITY)"] <- "CHESAPEAKE (CITY)"
gdxcty15$GDXCountyName[gdxcty15$GDXCountyName == "HAMPTON CITY (CITY)"] <- "HAMPTON (CITY)"


#  & Match to Census FIPS  ------------------------------------------------

#read county level FIPS code file downloaded from census website, edited to create crosswalk to GDX county names
cntyfips <- read.xlsx("national_county_edit.xlsx",
                      sheetIndex = 1,
                      header=TRUE,
                      stringsAsFactors = FALSE)


#make all county  names lower case to facilitate easier matching
cntyfips$CountyName <- toupper(cntyfips$CountyName)
cntyfips$GDXCountyName <- trimws(toupper(cntyfips$GDXCountyName))
gdxcty15$GDXCountyName <- toupper(gdxcty15$GDXCountyName)

#join gdxcty15 with fips codes
gdxcty15 <-  merge(gdxcty15, cntyfips, by=c("GDXCountyName", "State"), all.x = TRUE)
rm(cntyfips)

#Concatenate StateFP and CountyFP for a unique ID that can be matched with GEOID in us.map
#drop TotX, Cons, GOE, and Loan not veteran/county based data
gdxcty15 <- mutate(gdxcty15, FIPS=paste(StateFP, CountyFP, sep="")) %>% 
  select(c(1, 2, 17, 13:16, 11, 5, 7, 10, 3, 12)) %>% 
  #sort by StateFP and CountyFP
  arrange(StateFP, CountyFP)

#ROUND all numbers (remove decimal places)
#REMEMBER Expenditures are in 000s and VetPop and Uniques are as-is
gdxcty15[,8:13] <- round(gdxcty15[,8:13], digits = 0)

#As of FY15 - Shannon County SD (Fips: 46-113) is now Ogmerge(us.map, county_dat, by.x="GEOID", by.y="FIPS")alala-Lakota County (Fips: 46-102)
gdxcty15$FIPS[gdxcty15$FIPS == "46113"] <- "46102"



# WRITE/SAVE data ---------------------------------------------------------
#SAVE just FY15 data
saveRDS(gdxcty15,file="Data_Leaf_GDXCTY15.rds")
