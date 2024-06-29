############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Combine all local Atlas datasets into a single file
# Make edits that are applicable across all datasets

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(plyr)
library(tidyverse)
library(data.table)
library(readbulk)
library(dplyr)



#### ---- Read in all of the spreadsheets into a single dataframe ####

# Use rbind.fill so columns that are missing will be filled w NA
d <- read_bulk(directory = "./data_cleaned", subdirectories = FALSE, extension = ".csv", 
               verbose = TRUE, fun = fread )  



#### ---- C-CAP spatial filter ####

# Keep only sites within Coastal Change Analysis Program (C-CAP) Regional Land Cover: estuarine
# Use ad-hoc shapefile to filter out colonies more inland than C-CAP:estuarine
# and north of Key Largo, FL

library(sf)

# load the C-CAP border shapefile used to filter colonies
border <- read_sf("./data_GIS/ccap_estuarine_boundary/ccap_aggregate_10km_final_2024_01_05.shp")

# convert main dataframe to spatial sf object
# in preparation for spatial filtering
e <- st_as_sf(d, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)

# project to EPSG:5070 - NAD83 / Conus Albers used by C-CAP
e <- st_transform(e, crs = 5070)

# # take a look at the map
# library(tmap)

# # Change the map view if you like
# tmap_mode("view") # interactive view
# tmap_mode("plot") # static view
# # take a look at the map to make sure everything looks good
# tm_shape(border)+
# tm_borders("red") +
# tm_shape(e) +
# tm_symbols(shape = 1, size = .1)

# select data that falls within the C-CAP boundary
keep <-  e[border, ]

# # take a look at the map to make sure everything looks good 
# tm_shape(border)+
# tm_borders(col = "red") +
# tm_shape(keep) +
# tm_symbols(shape = 1, size = .1)

# convert spatial data back to regular dataframe 
d <-  as.data.frame(keep)

# drop columns not needed 
d <- subset(d , select = -c(geometry) )

# remove temporary dataframes
rm(keep, border, e)



#### ---- Drop rows where Species is #N/A ####

# When no birds were detected because the colony was inactive or 
# no survey was conducted or the land area was submerged.

d <- d  %>% filter(!(Species == "#N/A")) 



#### ---- Remove and reorder columns ####

d  <- subset(d , select = -c(V1, CombinedMayJuneTotal., Subcolony.Letter, 
                             filename, Unknown.metric)) %>% 
  dplyr::rename(All.birds_ad_juv = All.birds..adults.and.juveniles.) %>% 
  relocate(c(Adults, Birds, All.birds_ad_juv), .after = Nests) %>% 
  relocate(ColonyCode, .after=ColonyName)



#### ---- Create new columns ####

# safekeep original data (Atlas metrics only)
d$OriginalPairs <- d$Pairs
d$OriginalNests <- d$Nests
d$OriginalAdults <- d$Adults

# rearrange column order (move count metrics together for easier viewing)
d  <- d  %>% relocate(c(Pairs), .after = Nests)
d  <- d  %>% relocate(c(Birds, All.birds_ad_juv), .after = Adults)



#### ---- Clean up columns ####

# these columns are associated specifically with the FL Wadingbird database.
# 10/23/23 - Janell Brush (FL FWCC) is ok to drop these columns from FL Wadingbird database
d<- subset(d , select = -c(Affiliation, DataContact) ) 

# These folks agreed (email October 2023) to be listed as contact
# Create dataframe of contacts
e.contact = data.frame(
  DataProvider = c( "Alabama DCNR", "Alabama Audubon", "Audubon Delta",
                   "Florida Shorebird Database", "Florida Wading Bird Colony Database", 
                   "Gulf Islands National Seashore", "DWH Regionwide TIG", 
                   "Texas Colonial Waterbird Society", "Florida Rooftop Colony Database"),
  DataContact1 = c("Roger Clay", "Lianne Koczur", "Abby Darrah",
                 "Janell Brush", "Janell Brush", 
                 "Cody Haynes", "Jon Wiebe",
                 "David Essian", "Janell Brush"),
  DataContact2 = c(NA, NA, NA, NA, NA, NA, "Eva Windhoffer", NA, NA),
  DataContactEmail1 = c("Roger.Clay@dcnr.alabama.gov","lianne@alaudubon.org","Abby.Darrah@audubon.org",
                       "Janell.Brush@myfwc.com", "Janell.Brush@myfwc.com",
                       "james_haynes@nps.gov", "jwiebe@wlf.la.gov", 
                      "david.essian@tamucc.edu", "Janell.Brush@myfwc.com"),
  DataContactEmail2 = c(NA, NA, NA, NA, NA, NA, "ewindhoffer@thewaterinstitute.org", NA, NA),
  DataContactAffiliation1 = c("Alabama DCNR", "Alabama Audubon", "Audubon Delta",
                             "Florida FWC", "Florida FWC",
                             "National Park Service", "Louisiana DWF",
                             "Harte Research Institute", "Florida FWC"),
  DataContactAffiliation2 = c(NA, NA, NA, NA, NA, NA, "The Water Institute", NA, NA))


# make this column a factor to match d for join
e.contact$DataProvider <- as.factor(e.contact$DataProvider)

# join new dataframe e to dull dataset d
d <- full_join(d, e.contact, by = "DataProvider")

rm(e.contact)


#### ---- Check factor levels for inconsistencies ####

# d$Species <- as.factor(d$Species)
# levels(d$Species)

d$Year <- as.factor(d$Year)
levels(d$Year)

d$State <- as.factor(d$State)
levels(d$State)

d$Identified_to_species <- as.factor(d$Identified_to_species)
levels(d$Identified_to_species)

d$DataProvider <- as.factor(d$DataProvider)
levels(d$DataProvider)

d$SurveyVantagePoint <- as.factor(d$SurveyVantagePoint)
levels(d$SurveyVantagePoint)

d$SpCountMethod <- as.factor(d$SpCountMethod)
levels(d$SpCountMethod)



#### ---- Edits based on Technical Advisory Team's response to data survey ####

# Based on August 2023 survey to Technical Advisory Team

# Drop species categories except for
# (1) Brown Noddy or Sooty Tern 
# (2) Glossy or White-faced Ibis 
# (3) Royal or Sandwich Tern
unid <- d  %>% filter (Identified_to_species == "no") %>% # pull out all species category names
  select(Species) %>% #keep only the species column
  unique() %>% # drop duplicates
  filter (Species != "Ibis, Glossy or White-faced" & Species != "Brown Noddy or Sooty Tern" & Species != "Tern, Royal or Sandwich") # drop 3 categories to keep

# use above "unid" to filter out categories TAT voted NOT to include in the Atlas 
d <- d  %>% filter (!(Species %in% unid$Species))
rm(unid)

# Drop these Species (not breeding within Atlas footprint): 
# American Avocet, American Bittern, Black-bellied Plover, Black Tern,  
# Lesser Black-backed Gull, Marbled Godwit, Red Knot, Ring-billed Gull, 
# Ruddy Turnstone, Short-billed Dowitcher
d <- d  %>% filter (Species != "American Avocet" &
                      Species != "American Bittern" &
                      Species != "Black-bellied Plover" &
                      Species != "Black Tern" &
                      Species != "Lesser Black-backed Gull" & 
                      Species != "Marbled Godwit" &
                      Species != "Red Knot" &
                      Species != "Ring-billed Gull" &
                      Species != "Ruddy Turnstone" &
                      Species != "Short-billed Dowitcher")

# Drop zero nest observations of Herring Gull (but keep 2 observations of single nests)
d <- d  %>% filter(!(Species == "Herring Gull" & Nests == "0")) 
#### ---- End Edits to data made after TAT response

# Change nomenclature for "Brown Noddy or Sooty Tern", so that it matches other Tern categories
d$Species[d$Species=="Brown Noddy or Sooty Tern"] <- "Tern, Sooty or Brown Noddy"
d$Species<-as.factor(d$Species)
levels(d$Species)


#### ---- Remove coot and gallinule ####

# American Coot has 3 observations of 0 nests w non-zero values for Birds (from TIG data)
# Common Gallinule has 3 observations of 0 nests w non-zero values for Birds (from TIG data)
d <- d %>% filter(Species != "Common Gallinule" & Species != "American Coot")

# drop the empty levels
d$Species <- droplevels(d$Species)

#### ---- Remove shorebirds not consistently surveyed across the study area
# Per 27 February 2024 TAT meeting
d <- d  %>% filter(Species != "American Oystercatcher" &
                      Species != "Wilson's Plover" &
                      Species != "Snowy Plover" &
                      Species != "Willet" &
                     Species != "Black-necked Stilt"&
                     Species != "Limpkin")


#### ---- Modify colony names so they match across years ####

KEEP.1 <- d
# file.edit("./R/Atlas/2_Combine_all_data/2_Match_colony_name_across_years.R")
source("./R/Atlas/2_Combine_all_data/2_Match_colony_name_across_years.R")



#### ---- Correct sites with multiple coordinates ####

# archive the original site names
d$ProviderColonyName <- d$ColonyName
# Some sites have with multiple sets of coordinates
colony_mult_coords <- d %>%
  dplyr::select( ColonyName, Latitude, Longitude, DataProvider) %>%
  dplyr::group_by( ColonyName, Latitude, Longitude, DataProvider) %>%
  dplyr::summarise(n = n())

colony_mult_coords %>%
  select( ColonyName, DataProvider) %>%
  dplyr::group_by( ColonyName, DataProvider) %>%
  dplyr::summarise(n = n()) %>% filter(n>1)

# Alafia Bank, Florida Wading Bird Colony Database
as.factor(d$Longitude[d$ColonyName == "Alafia Bank"]) %>% summary()
# use the coordinates with more locations
d$Longitude[d$ColonyName == "Alafia Bank"] <- -82.412930
d$Latitude[d$ColonyName == "Alafia Bank"] <- 27.847461

# Gopher Keys, Florida Wading Bird Colony Database
as.factor(d$Latitude[d$ColonyName == "Gopher Keys"]) %>% summary()
# These are two different islets within ~700yds of each other
# Rename them North/South
d$ColonyName[d$ColonyName == "Gopher Keys" & d$Latitude == 24.983777] <- "Gopher Keys South"
d$ColonyName[d$ColonyName == "Gopher Keys" & d$Latitude == 24.98920463] <- "Gopher Keys North"

# Little Bird Key, Florida Wading Bird Colony Database
as.factor(d$Latitude[d$ColonyName == "Little Bird Key"]) %>% summary()
# totally different locations (St Pete north and St Pete south)
# DWH Regionwide TIG dataset has both islands so use TIG names and coordinates
d$ColonyName[d$ColonyName == "Little Bird Key" & d$Latitude == 27.68519123] <- "Little Bird Key S"
d$Latitude[d$ColonyName == "Little Bird Key S"] <- 27.685200
d$Longitude[d$ColonyName == "Little Bird Key S"] <- -82.716900
d$ColonyName[d$ColonyName == "Little Bird Key S"] <- "Little Bird Key South"
# 
d$ColonyName[d$ColonyName == "Little Bird Key" & d$Latitude == 27.79318462] <- "Little Bird Key N"
d$Latitude[d$ColonyName == "Little Bird Key N"] <- 27.793000
d$Longitude[d$ColonyName == "Little Bird Key N"] <- -82.777500
d$ColonyName[d$ColonyName == "Little Bird Key N"] <- "Little Bird Key North"

# Rookery Bay, Florida Wading Bird Colony Database
as.factor(d$Latitude[d$ColonyName == "Rookery Bay"]) %>% summary()
# These are two different islets within Rookery Bay
# Rename them North/South
d$ColonyName[d$ColonyName == "Rookery Bay" & d$Latitude == 26.02861793] <- "Rookery Bay South"
d$ColonyName[d$ColonyName == "Rookery Bay" & d$Latitude == 26.034509] <- "Rookery Bay North"

# Ship Island East, DWH Regionwide TIG
as.factor(d$Latitude[d$ColonyName == "Ship Island East"]) %>% summary()
as.factor(d$Longitude[d$ColonyName == "Ship Island East"]) %>% summary()
# The westernmost location overlaps with another TIG site called "Ship Island"
# Change that westernmost location's coordinates to that of the easternmost location
d$Latitude[d$ColonyName == "Ship Island East" & d$Latitude == 30.21912] <- 30.238200
d$Longitude[d$ColonyName == "Ship Island East" & d$Longitude == -88.92156] <- -88.886700

rm(colony_mult_coords)



#### ---- Create unique Atlas code for each site ####

d$AtlasSiteCode<-NA
d$StateCode<-d$State %>% as.character()
d$StateCode[d$State=="Texas"]<-"TX"
d$StateCode[d$State=="Louisiana"]<-"LA"
d$StateCode[d$State=="Mississippi"]<-"MS"
d$StateCode[d$State=="Alabama"]<-"AL"
d$StateCode[d$State=="Florida"]<-"FL"

# Create a unique code by concatenating site-specific State, ColonyName, coordinates, and Provider
# create a unique number by turning the concatenated string into a factor, then integer
d$AtlasSiteCodeTemp<-paste0(d$State,d$ColonyName, 
                            d$Longitude, d$Latitude, d$DataProvider) %>% 
  as.factor() %>% as.integer()

# check that there is the same number of unique AtlasSiteCodeTemp as
# there is of unique combinations State/ColonyName/coordinates/Provider
d %>% distinct(State, ColonyName, Longitude, Latitude, DataProvider) %>% dplyr::count()
d %>% distinct(AtlasSiteCodeTemp) %>% dplyr::count()

d$AtlasSiteCodeTemp<-d$AtlasSiteCodeTemp+10000
d$AtlasSiteCodeTemp<-as.character(d$AtlasSiteCodeTemp)
d$AtlasSiteCode<-paste0(d$StateCode,"-",
                        substring(d$AtlasSiteCodeTemp,2))
d$AtlasSiteCodeTemp<-NULL
d$StateCode<-NULL

d %>% distinct(AtlasSiteCode) %>% dplyr::count()



#### ---- Assign a unique index for each row of data ####

# Order the data
d <- arrange(d, State, AtlasSiteCode, Year, Species)

# Create new column for row id
d <- d %>%
  dplyr::mutate(index = 1:n())

# Add 100,000 so rows start at 100,001 end at 136,861 (100,000 + number of rows)
d$index = d$index + 100000



#### ---- Flag rows with no Atlas metric data ####

d$HasAtlasMetric<-"Y"
d$HasAtlasMetric[is.na(d$Nests) & is.na(d$Pairs) & is.na(d$Adults)]<-"N"



#### ---- Change "Present" counts to "-1" ####

# "-1" indicates that Nests, Pairs, or "Adults" were present, but not counted.
# "-1" allows for simple flagging, sorting and filtering while having limited impact on
# count totals made in Esri Dashboards (like a value of "-9999" would)
d$Nests <- replace(d$Nests, d$Nests == "Present", -1)
d$Pairs <- replace(d$Pairs, d$Pairs == "Present", -1)
d$Adults <- replace(d$Adults, d$Adults == "Present", -1)



#### ---- Replace ranges by their midpoint value ####

# 12 observations from Alabama Audubon have a range of counts in "Pairs" and 8 in "Nests".
# Those values must be numerical.
# Use the midpoint of these ranges (original data is archived in dedicated column)

## Column "Nests"

# find rows with ranges
Nests <- d %>% filter(str_detect(Nests, "-")) %>% filter(!(Nests =="-1"))
# drop these from full dataset
d <- anti_join(d, Nests)
# calculate range midpoint and replace valye
Nests$first<-sub("-.*", "", Nests$Nests) %>% as.numeric()
Nests$last<-sub(".*-", "", Nests$Nests) %>% as.numeric()
Nests$midpoint<- Nests$last-(Nests$last-Nests$first)/2
Nests$Nests<-as.character(Nests$midpoint)
# remove temporary columns
Nests  <- subset(Nests , select = -c(first, last, midpoint) )
# add dataframe back to full dataset d
d <- rbind(d, Nests)


## column "Pairs"

# One row has a value of "500+" in column "Pairs"
d$Pairs[d$Pairs== "500+"] <- "500"
# find rows with ranges
Nests <- d %>% filter(str_detect(Pairs, "-")) %>% filter(!(Pairs =="-1"))
# drop these from full dataset
d <- anti_join(d, Nests)
# calculate range midpoint and replace valye
Nests$first<-sub("-.*", "", Nests$Pairs) %>% as.numeric()
Nests$last<-sub(".*-", "", Nests$Pairs) %>% as.numeric()
Nests$midpoint<- Nests$last-(Nests$last-Nests$first)/2
Nests$Pairs<-as.character(Nests$midpoint)
# remove temporary columns
Nests  <- subset(Nests , select = -c(first, last, midpoint) )
# add back to full dataset d
d <- rbind(d, Nests)

# transform columns Nest, Pairs, and Adults from character to numerical
d$Nests<-as.numeric(d$Nests)
d$Pairs<-as.numeric(d$Pairs)
d$Adults<-as.numeric(d$Adults)

rm(Nests)



#### ---- Reddish Egret morph ####

# For Reddish Egrets, morphs were sometimes collected
# but count values did not always show the distinction.
# The following script cleans up the Reddish Egret dataset

KEEP.2 <- d
# file.edit("./R/Atlas/2_Combine_all_data/3_Clean_ReddishEgret_morphs.R")
source("./R/Atlas/2_Combine_all_data/3_Clean_ReddishEgret_morphs.R")



#### ------  Double count problem ####

# Some colonies have more than one row per species per year per colony.
# This is mostly a FL Wadingbird Colony problem

KEEP.3 <- d
# file.edit("./R/Atlas/2_Combine_all_data/4_Fix_Double_counts.R")
source("./R/Atlas/2_Combine_all_data/4_Fix_Double_counts.R")



#### ---- Edit survey method ####

# For rows with a value of -1 ("Present") in column "Nests" or "Pairs"
# replace columns "Methods_XX" with "Presence/Absence"
d <- within(d, Method_Nests[Nests == -1] <- "Presence/Absence")
d <- within(d, Method_Pairs[Pairs == -1] <- "Presence/Absence")



#### ---- TIG Overlap problem ####

# The Gulfwide TIG dataset overlaps spatially and temporally with other datasets
# such that some colonies in the Atlas are surveyed/counted more than once per year
# by two different data providers.

KEEP.4 <- d
# file.edit("./R/Atlas/2_Combine_all_data/5_Manage_TIG_overlap.R")
source("./R/Atlas/2_Combine_all_data/5_Manage_TIG_overlap.R")



#### ---- Clean up, rename, and rearrange columns ####

d <- d %>% 
  select(-ColonyName) %>% 
  dplyr::rename(ProviderColonyCode = ColonyCode,
         AtlasFileName = File,
         ProviderNotes = Notes,
         ProviderAtlasNumber = AtlasNo,
         SurveyDate = Date,
         AtlasIndex = index,
         ProviderSubcolony = Subcolony,
         ProviderColonyStatus = Status)

d <- d %>%
  relocate(c(AtlasIndex, AtlasSiteCode, DataProvider, ProviderColonyName, 
             Latitude, Longitude, State), .before = Year) %>% 
  relocate(c(Identified_to_species), .after = Year) %>% 
  relocate(c(HasAtlasMetric), .after = Species) %>%
  relocate(c(Birds, All.birds_ad_juv, Chicks, Fledglings), .after = Adults) %>% 
  relocate(c(OriginalPairs), .before = Method_Pairs) %>% 
  relocate(c(OriginalAdults), .before = Method_Adults) %>% 
  relocate(c(Method_Others, SurveyVantagePoint_Others, SurveyDate, ProviderColonyCode,
             ProviderSubcolony), .before = ProviderAtlasNumber) %>% 
  relocate(c(DateReceived, AtlasFileName), .before = DataContact1)

d$Method_Nests <- droplevels(d$Method_Nests)
d$Method_Pairs <- droplevels(d$Method_Pairs)
d$Method_Adults <- droplevels(d$Method_Adults)
d$Method_Others <- droplevels(d$Method_Others)

d$SurveyVantagePoint_Nests <- droplevels(d$SurveyVantagePoint_Nests)
d$SurveyVantagePoint_Pairs <- droplevels(d$SurveyVantagePoint_Pairs)
d$SurveyVantagePoint_Adults <- droplevels(d$SurveyVantagePoint_Adults)
d$SurveyVantagePoint_Others <- droplevels(d$SurveyVantagePoint_Others)

# Add column with Years in string format, to be used for Category Selector filtering
d$Year_string<-paste0("y", d$Year)


#### ---- SAVE TO CSV ####

write.csv(d, paste0(getwd(),"/data_output/Atlas_Registry_",Sys.Date(),".csv"), row.names = FALSE)



#### ---- Export to ArcGIS Online ----

# Atlas ArcGIS Online platform uses three distinct versions of the main "d" dataset
# 1) A full version (in "long" format) will populate the main map and be used by Category Selectors
# 2) An horizontal version (in "wide" format) will populate graphs and tables
# 3) A summary version will populate the Site details tab

KEEP.5 <- d
# file.edit("./R/Atlas/2_Combine_all_data/6_Create_ArcGIS_datasets.R")
source("./R/Atlas/2_Combine_all_data/6_Create_ArcGIS_datasets.R")



############################################################################################
#################################### END ###################################################
############################################################################################