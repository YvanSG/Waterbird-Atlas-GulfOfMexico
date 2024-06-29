############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Merge TIG flight paths into polylines
# Add field to be used to conditionally enable/disable mapping the flight paths in the Atlas

# TIG flight paths provided by:
# The Water Institute
# Baton Rouge, Louisiana

############################################################################################

## Started 2023-03-27
## Finalized 2024-02-27

############################################################################################

#### ---- Packages

library(plyr)
library(tidyverse)
library(sp)
library(rgdal)
library(sf)


#### ---- Import flight paths ----
### The Water Institute provided flight tracks as KML files.
### We imported those in QGIS using "Import KML/KMZ" tool in "KML Tools" plugin. 
### We extracted the description using "Expand HTML description field" tool in "KML Tools" plugin.
### We then exported the resulting layer as an ESRI .shp layer

y <- c("2010", "2011", "2012", "2013", "2015", "2018", "2021")
l <- list.files("data_GIS/TIG_flightlines", pattern="*.shp", 
                pattern="f2(.)*.shp", full.names = TRUE)

f <- read_sf(l[1])
f$Year <- y[1]
f$t <- "t"

for (i in 2:length(y)){
  g <- grep(paste("f",y[i], sep = ''), l, value = TRUE)
  s<-read_sf(g[1])
  s$Year <- y[i]
  s$t <- "t"
  f <- rbind(f, s)
}

# drop Z values (if any)
f <- st_zm(f)

# reorganize and drop columns
f <- f[,c("Date", "Time", "Year", "t")]

write_sf(f, dsn = "data_GIS/TIG_flightlines", layer = "TIG_flightpaths.shp", 
         driver = "ESRI Shapefile")

rm(y, l, f, i, g, s)
