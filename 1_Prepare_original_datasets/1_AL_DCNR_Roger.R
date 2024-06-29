############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Alabama colony data
# Provided by Roger Clay (Alabama Department of Conservation and Natural Resources)

############################################################################################

## Started 2023-03-17 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)


##### Read in data ####

d <- read.csv("./data_original/AL_DCNR/Important Shorebird Island Nesting.csv")
coords <- read.csv("./data_original/AL_DCNR/Important_Shorebird_Island_Nesting_coordinates.csv")


# Look at data 
d$Location <- as.factor(d$Location)
d$Species <- as.factor(d$Species)
d$Year <- as.factor(d$Year)

levels(d$Location)
levels(d$Species)
levels(d$Year)

# correct Species names to match main dataset
d$Species <- as.character(d$Species)
d<- within(d, Species[Species == "American Oytercatcher"] <- "American Oystercatcher")
d<- within(d, Species[Species == 'Gull-Billed Tern'] <- "Gull-billed Tern")
d<- within(d, Species[Species == '"Chandeleur" Gull'] <- 'Chandeleur Gull')
d$Species <- as.factor(d$Species)
levels(d$Species)

# rename columns
d <-  d %>% rename(Pairs = No.Pairs,
                   ColonyName = Location)

# Add columns
d$State <- "Alabama"
d$DataProvider <- "Alabama DCNR"
d$Identified_to_species <- "yes"
d$DateReceived <- "2023-08-08"



#### Match up to coordinates ####

# prep coords data to match up to d data
# rename columns
coords <-  coords %>% rename(ColonyName = Island,
                             Latitude = Approximate.Center.Lat,
                             Longitude  = Approximate.Center.Long)

# drop columns
coords <- subset(coords, select = -c(Ownership))

# join coords to d
d <- left_join(d, coords, by = "ColonyName")

rm(coords)

# delete rows with blanks because it is unclear what they are 
d <- d %>%
  filter(!is.na(Pairs))


##### ----- Isle Aux Herbs has duplicate Least Terns in 2011
# Use the average (37, 30)

# drop one of the duplicates rows
# drop the reddish egret white morphs row
d <- filter(d, !(Pairs == 37 & ColonyName == 'Isle Aux Herbes' & Year == "2011"))

# change the remaining row's pairs to the average
d <- within(d, Pairs[ColonyName == 'Isle Aux Herbes' & Year == "2011" & Species == "Least Tern"] <- 33.5)

d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- NA


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/AL_DCNR.csv")


############################################################################################
#################################### END ###################################################
############################################################################################