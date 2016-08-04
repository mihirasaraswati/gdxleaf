### Introduction

This map-based exploration tool provides a way to look at VA expenditures from fiscal year 2015. Each year the [National Center for Veterans Analysis and Statistics (NCVAS)](http://www.va.gov/vetdata/) publishes a report on the Geographic Distribution of VA Expenditures (GDX). These reports provide a break-out of expenditures for key VA programs by State, County, and Congressional District and go as far back as 1996. You can view the [GDX reports and others on the NCVAS website.](http://www.va.gov/vetdata/Expenditures.asp) 

### Expenditure Data Sources and Notes

The expenditure data in the GDX report are compiled from a variety of VA ogranizations/systems. The list below shows all the sources for the expediture data:

1. USASpending.gov for Compensation & Pension (C&P) and Education and Vocational Rehabilitation and Employment (EVRE) Benefits.

2. Veterans Benefits Administration Insurance Center for the Insurance costs.

3. VA's Financial Management System (FMS) for Construction, Medical Research, General Operating Expenses, and certain C&P and Readjustment data.

4. Allocation Resource Center (ARC) for Medical Care costs.

5. Expenditures are rounded to the nearest thousand dollars. For example, values from $0 to $499 are rounded to $0 and values from $500 to $1,000 are rounded to $1.

### Shapefile and FIPS code Source

1. The 2010 State and County FIPS codes are used to create the GDX reports. [The FIPS codes were obtained from the U.S. Census Bureau website.](https://www.census.gov/geo/reference/codes/cou.html)

2. The 2015 shapefile used in this application was also obtained from [the U.S. Census (TIGER) website.](https://www.census.gov/geo/maps-data/data/tiger-line.html)

### Compensation & Pension Notes

These expenditures include dollars for the following programs:

1. Veterans' compensation for service-connected disabilities.
    
2. Dependency and indemnity compensation for service-connected deaths.
    
3. Veterans' pension for non-service-connected disabilities.
    
4. Burial and other benefits to Veterans and their survivors.  		
       
### Medical Care Notes

Medical Care expenditures include dollars for medical services, medical administration, facility maintenance, educational support, research support, and other overhead items. Medical Care expenditures do not include dollars for construction or other non-medical support. Medical Care expenditures are allocated to the patient's home location, not the site of care.

### Loan Guaranty Notes

Currently, all "Loan Guaranty" expenditures are attributed to Travis County, TX, where all Loan Guaranty payments are processed. Consequently these expenditures are not shown in the maps. Prior to FY 08, "Loan Guaranty" expenditures were included in the Education & Vocational Rehabilitation and Employment (E&VRE) programs. VA will continue to improve data collection for future GDX reports to better distribute loan expenditures at the state, county and congressional district levels.

### Veteran  Population (VetPop) Notes

Veteran population estimates, as of September 30, 2015, are produced by the VA Office of the Actuary (VetPop 2014).	

### Unique Patients Notes

Patients who received treatment at a VA health care facility. Data are provided by the Allocation Resource Center (ARC).


### Aknowledgements

This application was built in R and RStudio and uses Leaflet - an open-source JavaScript mapping library. This tool could not have been created without the help of the people and resource listed below. You can get [the code for this application on GitHub.](https://github.com/mihiriyer/gdxleaf)

1. [Leaflet for R](https://rstudio.github.io/leaflet/) - The leaflet R package provides an easy way to interface with the Leaflet. 

2. [Mapping US Counties in R with FIPS](https://www.datascienceriot.com/mapping-us-counties-in-r-with-fips/kris/) - This lovely tutorial by Kris Eberwein was used to link FIPS code based data to a Census shapefile and to plot maps using ggplot2 and Leaflet. 

3. [Superzip Shiny Application](http://shiny.rstudio.com/gallery/superzip-example.html) - This application was the inspiration for the look and feel. 

4. [Mapping With Shapefiles in R Getting Started](http://flowingdata.com/2014/11/20/mapping-data-in-shapefile-format-with-r/) - Nathan Yau's tutorial on reading Census shapefiles does an excellent job in laying down the foundations. 

5. [ColorBrewer](http://colorbrewer2.org/) - As always Cynthia Brewer saves the day in selecting color schemes. 
