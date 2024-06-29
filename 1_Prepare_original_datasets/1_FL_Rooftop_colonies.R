############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Florida Rootftop colonies
# Provided by Emma LeClerc (Florida Fish & Wildlife Conservation Commission)

############################################################################################

## Started 2024-01-11 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)


# read in data
d <- read.csv("./data_original/FL_Rooftop_colonies/FloridaRooftopColonies_20112022.csv")


##### ----- Drop, add, and rename some columns to prep for alignment with other data 

# rename columns
d <- d %>% rename(Year = SurveyYear)
d <- d %>% rename(Adults = MaxAdultsCount) # Note that this dataset visits sites multiple x per season so this represent the max adults counted throughout the season
d <- d %>% rename(ColonyCode = LocationID)
d <- d %>% rename(ColonyName = SiteName)

# remove columns - county
d  <- subset(d , select = -c(County) )

# add data provider 
d$DataProvider <- "Florida Rooftop Colony Database"
d$DateReceived <- "2023-12-21"

# trim the whitespace in species names
d$Species<- trimws(d$Species)

# make species a factor
d$Species<- as.factor(d$Species)
levels(d$Species)

# add column for identified to species
d$Identified_to_species <- "yes"

d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- NA


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/FL_Rooftop_Colonies.csv")


############################################################################################
#################################### END ###################################################
############################################################################################