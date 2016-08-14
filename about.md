## Introduction

This map-based exploration tool provides a way to look at some VA healthcare and benefits expenditures from the fiscal year 2015 GDX Report. Each year the [National Center for Veterans Analysis and Statistics (NCVAS)](http://www.va.gov/vetdata/) publishes a report on the Geographic Distribution of VA Expenditures (GDX). These reports provide a break-out of expenditures for key VA programs by State, County, and Congressional District and go as far back as 1996. You can view the [GDX reports and others on the NCVAS website.](http://www.va.gov/vetdata/Expenditures.asp) This tool maps Medical Care, Compensation & Pension, Education & Vocational Rehabilitation, and Insurance & Indemnities expenditures. Four variables from the report are not available for viewing on the map because they are not distributed by Veteran residences.  

## Expenditure Data Sources 

The expenditure data in the GDX report are compiled from a variety of VA ogranizations/systems. The list below shows all the sources for the expediture data:

1. USASpending.gov for Compensation & Pension (C&P) and Education and Vocational Rehabilitation and Employment (EVRE) Benefits.
2. Veterans Benefits Administration Insurance Center for the Insurance costs.
3. VA's Financial Management System (FMS) for Construction, Medical Research, General Operating Expenses, and certain C&P and Readjustment data.
4. Allocation Resource Center (ARC) for Medical Care costs.
5. Expenditures are rounded to the nearest thousand dollars. For example, values from $0 to $499 are rounded to $0 and values from $500 to $1,000 are rounded to $1.

## Shapefile and FIPS Code Source

1. The 2010 State and County FIPS codes are used to create the GDX reports. [The FIPS codes were obtained from the U.S. Census Bureau website.](https://www.census.gov/geo/reference/codes/cou.html)
2. The 2015 shapefile used in this application was also obtained from [the U.S. Census (TIGER) website.](https://www.census.gov/geo/maps-data/data/tiger-line.html)

## Mapped GDX Variables

### Veteran  Population (VetPop) 

Veteran population estimates are produced by the VA Office of the Actuary (VetPop 2014). The county estimates are as of September 30, 2015 and based on Veteran's residence.

### Unique Patients Notes

Patients who received treatment at a VA health care facility. Data are provided by the Allocation Resource Center (ARC).

### Medical Care

Medical Care expenditures include dollars for medical services, medical administration, facility maintenance, educational support, research support, and other overhead items. Medical Care expenditures do not include dollars for construction or other non-medical support. Medical Care expenditures are allocated to the patient's home location, not the site of care.

### Compensation & Pension

These expenditures include dollars for the following programs:

1. Veterans' compensation for service-connected disabilities.
2. Dependency and indemnity compensation for service-connected deaths.
3. Veterans' pension for non-service-connected disabilities.
4. Burial and other benefits to Veterans and their survivors.  		

### Education & Vocational Rehabilitation

Education and Vocational Rehabilitation and Employment (E&VRE) are separate programs but are combined into one category for display purposes in GDX. E&VRE expenditure data for are also obtained from USASpending.gov and include the following categories:

1. Automobile and adaptive equipment
2. Specially adapted housing 
3. Survivors’ and Dependents’ Educational Assistance (Chapter 35)
4. Vocational Rehabilitation for Disabled Veterans (Chapter 31)
5. Post-Vietnam Era Veterans’ Educational Assistance (Chapter 32)
6. Montgomery G.I. Bill for Selected Reserves (Chapter 1606)
7. Reserve Educational Assistance Program (Chapter 1607)
8. Montgomery G.I. Bill (Chapter 30) 
9. Post-9/11 Veterans Educational Assistance (Chapter 33)  

### Insurance & Indemnities

The data reported for this category are provided by the VA Regional Office and Insurance Center (RO&IC) in Philadelphia, Pennsylvania.  

This category consists of VA expenditures for death claims, matured endowments, dividends, cash surrender payments, total disability income provision payments, and total and permanent disability benefits payments. It includes Veterans Group Life Insurance, National Service Life Insurance, Service Disabled Veterans Life Insurance, United States Government Life Insurance, Veterans Reopened Insurance, and Veterans Special Life Insurance. 

It does not include Traumatic Injury Protection Under Servicemembers' Group Life Insurance, Family Servicemembers' Group Life Insurance, or Servicemembers' Group Life Insurance.  The RO&IC provides OPP with monthly extracts of payments to recipients by zip code for the purposes of aggregating these monthly payments by state, county, and Congressional District.

## GDX Variable Excluded from the Map 

The GDX variables listed below have been excluded from the map because they are not distributed by Veteran residences. The county estimates are in fact the VA location where the expenditure was processed. The Total Expenditure variable is also not included because it is the sum of all the expenditures including those that are not in terms of Veteran residences and will lead to inequitable comparisons. 

### Construction

The Construction expenditures category includes funding for Major Projects, Minor Projects, Grants for Construction of State Extended Care Facilities, and Grants for Construction of State Veterans Cemeteries. The source of the Construction data is the Financial Management System (FMS). 

### General Operating Expenses (GOE) 

GOE represents the costs necessary to provide administration and oversight for the benefits provided by VA. This includes costs for overhead and human resources. This category does not include payments made directly to beneficiaries. The source of the GOE data is VA's Financial Manangement System.  
       
### Loan Guaranty

Currently, all "Loan Guaranty" expenditures are attributed to Travis County, TX, where all Loan Guaranty payments are processed. Prior to FY 08, "Loan Guaranty" expenditures were included in the Education & Vocational Rehabilitation and Employment (E&VRE) programs.


### Aknowledgements

This application was built in R and RStudio and uses Leaflet - an open-source JavaScript mapping library. This tool could not have been created without the help of the people and resource listed below. You can get [the code for this application on GitHub.](https://github.com/mihiriyer/gdxleaf)

1. [Leaflet for R](https://rstudio.github.io/leaflet/) - The leaflet R package provides an easy way to interface with the Leaflet. 

2. [Mapping US Counties in R with FIPS](https://www.datascienceriot.com/mapping-us-counties-in-r-with-fips/kris/) - This lovely tutorial by Kris Eberwein was used to link FIPS code based data to a Census shapefile and to plot maps using ggplot2 and Leaflet. 

3. [Superzip Shiny Application](http://shiny.rstudio.com/gallery/superzip-example.html) - This application was the inspiration for the look and feel. 

4. [Mapping With Shapefiles in R Getting Started](http://flowingdata.com/2014/11/20/mapping-data-in-shapefile-format-with-r/) - Nathan Yau's tutorial on reading Census shapefiles does an excellent job in laying down the foundations. 

5. [ColorBrewer](http://colorbrewer2.org/) - As always Cynthia Brewer saves the day in selecting color schemes. 
