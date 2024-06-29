############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Texas Waterbird Society
# Data provided by Daniel Gao
# This script is to add newly acquired colony coordinates from Daniel Gao (GLO)
# to TX colonial waterbird database, for colonies where coordinates are missing

############################################################################################

## Started 2023-03-10 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)


##### Prepare Daniel Gao's data (coordinates) ####

# read in data
xy <- read.csv( "./data_original/Texas/Texas_Subcolonies_Missing_Coordinates_from_GLO_Rookeries_Polygon_Layer.csv")

# pull out only xy columns needed
xy<- select(xy, Colony.ID,Colony.Name, Colony.Code, Subcolony.code.KH, Subisland, Subcolony, Latitude, Longitude)

# remove special characters from colony code
xy$Colony.Code <- gsub("[[:punct:]]", "", xy$Colony.Code)

# remove space from colony code
xy$Colony.Code <- gsub(" ","", xy$Colony.Code)

# split Colony.Code into number (colony) and letter (sub-colony) codes
xy <- xy %>% separate_wider_position(cols = Colony.Code, c(Colony.Code = 6, Subcolony.Letter = 2), too_few = "align_start")

# change column names to match tcws data
xy<- xy %>% dplyr::rename(ColonyID = Colony.Code)
xy$ColonyID<- as.factor(xy$ColonyID)

# pull out only rows to match
xy<- select(xy, Colony.Name, ColonyID, Subcolony.code.KH, Latitude, Longitude)
# can now match to rows with missing coordinates using Colony.Code and Subcolony.code.KH



##### Prepare TCWS data (missing coordinates) ####

# TCWS data
tx <- read.csv("./data_original/Texas/TX_2010_2015_corrected_2022.12.08.csv")

# pull out rows that have 0,0 for lat longs
# also pull out 2 colonies that have incorrect coords (bc they are out over water)
# 600528: Mensell-Eckert Marsh Mounds
# 614105: GIWW Marker 43 Spoil
f <- filter(tx, Longitude == 0 | ColonyID == 600528| ColonyID == 614105)

# drop lat long columns
f <- subset(f, select = -c(Longitude, Latitude, ccap) )

# make colony id a factor
f$ColonyID<- as.factor(f$ColonyID)

# read in missing colonies so colony letter can be added
m <- read.csv("./data_original/Texas/Texas_colonies_missing_coordinates.csv")

# make colony id a factor
m$ColonyID<- as.factor(m$ColonyID)
# drop column
m <- subset(m, select = -c(Subcolony) )

# join missing colony letters to tcws rows missing coordintes
f<- left_join(f, m, by = c ("ColonyName", "ColonyID"))

remove(m)



##### Join data from TCWS (missing coordinates) and Daniel (coordinates) ####

new <- left_join(f, xy, by = c ("ColonyID", "Subcolony.code.KH"))

# looked at lat longs that are still NAs in new dataframe and
# doubled checked there wasn't a spelling error or something preventing matching. 
still_noxy  <-
  new %>%
  filter(is.na(Latitude))

# make colony name a factor
still_noxy$ColonyName<- as.factor(still_noxy$ColonyName)



#### Colonies that still do no have coordinates #######

unique(still_noxy$ColonyName)
# [1] Arroyo Colorado Spoil - a         Beneficial Use near Dunham Island      Mansfield Channel Spoil - a      
# [5] Mansfield Channel Spoil - b       San Jose- Carlos Bay              Big Bird Island - b               Champion Lake 6                  
# [9] Mad Island Slough Smith A         Pita Island / Humble Channel - o     Willow Dugout 

# Kennedy Causeway Islands - r == Chaney 94

# take a look at TGLO COLONIAL WATERBIRDS 2021 - COLONY NAME HELP excel sheet
# some of these have alternate names 


##### ----- Pull out rows with coords to save and try to use to fill in missing coords
# in Brent's data
# NOTE: These are only colonies that were missing coordinates in the beginning 
have_coords <- setdiff(new, still_noxy)
recombine <- have_coords # need this below to recombine for total TCWS data
have_coords = subset(have_coords, select = -c(Species, adults, nests, pairs, Subcolony, Status, year, OBJECTID) )
have_coords <- distinct(have_coords)
#write.csv(have_coords, "TCWS_w_daniel_updates.csv")


##### ----- Create new dataframe that combines rows that already had lat/longs and
# rows that just got new lat/longs added from Daniel

# pull rows that already had coordinates
previous_coords <- filter(tx, Longitude != 0 & Latitude != 0 & ColonyID != 600528 & ColonyID != 614105)
previous_coords <-  subset(previous_coords, select = -c(ccap))
previous_coords$Subcolony.code.KH <- ""
previous_coords$ColonyID<- as.factor(previous_coords$ColonyID)

# recombine is rows that had coords added from daniel
recombine <-  subset(recombine, select = -c(Colony.Name))

tcws_with_coords <- bind_rows(previous_coords, recombine)
#write.csv(tcws_with_coords , "TCWS_w_daniel_updates_2023.04.24.csv")


#### Fill in missing coordinates ####

# Beneficial Use near Dunham Island  --- got this one from David 28.1155, -96.934
still_noxy <- within(still_noxy, Latitude[ColonyName == 'Beneficial Use near Dunham Island'] <- 28.1155)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'Beneficial Use near Dunham Island' ] <- -96.934)

#	Third Chain of Islands-A
still_noxy <- within(still_noxy, Latitude[ColonyName == 'Third Chain of Islands-A'] <- 28.15584976)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'Third Chain of Islands-A' ] <- -96.87438007)

# Third Chain of Islands-C
still_noxy <- within(still_noxy, Latitude[ColonyName == 'Third Chain of Islands-C'] <- 28.15097723)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'Third Chain of Islands-C' ] <- -96.87274271)

# Big Bird Island - b
still_noxy <- within(still_noxy, Latitude[ColonyName == 'Big Bird Island - b'] <- 28.27689934)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'Big Bird Island - b' ] <- -96.7358017)

# Pita Island / Humble Channel - o
still_noxy <- within(still_noxy, Latitude[ColonyName == 'Pita Island / Humble Channel - o'] <- 27.59107369)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'Pita Island / Humble Channel - o' ] <- -97.25940058)

# Arroyo Colorado Spoil - a   coordinates from Justin Leclair (26.064703, -97.211999) didn't make sense bc they are much futher south than all the other Arroyo Colorado Spoils. so I guesstimated it is north of the other Arroyo Colorado Spoils
still_noxy <- within(still_noxy, Latitude[ColonyName == 'Arroyo Colorado Spoil - a'] <- 26.350018)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'Arroyo Colorado Spoil - a' ] <- -97.323925)

# San Jose- Carlos Bay   -- couldn't find coordinates for this so I chose a spot on san jose island near carlos bay  28.115359, -96.889068
still_noxy <- within(still_noxy, Latitude[ColonyName == 'San Jose- Carlos Bay'] <- 28.115359)
still_noxy <- within(still_noxy, Longitude[ColonyName == 'San Jose- Carlos Bay' ] <- -96.889068)



#### Colonies to remove #######

# Willow dugout -- no one seems to know where this is and there's no records of birds there
# Kennedy Causeway Islands - r -- Dave was unfamiliar w this colony and there are no records of birds there
# Mansfield Channel Spoil - a -- data is all either inactive or unsurveyed, no records of birds 
# Mansfield Channel Spoil - b -- data is all either inactive or unsurveyed, no records of birds
# Champion Lake 6 -- data is all either inactive or unsurveyed, no records of birds
# Mad Island Slough Smith A --data is all either inactive or unsurveyed, no records of birds

still_noxy  <- still_noxy %>% filter (ColonyName !=	'Willow Dugout' &
                                      ColonyName != 'Kennedy Causeway Islands - r' &
                                      ColonyName != 'Mansfield Channel Spoil - a' &
                                      ColonyName != 'Mansfield Channel Spoil - b' &
                                      ColonyName != 'Champion Lake 6' &
                                      ColonyName != 'Mad Island Slough Smith A')

# All rows have coordinates
# Ready to export table for GIS


#### Combine all rows ####

# drop column not needed
still_noxy  <-  subset(still_noxy , select = -c(Colony.Name))

# combine rows
tcws_with_coords <- bind_rows(tcws_with_coords, still_noxy)

# drop subcolony letter columns
tcws_with_coords <-  subset(tcws_with_coords, select = -c(Subcolony.code.KH))

# export table
#write.csv(tcws_with_coords, "TCWS_2010-2015_2023.05.16.csv")

# remove temporary dataframes
rm(f, have_coords, new, previous_coords, recombine, still_noxy, tx, xy)



##### ----- Drop add and rename some columns to prepare for alignment with other data

# remove columns
tcws_with_coords  <- subset(tcws_with_coords , select = -c(OBJECTID) )


# edit some columns
tcws_with_coords <- tcws_with_coords %>% 
  dplyr::rename(Year = year, Pairs = pairs,Adults = adults, 
                Nests = nests, ColonyCode = ColonyID)

# add columns
tcws_with_coords $State <- "Texas"
tcws_with_coords$DataProvider <- "Texas Colonial Waterbird Society"
tcws_with_coords$DateReceived <- "2023-02-24"



####### Add column Identified_to_species ####

# make Species a factor
tcws_with_coords$Species <- as.factor(tcws_with_coords $Species)
# look at species
levels(tcws_with_coords $Species)
# all are identified to species, so make a column thats all yes
tcws_with_coords$Identified_to_species <- "yes"

# Change "Reddish Egret - red morph" and "Reddish Egret - white morph"  to
# "Reddish Egret Dark Morph" & "Reddish Egret White Morph"
# to match other datasets
tcws_with_coords$Species <- recode_factor(tcws_with_coords$Species,  
                                          "Reddish Egret - red morph" = "Reddish Egret Dark Morph",
                                          "Reddish Egret - white morph" = "Reddish Egret White Morph")
#levels(tcws_with_coords$Species)

# remove black-bellied whistle duck (2 rows)  6/21/23
tcws_with_coords  <- tcws_with_coords %>% filter (Species !=	'Black-bellied Whistling-Duck')


# change to d for easier coding
d <- tcws_with_coords 
rm(tcws_with_coords)


##### Deal with duplicates ####

# make year a factor so its easier to search
d$Year<- as.factor(d$Year)

# run summary to look at duplicates
duplicates <- d %>%
  select( Year, ColonyName, Species, Pairs) %>%
  group_by( Year, ColonyName, Species) %>%
  dplyr::summarise(n = n())
duplicates<- filter(duplicates, n>1)

# some of these duplicates are exact so run unique to drop those
d <- unique(d)

# Coleto Creek   2012 - has both active and inactive for status - drop inactive set - 6 rows
d <- d %>% 
  filter(!(ColonyName== "Coleto Creek" & Year == "2012" & Status == "inactive" ))

# Coleto Creek   2013 - has both active and inactive for status - drop inactive set - 8 rows
d <- d %>% 
  filter(!(ColonyName== "Coleto Creek" & Year == "2013" & Status == "inactive" ))

# Green Lake   2013 - has both active and inactive for status - drop inactive set - 7 rows
d <- d %>% 
  filter(!(ColonyName== "Green Lake" & Year == "2013" & Status == "inactive" ))

# Chocolate Bayou BU4A   2015 - has both active and inactive for status - drop inactive set - 11 rows
d <- d %>% 
  filter(!(ColonyName== "Chocolate Bayou BU4A" & Year == "2015" & Status == "inactive" ))

# Green Island Spoils - h   2013 --- has both active and inactive for status - drop inactive set - 2 rows
d <-  d %>% 
  filter(!(ColonyName== "Green Island Spoils - h" & Year == "2013" & Status == "inactive" ))

# Second Chain of Islands-B  2013 --- has both active and inactive for status - drop inactive set - 14 rows
d <-  d %>% 
  filter(!(ColonyName== "Second Chain of Islands-B" & Year == "2013" & Status == "inactive" ))

# Pita Island / Humble Channel - k 2013, --- 2 statuses inactive and no land feature. Drop inactive
d <-  d %>% 
  filter(!(ColonyName== "Pita Island / Humble Channel - k" & Year == "2013" & Status == "inactive" ))

# Marker 77A Spoil Island (NM 155) 2013 --- 2 statuses inactive and no land feature. Drop inactive
d <-  d %>% 
  filter(!(ColonyName== "Marker 77A Spoil Island (NM 155)" & Year == "2013" & Status == "inactive" ))

# Marker 139-155 Spoil  (19-35) - a 2013 ---2 statuses inactive and no land feature. Drop inactive
d <-  d %>% 
  filter(!(ColonyName== "Marker 139-155 Spoil  (19-35) - a" & Year == "2013" & Status == "inactive" ))

# DM31-34 (NM65-74) - c 2013 Black Skimmer --- has both active and inactive for status - drop inactive set - 1 row
d <-  d %>% 
  filter(!(ColonyName== "DM31-34 (NM65-74) - c" & Year == "2013" & Status == "inactive" ))

# West Nueces Bay 51 E - a 2013 --- has both active and inactive for status - drop active set - 1 row
d <-  d %>% 
  filter(!(ColonyName== "West Nueces Bay 51 E - a" & Year == "2013" & Status == "active" ))

# South Yarbourough Pass (NM 41-47) - a 2013 --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "South Yarbourough Pass (NM 41-47) - a" & Year == "2013" & Status == "inactive" ))

# South Yarbourough Pass (NM 41-47) - d - a 2013 --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "South Yarbourough Pass (NM 41-47) - d" & Year == "2013" & Status == "inactive" ))

# Naval Air Station Islands - I 2013 --- 2 statuses inactive and no land feature. Drop inactive - 3 row
d <-  d %>% 
  filter(!(ColonyName== "Naval Air Station Islands - I" & Year == "2013" & Status == "no land feature" ))

# West Nueces Bay 51 E - d 2013 --- has both active and inactive for status - drop active set - 1 row
d <-  d %>% 
  filter(!(ColonyName== "West Nueces Bay 51 E - d" & Year == "2013" & Status == "inactive" ))

# Pita Island / Humble Channel - c 2013 --- has 2 different coordinates, keep the one that matches the access database from Woody - 5 rows
d <-  d %>% 
  filter(!(ColonyName== "Pita Island / Humble Channel - c" & Year == "2013" & Latitude > 27.59370 ))

# Naval Air Station Islands - n 2013 --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Naval Air Station Islands - n" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - aa 2013 --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - aa" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - bb --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - bb" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - cc --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - cc" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - p --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - p" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - t --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - t" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - v --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - v" & Year == "2013" & Status == "inactive" ))

# Kennedy Causeway Islands - w --- 2 statuses inactive and no land feature. Drop inactive - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Kennedy Causeway Islands - w" & Year == "2013" & Status == "inactive" ))

# Big Bird Island 2010
# there are 2 colony codes for this colony name
# I'm dropping the one that doesn't match the subcolonies also in the data - 1 row
d <-  d %>% 
  filter(!(ColonyName== "Big Bird Island" & Year == "2010" & ColonyCode == "609323" ))


# Naval Air Station Islands - f 2010, 2011, 2012, 2013
# multiples in each year w multiple coordinates

# 2013 --- 3 statuses: no land feature, inactive, and active, there are counts so drop inactive and no land featre, drops 4 rows
d <-  d %>% 
  filter(!(ColonyName== "Naval Air Station Islands - f" & Year == "2013" & Status == "no land feature"))

d <-  d %>% 
  filter(!(ColonyName== "Naval Air Station Islands - f" & Year == "2013" & Status == "inactive"))

# 2012, 2013 - counts are the same but for 2 different coordinates,
# both of which are in the access database. 
#Based on the location of e, keeping this one: 27.67061, -97.24846 --- drop 10 rows
d <-  d %>% 
  filter(!(ColonyName== "Naval Air Station Islands - f"  & Latitude < 27.67061 ))

# Yellow House Spoil (NM 162) --- exact duplicates but 2 different coordinates, keep this one: 27.416718. in the access database the info doesnt seem right for the other set - drops 50 rows
d <-  d %>% 
  filter(!(ColonyName== "Yellow House Spoil (NM 162)"  & Latitude < 27.416718 ))


# run summary to look at duplicates again
duplicates <-
  d %>%
  select( Year, ColonyName, Species, Pairs) %>%
  group_by( Year, ColonyName, Species) %>%
  dplyr::summarise(n = n())
duplicates<- filter(duplicates, n>1)
# No more duplicates
rm(duplicates)


##### Capitalize the subcolony letter at the end of ColonyName 

#  pull out rows that have a - ( and hopefully thus a subcolony letter) in their colony name 
x <- 
  d %>% 
  filter(str_detect(ColonyName, "-"))

# from x, remove colonynames that have a dash not related to subcolony (using a dash is imperfect)
x <- x %>% 
  filter(ColonyName != "Bahia Grande- Bird Island" & 
         ColonyName != "DM31-34 (NM65-74)" &
         ColonyName != "Marker 103-117 Spoil (NM 207-221)" &
         ColonyName != "Marker 139-155 Spoil  (19-35)" &
         ColonyName != "Marker 37 - 38 Spoil NM 79" &
           ColonyName != "Marker 63-65 Spoil (NM 127-131)" &
           ColonyName != "North Yarborough Pass (NM 37-39)" &
           ColonyName != "South Yarbourough Pass (NM 41-47)" &
           ColonyName != "GIWW Marker 55-57 Spoil" &
           ColonyName != "Long Reef - Deadman Islands" &
           ColonyName != "Lavaca Bay Spoil (51-63)" &
           ColonyName != "Lavaca Bay Spoil (63-77)" &
           ColonyName != "Matagorda Bay Spoil 39-51" &
           ColonyName != "Dow Gate A-40" &
           ColonyName != "HGNC Mid-Bay Island" &
           ColonyName != "Vingt et un - a- long" &
           ColonyName != "Hull-Daisetta Marsh (NRCS)" &
           ColonyName != "East Nueces Bay - E 50 A" &
           ColonyName != "Mensell-Eckert Marsh Mounds" &
           ColonyName != "San Jose- Carlos Bay" 
           )

# remove ones that are left from d 
d<- setdiff(d, x)


# # create a function to capitalize the last letter
mycap <- function(mystr = "") {
  # a: the string without the last character
  a <- substr(mystr, 1, nchar(mystr)-1)
  # b: only the last character 
  b <- substr(mystr, nchar(mystr), nchar(mystr))
  # lower(a) and upper(b)
  paste(a, toupper(b), sep = "")
}

# run the function to capitalize 
x$ColonyName <- mycap(x$ColonyName)

# rename weird ones with double letters
x <- within(x, ColonyName[ColonyName == 'Kennedy Causeway Islands - bB'] <- "Kennedy Causeway Islands - BB")
x <- within(x, ColonyName[ColonyName == 'Kennedy Causeway Islands - fF'] <- "Kennedy Causeway Islands - FF")
x <- within(x, ColonyName[ColonyName == 'Kennedy Causeway Islands - aA'] <- "Kennedy Causeway Islands - AA")
x <- within(x, ColonyName[ColonyName == 'Kennedy Causeway Islands - cC'] <- "Kennedy Causeway Islands - CC")
x <- within(x, ColonyName[ColonyName == 'Kennedy Causeway Islands - eE'] <- "Kennedy Causeway Islands - EE")

# done making modifications to x, add it back to the full dataset d
d<- rbind(d,x )

#remove x
rm(x)



####### Deal with subcolonies ####

# According to Beau Hardegree, some subcolonies that say FALSE are
# the sum of all the subcolonies that say TRUE
# For those, we need to delete totals because they are summed duplicates of the subcolonies

# Change 0s and 1s in Subcolony column to false and true 
d<- within(d, Subcolony[Subcolony == '0'] <- FALSE)
d<- within(d, Subcolony[Subcolony == '1'] <- TRUE)

# New dataframes - subcolony true to one and subcolony false to the other
t <- d %>% filter (Subcolony == TRUE)
f <- d %>% filter (Subcolony == FALSE)

# drop all columns but colonycode and year from t
t <- select(t, ColonyCode, Year)
# then do unique so its just colony and year 
t <- unique(t)

# add a new column (this is just to help me keep track of things)
t$subcolony_present <- "yes"

# join those t to only falses (inner_join == only the info that were in both datasets are kept in the final dataset)
# this outcome is colonies that have falses (not a subcolony) that also have trues (a subcolony)
# we want to drop those falses
who_to_drop <- inner_join(f, t, by = c( 'Year', 'ColonyCode'))

# drop the subcolony_present column
who_to_drop <- subset(who_to_drop, select = -c(subcolony_present))

# the difference between d and who_to_drop should be d with the "total" colonies that
# also have subcolonies dropped
g<- setdiff(d, who_to_drop)


##### ----- Check if it worked
# make a summary table
# duplicates2 <-
#   g %>%
#   select( Year, ColonyCode, Subcolony) %>%
#   group_by( Year, ColonyCode, Subcolony) %>%
#   summarise(n = n())
# Then flip the summary table to wider format w true and false beside each other.
# Look to see if there is a row with values in both true and false. 
# There aren't
# check <- duplicates2 %>% pivot_wider(names_from = Subcolony, values_from = n)
# rm(duplicates, duplicates2, check)

# Make g the new d and remove temporary dataframes
d <- g 
rm( f, t, who_to_drop,  g, mycap)


##### ----- Check if there are multiple colony names per colony number

# m<-
# d %>%
#     select( ColonyCode, ColonyName, Subcolony) %>%
#     group_by( ColonyCode, ColonyName, Subcolony) %>%
#     summarise(n = n())

# 609321 is shared by both Big Bird Island a b and Mosquito Point Spoil. They have different coordinates tho so I think this is just a texas database problem. Atlas should be ok since it'll be done by colony name 



##### Corrections and alterations align names among datasets ####

# Third Chain of Islands- A has an extra space in the name
d <- within(d, ColonyName[ColonyName == 'Third Chain of Islands- A'] <- "Third Chain of Islands-A")

# 288 Acre Mash Boliva
d <- within(d, ColonyName[ColonyName == '288 Acre Mash Bolivar'] <- "288 Acre Marsh Bolivar")

# Long Reef - Deadman Islands-B
d <- within(d, ColonyName[ColonyName == 'Long Reef - Deadman Islands-B'] <- "Long Reef - Deadman Islands - B")
d <- within(d, ColonyName[ColonyName == 'Long Reef - Deadman Islands- A'] <- "Long Reef - Deadman Islands - A")

# Remove Cedar Lakes 2, 3, 4 - all NA and all the same location. then drop the number
d <- d %>% 
  filter(!(ColonyName== "Cedar Lakes 2" | ColonyName== "Cedar Lakes 3" | ColonyName== "Cedar Lakes 4"))
d <- within(d, ColonyName[ColonyName == 'Cedar Lakes 1'] <- "Cedar Lakes")

# Goat Island Spoil
d <- within(d, Latitude[ColonyName  == 'Goat Island Spoil'] <- 	29.515295)
d <- within(d, Longitude[ColonyName  == 'Goat Island Spoil'] <- -94.523327)


#### ---- Remove "0" when they represent lack of data instead of true absence ####
# In this file, 0 has obviously been used in places where no count was recorded:
# for example: 3274 nest, 3274 pairs and "0" adults. 
# This creates issues in the Atlas, since other providers have recorded true absence using "0".

# The more conservative approach is to remove "0" in Nests and Adults when Pairs >= 1.
# If there is one Pair, then there must be a Nest, otherwise, these should be counted as 2 Adults
# If there is one Pair, then there must at least 2 adults.

d$Adults[(d$Pairs > 0) & (d$Adults == 0)] <- NA
d$Nests[(d$Pairs > 0) & (d$Nests == 0)] <- NA

d$SpCountMethod <- NA
d$SurveyVantagePoint <- NA

# View(d[!(d$Species== "#N/A"),])

##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/TCWS.csv")


############################################################################################
#################################### END ###################################################
############################################################################################