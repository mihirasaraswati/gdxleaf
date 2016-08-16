# Introduction

The U.S. Department of Veterans Affairs' Office of Policy and Planning publishes a report of expenditures by State and County. The Geographic Distribution of Expenditures or GDX has been published each fiscal year since 1996. These reports/files are available on the [National Center for Veteran Analysis and Statistics website.](http://www.va.gov/vetdata/) This repository contains two R programs, one program prepares the FY2015 GDX report for the shiny application and the second program is the application itself. I wrote these programs with the intent of being transparent, reproducible and flexible as possible. However, I was obliged to make a major compromise because the county names in the GDX report differed from those in the Census FIPS code file. The number of names varied was far too much to write a program to account for every variation. The steps I carried out to get the data ready are described in detail to provide, at minimum, transparency into the methods. The resultant data files created by these programs are reproducible assuming you follow the instructions outlined in this document. 

# Using the application:

This application can be used online by visiting https://mihiriyer.shinyapps.io/gdxleaf/

Alternatively, you run the application locally in RStudio by executing the following command in the console window:

`shiny::runGitHub(repo = 'mihiriyer/gdxleaf')`

You will need to have these packages installed: shiny, dplyr, sp, rgeos, rgdal, maptools, scales, leaflet. Ubuntu users may need to install (via apt-get) libgeo-dev prior to installing the rgeos library and libgdal.dev before installing rgdal.

# GDX Report/File Structure

Each GDX report is provided as an MS Excel workbook where each workbook corresponds to a fiscal year. The list below shows the breakdown of the worksheets in each workbook from FY07 to FY15:

1. 55 worksheets total for FY09 to FY15.
2. Worksheet 1 is dedicated to listing State Level Expenditures. 
3. Worksheets 2 to 54  are assigned to each State along with DC, Puerto Rico, and Guam.
5. Worksheet 55 is for the Data Description 
6. On the State Level Expenditure worksheet the data starts on row 6 and ends on row 58. 
7. On the State worksheets the data starts on row 4. The row at which the data stops varies by state.

# Data Preparation Script

In order to make the shiny application efficient I wrote a separate (from the application) script to get the data ready. This script is named *Code_GDX_DataPrep_Leaf_2015_County.R*. The first thing the script does is it reads all the county level expenditures from the 53 state worksheets and consolidates them into one dataframe. The script also standardizes county names, brings in Census FIPS codes (described in detail below) and assigns data types to the numerical variables. This script saves the final dataset as a Rds file which can be efficiently used by the shiny application. 

# County Name Standardization and Linkage to FIPS Code

While programmatically attempting to link the county names to their corresponding FIPS I discovered that county names were not written uniformly across the GDX files and that they differed from the way they written in the 2010 Census FIPS code file. Below are a few examples of how county names differ:

1. Alaska uses Borough and Census Areas in lieu of county.
2. Louisiana uses Parish.
3. Census FIPS file lists a county as: Name County.
4. GDX files list a county as: NAME.
5. Census lists county names that include the word "city" as Baltimore city. GDX lists BALTIMORE (CITY).
6. GDX list counties that have a prefix of Saint/Sainte as St./Ste.
7. Census lists county names that start with Mc as one word e.g. McPherson. The GDX files has them in both ways depending on the fiscal year e.g. MC PHERSON and MCPHERSON

Standardizing the county names is essential for pulling in the FIPS code so that the GDX data can ultimately be displayed on a map. It is also necessary to be able to make comparisons over time. I standardized the names in two ways - one by building a crosswalk and programmatically. I found that building a crosswalk was a lot easier because there were simply too many county name variants to address through programming. The Census FIPS - GDX county names crosswalk can be retrieved from GitHub. The below outlines the steps for building the crosswalk:

1. Read one GDX report and extract he unique county-state names.
2. Sort unique county-state names from GDX and also sort national_county.txt file.
3. Paste GDX names into national_county.txt file.
4. Perform counts of counties by each state to make each state has the right number of counties.
5. Verify that first, last, and middle counties for each state match.
6. Verify all county names that start with Mc, St., and Ste.
