############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Upper Texas Coast 2021 and 2022
# Datasets provided by Woody Woodrow (U.S. Fish and Wildlife Service)
# 
# 2020 data added in on 10/2/2023
# (raw datasheets needed to be entered, which caused this extended delay) 

############################################################################################

## Started 2023-06-27 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

# read in data and names
d21 <- read.csv("./data_original/Texas/Upper_Data_Entry_2021.csv") 
d22<- read.csv("./data_original/Texas/Upper_Data_Entry_2022.csv")
d20 <- read.csv("./data_original/Texas/data_entry_TX_upper_coast_2020.csv")


# add year column
d21$Year <-  "2021"
d22$Year <-  "2022"

# add count method column

d21$SpCountMethod <-NA
d22$SpCountMethod <- NA

# combine 2021 and 2022 data
d <- rbind(d21, d22)

# remove individual datasets
rm(d21, d22)

# remove special characters from colony code
d$Colony.Code <- gsub("[[:punct:]]", "", d$Colony.Code)


# Change some column names
d <- d %>% rename(Date = Survey.Date,
                  ColonyName = Colony.Name,
                  ColonyCode = Colony.Code,
                  Nests = Number.NESTS,
                  Pairs = Number.PAIRS,
                  Adults = Number.ADULTS,
                  Notes = NOTES,
                  SurveyVantagePoint = Survey.Vantage.Point)


# Remove some columns
d <- subset(d, select = -c(Start.Time, End.Time, Observers, Colony.Type))
d <- subset(d, select = -c(Predominant.Repro.Stage..Enter.Code.Numbers., Survey.Type.NESTS, Survey.Type.ADULTS, Survey.Type.PAIRS))

d20 <- subset(d20,  select = -c(Observers, Subcolony))


# combine 2021,2022 and 2020 data
d <- rbind(d, d20)

# remove individual datasets
rm(d20)


# Add some columns
#data provider
d$DataProvider <-  "Texas Colonial Waterbird Society"
d$DateReceived <- "2023-06-21"

#state
d$State <- "Texas"


##### ----- change species names to match the rest of the data

# Reddish Egret various forms to dark morph
d<- within(d, Species[Species == 'Reddish Egret - Red Morph' |  
                        Species == 'Reddish Egret red morph' | 
                        Species == "Reddish Egret- Red Phase" |
                        Species == 'Reddish Egret (Red)' |
                        Species == 'Reddish Egret Red'] <- "Reddish Egret Dark Morph")

# Reddish Egret various forms to white morph
d<- within(d, Species[Species == 'Reddish Egret White' |  
                        Species == 'Reddish Egret white morph' | 
                        Species == "Reddish Egret - White Morph" |
                        Species == 'Reddish Egret (White)' |
                        Species == 'Reddish Egret White'] <- "Reddish Egret White Morph")


# Black-crowned Night Heron
d<- within(d, Species[Species == 'Black-crowned Night Heron'] <- "Black-crowned Night-Heron")

# Caspian tern
d<- within(d, Species[Species == 'Caspian tern'] <- "Caspian Tern")

# Cattle Egret
d<- within(d, Species[Species == 'Cattle egret'] <- "Cattle Egret")

# Double Crested Cormorant
d<- within(d, Species[Species == 'Double Crested Cormorant'] <- "Double-crested Cormorant")

# Forester Tern
d<- within(d, Species[Species == 'Forester Tern'] <- "Forster's Tern")

# Gull billed tern
d<- within(d, Species[Species == 'Gull billed tern'] <- "Gull-billed Tern")

# Laughing gull
d<- within(d, Species[Species == 'Laughing gull'] <- "Laughing Gull")

# Least tern
d<- within(d, Species[Species == 'Least tern'] <- "Least Tern")

# Neotrop. Cormorant
d<- within(d, Species[Species == 'Neotrp. Cormorant'| 
                        Species == 'Neotrop. Cormorant'|
                        Species == 'Neotrp. Cormorant'| 
                        Species == 'Neotropic Comorant' |
                        Species == 'Neotropical Cormorant'] <- "Neotropic Cormorant")

# Roseate Spoonbill
d<- within(d, Species[Species == 'Rosette Spoonbill'] <- "Roseate Spoonbill")

# Tri-colored Heron
d<- within(d, Species[Species == 'Tri-colored Heron'] <- "Tricolored Heron")

# White Pelican
d<- within(d, Species[Species == 'White Pelican'] <- "American White Pelican")

# Yellow-crowned Night Heron
d<- within(d, Species[Species == 'Yellow-crowned Night Heron'] <- "Yellow-crowned Night-Heron")

# make species a factor
d$Species<- as.factor(d$Species)
levels(d$Species)


# check to make sure everyone is IDed to species
# add column for identified to species
d$Identified_to_species <- "yes"


##### ----- Fix lats and long that are flipped
# latitude should be ~ 30
# longitude should be ~ -90

# pull out rows with flipped latlongs 
flip <- d %>%filter(Latitude< 0)

# drop flipped rows from d
d <-  setdiff(d, flip)

# rename columns
flip <- flip %>% rename(Long = Latitude,
                        Latitude = Longitude)
flip <- flip %>% rename(Longitude = Long)


# add re-flipped rows back to d
d <-  bind_rows(d, flip)

rm(flip)



##### ----- Some rows are missing lat/longs

#pull out rows without that are NA or blank
noxy <- d %>%filter(Latitude< 0 | is.na(Latitude))

# drop noxy rows from d
d <-  setdiff(d, noxy)

# make list of coordinates from the rest of the data that already have coordinates
# pull needed columns
coords<- d %>% select(ColonyName, ColonyCode, Latitude, Longitude)
coords <- distinct(coords)

t<- left_join(noxy, coords, by = c("ColonyName", "ColonyCode"))

# relocation Latitude and Longitude columns for ease of viewing
t  <- t  %>% relocate(Latitude.y, .before = Latitude.x)
t  <- t  %>% relocate(Longitude.y, .before = Longitude.x)

# drop old lat long column
t <- subset(t, select = -c(Latitude.x, Longitude.x))

# rename new lat and long
t <- t %>% rename(Latitude = Latitude.y,
                  Longitude = Longitude.y)

# recombine d with t 
d <-  bind_rows(d, t)

rm(coords, noxy, t)



##### ----- General clean up

# coords that are added come from either the total atlas data already collected
# from Tx or the access database sent by Woody in late June 2023 or from within this data

# Armand Bayou Nature Center (West Bank) needs long to be negative
d <- within(d, Longitude[ColonyName == 'Armand Bayou Nature Center (West Bank)'] <- '-95.0826')

# Swan Lake needs colony code and lat long, its in d
d <- within(d, Longitude[ColonyName == 'Swan Lake'] <- '-94.895')
d <- within(d, Latitude[ColonyName == 'Swan Lake'] <- '29.35277778')
d <- within(d, ColonyCode[ColonyName == 'Swan Lake'] <-'600420')
d <- within(d, ColonyName[ColonyName == 'Swan Lake'] <-'Swan Lake Islands')

# JigSaw needs coordinates and name fixed
d <- within(d, ColonyName[ColonyName == 'Jig Saw' | ColonyName == 'Jigsaw Island' ] <- 'Jig Saw Island')
d <- within(d, Longitude[ColonyName == 'Jig Saw Island'] <- '-94.8938888900')
d <- within(d, Latitude[ColonyName == 'Jig Saw Island'] <- '29.2819444400')

# Struvelucy needs coordinates
d <- within(d, Longitude[ColonyName == 'Struvelucy'] <- '-94.88833333')
d <- within(d, Latitude[ColonyName == 'Struvelucy'] <- '29.28388889')

# Smith Point Is need coordinates
d <- within(d, Longitude[ColonyName == 'Smith Point Island'] <- '-94.80694444')
d <- within(d, Latitude[ColonyName == 'Smith Point Island'] <- '29.53694444')

# rename to Marker 52 Spoil Island and update coordinates
d <- within(d, ColonyName[ColonyCode == '600422'] <- 'Marker 52 Spoil Island')
d <- within(d, Longitude[ColonyName == 'Marker 52 Spoil Island'] <- '-94.93277778')
d <- within(d, Latitude[ColonyName == 'Marker 52 Spoil Island'] <- '29.29')	

# Dow Gates coordinates
d <- within(d, ColonyName[ColonyCode == '610104'] <- 'Dow Gate A-40')
d <- within(d, Longitude[ColonyName == 'Dow Gate A-40'] <- '-95.31194444')
d <- within(d, Latitude[ColonyName == 'Dow Gate A-40'] <- '28.96083333')	

# Tepco #2 coordinates
d <- within(d, Longitude[ColonyName == 'Tepco #2'] <- '-94.1108')
d <- within(d, Latitude[ColonyName == 'Tepco #2'] <- '30.042708')	

# Atkinson Marsh coordinates
d <- within(d, Longitude[ColonyCode == '600555'] <- '-94.1108')
d <- within(d, Latitude[ColonyCode == '600555'] <- '30.042708')	

# Point Hunt - change incorrect colonycode, change name to match earlier data
d <- within(d, ColonyCode[ColonyName == 'Point Hunt'] <- '601122')
d <- within(d, ColonyName[ColonyCode == '601122'] <- 'Point Hunt Island')
d <- within(d, Longitude[ColonyCode == '601122'] <- '-93.88611111')
d <- within(d, Latitude[ColonyCode == '601122'] <- '29.74722222')	

# HGNC Mid Bay Island coordinates
d <- within(d, Longitude[ColonyCode == '600553'] <- '-94.9178')
d <- within(d, Latitude[ColonyCode == '600553'] <- '29.5779')	
d <- within(d, ColonyName[ColonyCode == '600553'] <- 'HGNC Mid-Bay Island')

# Fuel Island @ STP - remove space and coordinates
d <- within(d, ColonyName[ColonyName == 'Fuel Island @ STP'] <- 'Fuel Island @STP')
d <- within(d, Longitude[ColonyCode == '610144'] <- '-96.0517')
d <- within(d, Latitude[ColonyCode == '610144'] <- '28.7963')	

# 600260 Vingt et un New Sandy
d <- within(d, Longitude[ColonyCode == '600260'] <- '-94.775')
d <- within(d, Latitude[ColonyCode == '600260'] <- '29.55388889')	

# Assign Old Gulf Cut a colonycode
d <- within(d, ColonyCode[ColonyName == 'Old Gulf Cut 1' | ColonyName == 'Old Gulf Cut 2'| ColonyName == 'Old Gulf Cut 3' | ColonyName == 'Old Gulf Cut 4'] <- '610150')

# Hidden Colony HSC coordinates and change name
d <- within(d, Longitude[ColonyName == 'Hidden Colony HSC'] <- '-94.97835')
d <- within(d, Latitude[ColonyName == 'Hidden Colony HSC'] <- '29.68862')	
d <- within(d, ColonyName[ColonyName == 'Hidden Colony HSC'] <- 'HSC Hidden Colony')

# Vingt et un New Shell coordinates
d <- within(d, Longitude[ColonyCode == '600263'] <- '-94.7722222200')
d <- within(d, Latitude[ColonyCode == '600263'] <- '29.5486111100')

# Burnett Bay S. mound coords
d <- within(d, Longitude[ColonyCode == '600169'] <- '-95.064444')
d <- within(d, Latitude[ColonyCode == '600169'] <- '29.77233056')

#Burnett Bay N. mound coords
d <- within(d, Longitude[ColonyCode == '600168'] <- '-95.063333')
d <- within(d, Latitude[ColonyCode == '600168'] <- '29.77593')

# St. Mary's Island lat/long for 2022 is in weird format
d <- within(d, Longitude[ColonyCode == '600166'] <- '-95.0237')
d <- within(d, Latitude[ColonyCode == '600166'] <- '29.4403')

# Armand Bayou Nature Center (East Bank) long is not a decimal and seems wrong. assigned in the same lat long at the other armand nat center
d <- within(d, Longitude[ColonyName == 'Armand Bayou Nature Center (East Bank)'] <- '-95.082636')
d <- within(d, Latitude[ColonyName == 'Armand Bayou Nature Center (East Bank)'] <- '29.573792')	



##### ----- replace species blanks with "#N/A"

# change species column to a character
d$Species <- as.character(d$Species)

# This makes the blanks NAs
d["Species"][d["Species"] == ""] <- "#N/A"



##### ----- Minor changes to SurveyVantagePoint
d <- within(d, SurveyVantagePoint[SurveyVantagePoint == 'On-Site Visit'] <- 'On-site visit')
d <- within(d, SurveyVantagePoint[SurveyVantagePoint == 'View from Adjacent Area'] <- 'Adjacent')

d$SurveyVantagePoint <- as.factor(d$SurveyVantagePoint )
levels(d$SurveyVantagePoint)



##### ----- Duplicates

# run summary to look at duplicates
duplicates <- d %>%
  select( Year, ColonyName, Species, Pairs) %>%
  group_by( Year, ColonyName, Species) %>%
  summarise(n = n())

# there is only one duplicate: 	2021 - Marker 52 Spoil Island - Brown Pelican
# I do not believe we have access to this raw datasheet so I looked a previous surveys 
# of this site and the higher number of nests and pairs make more sense.
# Keep that one and delete the other
d <- d %>% 
  filter(!(ColonyCode== "600422" & Year == "2021" & Adults == "32" ))

# Remove the dash in the remaining row
d <- within(d, Adults[Adults == '-'] <- '')

rm(duplicates)



####### ------ Look if there are multiple colony names per colony number

m <- d %>%
    select( ColonyCode, ColonyName) %>%
    group_by( ColonyCode, ColonyName) %>%
    summarise(n = n())



####### Pearland JHC has some issues that needs fixing
# create a dataframe with the correct info from the access database
df <- data.frame(ColonyName=c("Pearland JHEC Island 1", "Pearland JHEC Island 2", 
                              "Pearland JHEC Island 3"),
                 ColonyCode=c(600485, 600486, 600487),
                 Longitude=c(-95.312079, -95.308544, -95.307626),
                 Latitude=c(29.54302, 29.543553, 29.543383))

# Pull out only Pearland rows
pearland <- filter(d, ColonyCode==600485| ColonyCode==600486 |ColonyCode==600487)

# drop those from full dataset
d <- setdiff(d, pearland)

# remove the - from ColonyName
pearland$ColonyName <- gsub("[[:punct:]]", " ", pearland$ColonyName)

# drop colonycode and lat and long
pearland <- subset(pearland, select = -c(ColonyCode, Latitude, Longitude))

# join df to pearland
check <- inner_join(pearland, df, by = "ColonyName")

# add pearland back to d
d <- rbind(d, check)

# remove dataframes 
rm(check, df, pearland)


####### Burnett Bay Mounds N & S have slightly different names
d<- within(d, ColonyName[ColonyCode == '600169'] <- "Burnet Bay S. Mound")
d<- within(d, ColonyName[ColonyCode == '600168'] <- "Burnet Bay N. Mound")

####### High Island High Island Rookery
d<- within(d, ColonyName[ColonyCode == '600270'] <- "High Island")
d<- within(d, Latitude[ColonyCode == '600270'] <- 29.57416667)
d<- within(d, Longitude[ColonyCode == '600270'] <- -94.38944444)

####### Rollover Pass
d<- within(d, ColonyName[ColonyCode == '600300'] <- "Rollover Pass")
d<- within(d, Latitude[ColonyCode == '600300'] <- 29.51694444)
d<- within(d, Longitude[ColonyCode == '600300'] <- -94.50583333)

####### Mustang Bayou Island (PA 67)
d<- within(d, ColonyName[ColonyCode == '600500'] <- "Mustang Bayou Island (PA 67)")
d<- within(d, Latitude[ColonyCode == '600500'] <- 29.16777778)
d<- within(d, Longitude[ColonyCode == '600500'] <- -95.12694444)

#######  288 Acre Marsh Bolivar
d<- within(d, ColonyName[ColonyCode == '600554'] <- "288 Acre Marsh Bolivar")
d<- within(d, Latitude[ColonyCode == '600554'] <- 29.419825)
d<- within(d, Longitude[ColonyCode == '600554'] <- -94.742767)

####### Atkinson Marsh M0 levees (should be M9)
d<- within(d, ColonyName[ColonyCode == '600555'] <- "Atkinson Marsh M9 Levees")
d<- within(d, Latitude[ColonyCode == '600555'] <- 29.634925)
d<- within(d, Longitude[ColonyCode == '600555'] <- -94.933972)

####### Van Road - needs to match previous years
d<- within(d, ColonyName[ColonyCode == '600152'] <- "Van/Warner Rd.")
d<- within(d, Latitude[ColonyCode == '600152'] <- 29.856903)
d<- within(d, Longitude[ColonyCode == '600152'] <- -95.105356)

####### St Mary's Island - needs to match previous years
d<- within(d, ColonyName[ColonyCode == '600166'] <- "St. Marys Island")
d<- within(d, Latitude[ColonyCode == '600166'] <- 29.73449)
d<- within(d, Longitude[ColonyCode == '600166'] <- -95.04374)

####### Vingt et un New Sandy- needs to match previous years
d<- within(d, ColonyName[ColonyCode == '600260'] <- "Vingt et un")

####### Vingt et un New Sandy- needs to match previous years
d<- within(d, ColonyName[ColonyCode == '600299'] <- "Anahuac NWR Gulf Beach")

#######  Jumbilee Cove / Live Oak Grove - needs to match previous years
d<- within(d, ColonyName[ColonyName == 'Jumbilee Cove'] <- "Jumbilee Cove / Live Oak Grove")
d<- within(d, ColonyCode[ColonyName == 'Jumbilee Cove / Live Oak Grove'] <- "600548")

####### HGNC Evia Island - needs to match previous years
d<- within(d, ColonyName[ColonyName == 'Evia Island'] <- "HGNC Evia Island")

#######  West Bay Mooring- needs to match previous years
d<- within(d, ColonyName[ColonyName == 'West Bay Mooring'] <- "West Bay Mooring Facility")

#######  San Luis Pass - Galveston - needs to match previous years
d<- within(d, ColonyName[ColonyName == 'San Luis Pass - Galveston'] <- "San Luis Pass")
d<- within(d, Latitude[ColonyCode == '600580'] <- 29.09500)
d<- within(d, Longitude[ColonyCode == '60580'] <- -95.11083333)

####### Carancuhua Cove Terraces - spelling erroR and coordinates don't quite match
d<- within(d, ColonyName[ColonyName == 'Carancuhua Cove Terraces'] <- "Carancahua Cove Terraces")
d<- within(d, Latitude[ColonyCode == '600549'] <- 29.20638889)
d<- within(d, Longitude[ColonyCode == '600549'] <- -94.97583333)

####### San Luis Island - Coordinates don't quite match, names slightly different
d<- within(d, ColonyName[ColonyName == 'San Luis Pass County Park'] <- "San Luis Island")
d<- within(d, Latitude[ColonyCode == '600561'] <- 29.07694444)
d<- within(d, Longitude[ColonyCode == '600561'] <- -95.13000 )



####### ------ Corrections and alterations to make coordinates align among datasets

# most of the time, coordinates are slightly different but on the same island/beach/etc..
# In these cases I revert to the older coordinates (from 2016-2019 dataset)

# Dressing Point
d <- within(d, Latitude[ColonyName == 'Dressing Point'] <- 28.73083333)
d <- within(d, Longitude[ColonyName == 'Dressing Point'] <- -95.760)

# Big Reef
d <- within(d, Latitude[ColonyName == 'Big Reef'] <- 29.33694444)
d <- within(d, Longitude[ColonyName == 'Big Reef'] <- -94.73277778)

# Atkinson Island
d <- within(d, Longitude[ColonyName == 'Atkinson Island'] <- -94.97277778)

# Bay Harbor Bar
d <- within(d, Latitude[ColonyName == 'Bay Harbor Bar'] <- 29.13583333)
d <- within(d, Longitude[ColonyName == 'Bay Harbor Bar'] <- -95.07777778)

# Champion Lake (TRNWR) #1
d <- within(d, Latitude[ColonyName == 'Champion Lake (TRNWR) #1'] <- 29.91663889)

# Gangs Bayou
d <- within(d, Latitude[ColonyName == 'Gangs Bayou'] <- 29.25194444)

# Goat Island
d <- within(d, Latitude[ColonyName == 'Goat Island'] <- 29.73583333)

# HGNC Evia Island
d <- within(d, Latitude[ColonyName == 'HGNC Evia Island'] <- 29.42810)
d <- within(d, Longitude[ColonyName == 'HGNC Evia Island'] <- -94.76390)

# hsc hidden colony
d <- within(d, Longitude[ColonyCode == '600183'] <- '-94.97835')
d <- within(d, Latitude[ColonyCode == '600183'] <- '29.68862')

# Alexander Island
d <- within(d, Longitude[ColonyCode == '600161'] <- '-95.03083333')
d <- within(d, Latitude[ColonyCode == '600161'] <- '29.72777778')

# Chocolate Bayou BU4A
d <- within(d, Latitude[ColonyName == 'Chocolate Bayou BU4A'] <- 29.205562)
d <- within(d, Longitude[ColonyName == 'Chocolate Bayou BU4A'] <- -95.178824)

# Kanaloa Spoil
d <- within(d, Latitude[ColonyName == 'Kanaloa Spoil'] <- 29.292558)
d <- within(d, Longitude[ColonyName == 'Kanaloa Spoil'] <- -94.93788)

# NASA Johnson Space Center
d <- within(d, Latitude[ColonyName == 'NASA Johnson Space Center'] <- 29.557173)
d <- within(d, Longitude[ColonyName == 'NASA Johnson Space Center'] <- -95.081941)

# STP Cooling Reservoir
d <- within(d, Latitude[ColonyName == 'STP Cooling Reservoir'] <- 28.76638889)
d <- within(d, Longitude[ColonyName == 'STP Cooling Reservoir'] <- -96.04944444)

# Old Gulf Cut 1
d <- within(d, Latitude[ColonyName == 'Old Gulf Cut 1'] <- 28.7110539)
d <- within(d, Longitude[ColonyName == 'Old Gulf Cut 1'] <- -95.88324739)

# Josie Lake #2
d <- within(d, Latitude[ColonyName == 'Josie Lake #2'] <- 30.1080555)
d <- within(d, Longitude[ColonyName == 'Josie Lake #2'] <- -94.7969444)

# Josie Lake #5
d <- within(d, Latitude[ColonyName == 'Josie Lake #5'] <- 30.11155556)
d <- within(d, Longitude[ColonyName == 'Josie Lake #5'] <- -94.79125)

# Jumbilee Cove / Live Oak Grove
d <- within(d, Latitude[ColonyName == 'Jumbilee Cove / Live Oak Grove'] <- 29.19305556)
d <- within(d, Longitude[ColonyName == 'Jumbilee Cove / Live Oak Grove'] <- -94.99611111)

# South Deer Island
d <- within(d, Latitude[ColonyName == 'South Deer Island'] <- 29.27388889)
d <- within(d, Longitude[ColonyName == 'South Deer Island'] <- -94.91083333)

# Scholes Field
d <- within(d, Latitude[ColonyName == 'Scholes Field'] <- 29.26555556)
d <- within(d, Longitude[ColonyName == 'Scholes Field'] <- -94.86055556)

# North Deer Island
d <- within(d, Latitude[ColonyName == 'North Deer Island'] <- 29.28194444)
d <- within(d, Longitude[ColonyName == 'North Deer Island'] <- -94.92388889)

# San Luis Pass
d <- within(d, Longitude[ColonyName == 'San Luis Pass'] <- -95.11083333)

# West Bay Mooring Facility
d <- within(d, Latitude[ColonyName == 'West Bay Mooring Facility'] <- 29.17222222)
d <- within(d, Longitude[ColonyName == 'West Bay Mooring Facility'] <- -95.11194444)

# Armand Bayou Nature Center
d <- within(d, Latitude[ColonyName == 'Armand Bayou Nature Center'] <- 29.573792)
d <- within(d, Longitude[ColonyName == 'Armand Bayou Nature Center'] <- -95.082636)

# Dickinson Bay Spoil Island
d <- within(d, Longitude[ColonyName == 'Dickinson Bay Spoil Island'] <- -94.92888889)

# Freeport Levee Rookery
d <- within(d, Latitude[ColonyName == 'Freeport Levee Rookery'] <- 28.998702)
d <- within(d, Longitude[ColonyName == 'Freeport Levee Rookery'] <- -95.308417)



####### ------ North Deer Island 2022

## reddish egret issue - morphs will be dropped later in the combine data script.
# there is a weird row from a pair that had one of each morph that results in 
# issues down the road. Fixing it here.

# drop the reddish egret white morphs row
d <- filter(d, !(Pairs == 0.5 & ColonyName == 'North Deer Island' & Year == "2022"))

# modify dark morph row so nests == 5, adults == 10, pairs == 5 
d <- within(d, Nests[ColonyName == 'North Deer Island' & Year == "2022" & Species == "Reddish Egret Dark Morph"] <- 5)
d <- within(d, Adults[ColonyName == 'North Deer Island' & Year == "2022" & Species == "Reddish Egret Dark Morph"] <- 10)
d <- within(d, Pairs[ColonyName == 'North Deer Island' & Year == "2022" & Species == "Reddish Egret Dark Morph"] <- 5)

rm(d20, m)

##### ----- Save to cleaned data folder for later merging
 write.csv(d, "./data_cleaned/Tx_upper_coast20-22.csv")
 
 
 ############################################################################################
 #################################### END ###################################################
 ############################################################################################