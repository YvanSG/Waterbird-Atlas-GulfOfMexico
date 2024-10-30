############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Florida Wading Bird Colony Database
# Provided by Andrew Cox (Florida Fish & Wildlife Conservation Commission)
# reshaping from wide to long in preparation for GIS
# making other edits to prep for combining w all other data

############################################################################################

## Started 2023-05-17 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

# read in data
d <- read.csv("./data_original/FL_Waterbird_colonies/AnnualWBColonySurveySummaries_2010-Current_AllSpecies.csv")

# pivot from wide to long
e <- pivot_longer(d, names_to = "Species", values_to = "Count", cols = c(11:41))

# Breeding birds and breeding birds correction
e <- within(e, SpCountType[SpCountType == 'Breeding Birds' ] <- "Breeding birds")

# pivot wider to make SpCountType each a column
# this is the count metric: nests, breeding pairs, etc
f <- pivot_wider(e, names_from = "SpCountType", values_from = "Count")

# add full species name
# rename column for species code
f <-  f %>% dplyr::rename(SpeciesCode = Species)

# Bring in species codes
spp <- read.csv("./data_original/FL_Waterbird_colonies//WadingBirds_Species_2023_4_11.csv")
# drop column
spp <- select(spp, -ListingStatus)

# join spp codes to data
g <- left_join(f, spp, by = "SpeciesCode")
g$SpeciesName<- as.factor(g$SpeciesName)
#levels(g$SpeciesName)
rm(f, e, spp)

# drop rows with NA for all metrics
h <- g %>%
  filter(!if_all(c("Breeding pairs", "Nests", 
                   "All birds (adults and juveniles)", "Unknown", "Breeding birds"), is.na))

# rename some columns
h <- h %>% dplyr::rename(Year = SurvYear, ColonyName = ClnyNme, Species = SpeciesName)

# remove columns
h  <- subset(h , select = -c(SpeciesCode, Occupied, x, y, ClnyTotal, FWCRegCode, ClnySurvIDs)) 

# add State column
h$State <- "Florida"

# Survey of Green Heron with unknown survey metric
# Year == 2013, ColonyName == Plymouth Harbor Bird Rookery, 
# This survey had the survey metric as unknown - meaning that what they counted was unknown.
# I looked at surveys in previous and following years and found that in both 2010 and 2016
# 2 nests were counted at this site so I decided to change the one "unknown" to one "nest" 

# drop Unknown column 
h  <- subset(h , select = -c(Unknown))
# set nests to 1 
h <- within(h, Nests[Year == '2013' &  ColonyName == 'Plymouth Harbor Bird Rookery' & Species == "Green Heron"] <- 1)

# Add hypen to night herons and change white pelican to American
h$Species <- recode_factor(h$Species,  "Yellow-crowned Night Heron" = "Yellow-crowned Night-Heron",  
                            "Black-crowned Night Heron" = "Black-crowned Night-Heron",
                           "White Pelican" = "American White Pelican")

# make affiliation a factor
h$Affiliation <- as.factor(h$Affiliation)

# add data provider
h$DataProvider <- "Florida Wading Bird Colony Database"
h$DateReceived <- "2023-03-13"

# change some of the unidentified names so they are easier to read
h$Species <- as.character(h$Species)
h <- within(h, Species[Species == "Dark Waders"] <- "Waders, Dark")
h <- within(h, Species[Species == "Large Dark Waders"] <- "Waders, Large Dark")
h <- within(h, Species[Species == "Large White Waders"] <- "Waders, Large White")
h <- within(h, Species[Species == "Light Waders"] <- "Waders, Light")
h <- within(h, Species[Species == "Small White Waders"] <- "Waders, Small White")
h <- within(h, Species[Species == "Small Dark Waders"] <- "Waders, Small Dark")
h <- within(h, Species[Species == "Unknown Species"] <- "Species Unknown")
h <- within(h, Species[Species == "Wading Birds"] <- "Wader, Unknown")

# change back to factor
h$Species <- as.factor(h$Species)

# rename columns
h <- h %>% dplyr::rename("Pairs" = "Breeding pairs", "Adults" = "Breeding birds")

# consolidate similar SpCountMethods and SurvMethods
# SurvMethod
h <- within(h, SurvMethod[SurvMethod == "Flight Line"] <- "Flight line")
h <- within(h, SurvMethod[SurvMethod == "Ground - Perimeter "] <- "Ground - Perimeter")
h <- within(h, SurvMethod[SurvMethod == "Ground - Unknown Method"] <- "Ground - Unknown method")
h <- within(h, SurvMethod[SurvMethod == "Ground - unknown method"] <- "Ground - Unknown method")
h$SurvMethod <- as.character(h$SurvMethod)
h$SurvMethod <- as.factor(h$SurvMethod)
levels(h$SurvMethod)
# rename column to SurveyVantagePoint
h <- h %>% dplyr::rename(SurveyVantagePoint = SurvMethod)

#SpCountMethod
h <- within(h, SpCountMethod[SpCountMethod == "Approximate Count"] <- "Approximate count")
h <- within(h, SpCountMethod[SpCountMethod == "Direct Count"] <- "Direct count")
h <- within(h, SpCountMethod[SpCountMethod == "Maximum Reported Count"] <- "Maximum reported count")
h$SpCountMethod <- as.factor(h$SpCountMethod)
levels(h$SpCountMethod)

# remove no longer needed dataframes
rm(d,g)

d <- h
rm(h)

# make year a factor
d$Year <- as.factor(d$Year)



##### Fix colonies that are missing names ####

# Give them names like this: "Unnamed Colony County Name number"

# First up, pull out colonies without names
blank <- d %>% filter(ColonyName == "" | ColonyName == " ")

# drop those rows from the full dataset d
d <- setdiff(d, blank)

# convert dataframe of missing names to spatial layer
library(sf)
blank <- st_as_sf(blank, coords = c("Longitude", "Latitude"), remove = FALSE, crs = 4326)

# manually create ./data_GIS and .data_GIS/FL_counties folders at root location
# download county shapefile from data.gov
# https://www2.census.gov/geo/tiger/TIGER2022/COUNTY/tl_2022_us_county.zip
# unzip file in .data_GIS/FL_counties folder

# bring in county names spatial layer
county <- read_sf("./data_GIS/FL_counties/tl_2022_us_county/tl_2022_us_county.shp")

# Pull out only Florida counties
county <- filter(county, STATEFP == 12)

# keep only columns we need: county name and the spatial info
county <- select(county, NAME, geometry)

# library(tmap)
# tmap_mode("view") # interactive view
# 
# # transform blank to same crs as county shapefile
# blank = st_transform(blank, st_crs(county))
# 
# # map it to take a look
# tm_shape(county)+
#   tm_polygons()+ 
#   
# tm_shape(blank)+
#   tm_symbols()

# join county name to "blank" dataframe
blank <- st_join(blank, county, left = FALSE )
rm(county)

# rename column w county
blank <-  blank %>% dplyr::rename(County = NAME)

# convert back to a regular dataframe 
blank <- as.data.frame(blank)

# drop geometry column
blank  <- subset(blank , select = -c(geometry))

blank$County <- as.factor(blank$County )
blank$AtlasNo <- as.factor(blank$AtlasNo )
blank <- blank %>% relocate(County, .after=ColonyName)

# make a summary of colonies by county
blank_summary <- blank %>%
  select(AtlasNo, County) %>%
  group_by(County, AtlasNo) %>%
  dplyr::summarise(n = n())

# add the count of colonies (colonies with 2+ colonies will need multiple numbers)
blank_summary$number <- c(1,1,2,3,4,5,1,1,1,1,2,3,4,5,1,2,1,2,3,1,1)

# drop unneeded columns
blank_summary  <- subset(blank_summary , select = -c(n))
blank <- left_join(blank, blank_summary, by = c("County", "AtlasNo"))

# Use County and number to name a name for unnamed colony
blank$ColonyName <-  paste("Unnamed Colony ", blank$County, blank$number ) 

# remove columns no longer needed
blank  <- subset(blank , select = -c(number, County))

# add blank back to full dataset 
d <- rbind(d, blank)
rm(blank, blank_summary)

# in rows with presence/absence, codes "0"/"1" are used to signify "absent"/"present", resp.
# change "1" to "Present". 
d <- within(d, Pairs[SpCountMethod == "Presence/Absence" & Pairs == 1] <- "Present")
d <- within(d, Nests[SpCountMethod == "Presence/Absence" & Nests == 1] <- "Present")



##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/FL_Waterbird_Colony_survey.csv")


############################################################################################
#################################### END ###################################################
############################################################################################
