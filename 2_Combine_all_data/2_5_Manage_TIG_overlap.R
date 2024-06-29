############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

## 5_Manage_TIG_overlap.R
## TIG Overlap problem

# Problem: The Gulfwide TIG dataset overlaps spatially and temporally with other datasets
#   such that some colonies in the Atlas are surveyed/counted more than once per year
#   by two different data providers.
# Proposed solution: Pull out TIG colonies that are overlapping and put them in their
#   own separate dataset. This will be done here by creating a new column called "TIGDisplay". 
#   Rows to be displayed together will be assigned "together" and those to be 
#   displayed separately will be assigned "separate".
# Steps: 
#   First select colonies that are within a 500-m distance threshold.
#   Next select colonies where TIG colony name is the same as in other datasets.
#   Then, for those colonies that are to be displayed separately,
#   check temporal overlap: if no overlap, send back to be displayed together.

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(plyr)
library(tidyverse)
library(sf)


# Use dataframe "d" created in "./R/Atlas/2_Combine_all_data/1_Combine_all_data.R"

dtig <- d

# turn off scientific notation
options(scipen = 999)



##### Spatial join by distance ####

# Join TIG sites to the closest non-TIG site

# create spatialpointdataframes from TIG and non-TIG providers

# use Equidistant cylindrical projection centered on Atlas footprint
# calculate reference latitude
(max(dtig$Latitude)+min(dtig$Latitude))/2
# calculate reference longitude
(max(dtig$Longitude)+min(dtig$Longitude))/2

# for efficiency, reduce datasets to only one row per Site
tig <- dtig %>% 
  filter(DataProvider == "DWH Regionwide TIG") %>% 
  distinct(AtlasSiteCode, ColonyName, Latitude, Longitude, DataProvider, State) %>%
  # project to Equidistant cylindrical centered on Atlas footprint
  st_as_sf(coords = c("Longitude","Latitude"),remove = F, crs = 4326) %>% 
  st_transform(crs = "+proj=eqc +lat_ts=27.6 +lat_0=27.6 +lon_0=-88.9 +a=6371007 
               +b=6371007 +units=m +no_defs") 

m <- dtig %>% 
  filter(!(DataProvider == "DWH Regionwide TIG"))%>% 
  distinct(AtlasSiteCode, ColonyName, Latitude, Longitude, DataProvider) %>% 
  dplyr::rename(AtlasSiteCode_NEAR = AtlasSiteCode,
         ColonyName_NEAR = ColonyName,
         Lat_NEAR = Latitude, Long_NEAR = Longitude,
         DataProvider_NEAR = DataProvider) %>% 
  # project to Equidistant cylindrical centered on Atlas footprint
  st_as_sf(coords = c("Long_NEAR","Lat_NEAR"),remove = F, crs = 4326) %>% 
  st_transform(crs = "+proj=eqc +lat_ts=27.6 +lat_0=27.6 +lon_0=-88.9 +a=6371007 
               +b=6371007 +units=m +no_defs")

# find nearest TIG site in non-TIG dataset
nearest <- st_nearest_feature(tig,m)
# calculate pairwise distance
dist <- st_distance(tig, m[nearest,], by_element=TRUE)
join <- cbind(tig, st_drop_geometry(m)[nearest,]) %>% 
  select(-c(Species.1, Year.1))
join$dist <- dist %>% as.numeric()

rm(dist)
rm(nearest)



##### Site-specific computations ####

# Rows to be displayed together on an map will be assigned "together"
# Rows to be displayed separately on a map will be assigned "separate"

together <- join

#pull out colonies where TIG colony name and nearest non-TIG colony name are the same
separate <- filter(together, ColonyName == ColonyName_NEAR)

# pull out colonies where TIG colony name and nearest non-TIG colony name are different
together <- filter(together, ColonyName != ColonyName_NEAR)

# Pull out colonies that are within the distance threshold (500m)
# and add to the other separates
separate <- filter(together, dist < 500) %>%
  rbind(separate)

# remove those rows from "together"
together <- filter(together, dist >= 500)

# add new column to both together and separate that shows their display status
together$TIGDisplay  <- "together"
separate$TIGDisplay  <- "separate"

# add these two dataframes back together 
t <- rbind(together, separate)
rm(separate, together, join, tig, m)

# remove columns no longer needed
t  <- t %>% as.data.frame() %>% 
  subset(select = -c(geometry))

# pull out only TIG data from main dataset (5482)
tig <- filter(dtig, DataProvider== "DWH Regionwide TIG")

# temporarily remove TIG data from main dataset
dnotig <- filter(dtig, DataProvider != "DWH Regionwide TIG")

rm(dtig)

#### ---- Compare years between "separate" TIG colonies and their near neighbors

# If years do not overlap, then the colonies can be displayed together on a map
# (although they overlap spatially, they do not temporally)

# pull out near neighbors of "separate" colonies
yearnear <- filter(t, TIGDisplay == "separate") %>% #only "separate"s
  select(ColonyName_NEAR)  %>%
  unique() %>% 
  dplyr::rename(ColonyName = ColonyName_NEAR)

# use this dataframe (yearnear) of colony names to pull out these near colonies from dnotig
yearnear <- left_join(yearnear, dnotig, by = "ColonyName", multiple = "all")  

# make a dataframe of ColonyNames from dnotig with the years for which there is data 
yearnear <- yearnear %>%
  select("ColonyName", "Year" ) %>%
  unique() %>%
  dplyr::rename(ColonyName_NEAR = ColonyName )

# add new display column to dnotig
# this will be used to show which data to display all together and which to display separately
dnotig$TIGDisplay <- "together"

# add "TIGDisplay" column to TIG data by joining "tig" and "t"
tig <- t %>% 
  select(-c("ColonyName", "Latitude", "Longitude", "DataProvider", "State")) %>% 
  full_join(tig, ., by= c("AtlasSiteCode", "Species", "Year"))



#### ---- Compare overlap between years between datasets

# pull out tig "separates" with years
year_tig <- tig %>%
  filter(TIGDisplay == "separate") %>%
  select(ColonyName, Year, ColonyName_NEAR) %>%
  unique() 

# remove separates and Louisiana rows from tig
# (only TIG data are available for Louisiana - so no overlap possible with other datasets)
# then drop columns and add back to full dataset
togethers <- tig %>%
  filter(TIGDisplay == "together" | State == "Louisiana") %>% 
  select(-c(AtlasSiteCode_NEAR, ColonyName_NEAR, Lat_NEAR, Long_NEAR, DataProvider_NEAR, dist))


# join tig separate and non-tig nears by year
# Overlapping sites stay separate and sites that don't overlap go back to together
stay_separate <- inner_join(year_tig, yearnear, by = c("ColonyName_NEAR", "Year"))
# Checked them manually by opening up ArcPro and zooming into colonies in stay_separate
# then checking if there are nearby non-TIG colonies with data in the same year.
# These rightly need to stay separate:
# Tegarden 2021, Tern Island 2021, West Bay Mooring Facility 2021, West Nueces Bay 51W K 2021, 
# White Pelican Island 2021 , Hemp Key 2010, Gaillard Island


# Remove from "year_tig" the ones that still overlap (stay separate).
# The ones left behind should be "together"
change2together<- setdiff(year_tig, stay_separate)
# Checked these manually in ArcPro
# (to make sure there are no colonies nearby that were also surveyed that year): 
# Bob Key 2010, Salt Lake G 2010, Sunken Island 2010
# This seems to work to pull out colonies that do overlap by year. 
# This will need to be re-checked when new FL Seabird data arrives.
# Right now, this is not fully successful in identifying
# when there is overlap between TIG and FL Seabird data.
# This is because FL Seabird data colonies are in slightly different
# locations every year so the TIG's nearest colony identified in FL 
# may not be the colony location that was surveyed in the same year.  

# Now stay_separates need to be assigned separate
# and change2together needs to be assigned together 
stay_separate$TIGDisplay  <- "separate"
change2together$TIGDisplay  <- "together"

# drop display column so it can be updated
tig <- subset(tig, select = -c(TIGDisplay) )

# pull out rows that should stay separate
stay_separate <- stay_separate %>% 
  select(-c(ColonyName, ColonyName_NEAR)) %>% 
  inner_join(tig, by = c("AtlasSiteCode", "Year", "Species"))

# pull out rows previously assigned "separate" that should be changed to 
# "together" because there is not temporal overlap 
change2together <- change2together %>% 
  select(-c(ColonyName, ColonyName_NEAR)) %>% 
  inner_join(tig, by = c("AtlasSiteCode", "Year", "Species"))

#combine those
tig_display <- rbind(stay_separate , change2together)

# clean-up temporary datasets before merging with main dataset
tig_display <- tig_display %>%  
  select(-c(AtlasSiteCode_NEAR, Lat_NEAR, Long_NEAR, DataProvider_NEAR, 
            dist, ColonyName_NEAR))

# recombine TIG data with full dataset and remove duplicates created during the process
d2 <- rbind(dnotig, togethers, tig_display) %>%
  distinct()

# check if d2 has same number of rows as original dataset d
d2 %>% nrow()
d %>% nrow()
# ok

# Change NAs for TIG Louisiana colonies in display to together
# (these were not assigned earlier because there is no overlap in LA)
d2 <- within(d2, TIGDisplay[State == "Louisiana" & DataProvider == "DWH Regionwide TIG"] <- "together")  

#how many were separated?
d2 %>%
  select(TIGDisplay) %>%
  group_by(TIGDisplay) %>%
  dplyr::summarize(n = n())

d <- d2

KEEP <- d

# remove dataframes no longer needed
rm(dnotig, d2, t, tig, change2together, stay_separate, tig_display, togethers, year_tig, yearnear) 

print("############################## TIG overlap managed ############################")

############################################################################################
#################################### END ###################################################
############################################################################################