library(dplyr)
library(raster)
library(leaflet)
library(rgdal)
library(geojsonio)
library(shiny)
library(sp)
library(RColorBrewer)

## Read in ward shapefiles from the ONS Digital Service
Wards <- geojsonio::geojson_read("https://opendata.arcgis.com/datasets/fba403b550d3456b813714bfbe7d0f0c_2.geojson", what="sp")

## Read in local authority district shapefiles from the ONS Digital Service
District <- geojsonio::geojson_read("https://opendata.arcgis.com/datasets/ae90afc385c04d869bc8cf8890bd1bcd_3.geojson", what="sp")

## Read in LSOA shapefiles from the ONS Digital Service
#LSOA <- geojsonio::geojson_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_2.geojson", what="sp")

## Read in Mark's IMD ward data - this is based on Mark's original aggregated IMD ward data file. 
load("mye_2017_wards.RData")

## Commented out because to large to work with shinyapp at the moment but uncomment to work from laptop
## Read in LSOA IMD data - this is adapted from Mark's original IMD ward data file. It doesn't aggregate to ward level. 
## Link to Mark's original script: https://github.com/MarkParker451/Population_tool_v3/blob/master/Population_tool%20Pt1%20build%20dataset.Rmd
#load("mye_2017_wards_lsoa.RData")

## Rename to match spatial file
names(mye_2017_wards)[names(mye_2017_wards) == 'WD18CD'] <- 'wd18cd'

## Combine LA District names in the Ward shapefile
Wards$LAD18CD <- mye_2017_wards$LAD18CD[match(Wards$wd18cd, mye_2017_wards$wd18cd)]

Wards$LAD18NM <- mye_2017_wards$LAD18NM[match(Wards$wd18cd, mye_2017_wards$wd18cd)]

## Combine LA District names in the District shapefile
District$LAD18CD <- mye_2017_wards$LAD18CD[match(District$lad17cd, mye_2017_wards$LAD18CD)]

District$LAD18NM <- mye_2017_wards$LAD18NM[match(District$lad17cd, mye_2017_wards$LAD18CD)]

## Commented out because too large to work with free shinyapp.io at the moment but uncomment to work on from laptop
## Combine LA District to LSOA
#LSOA$LAD18CD <- mye_2017_wards_lsoa$LAD18CD[match(LSOA$lsoa11cd, mye_2017_wards_lsoa$LSOA11CD)]

#LSOA$LAD18NM <- mye_2017_wards_lsoa$LAD18NM[match(LSOA$lsoa11cd, mye_2017_wards_lsoa$LSOA11CD)]