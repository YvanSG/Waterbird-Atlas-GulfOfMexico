############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Provided by Abby Darrah (Delta Audubon) as Excel spreadsheet
# Least Tern and Black Skimmer only
# General preparation for spatial display

############################################################################################

## Started 2024-03-20 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)


#### Read in data ####

# Data compiled from reports and presentations
d <- read.csv("./data_original/LA_Audubon/Data_for_Atlas_Aud_Louisiana.csv")

# create columns to match island_colonies2021
d <- rename(d, ColonyName = Site)

#### Prepare for alignment with other Atlas data ####

# Add state
d$State <- "Louisiana"

# add data provider 
d$DataProvider <- "Audubon Delta"
d$DateReceived <- "2024-03-04"

# Add Identified_to_species column
# make Species a factor
d$Species <- as.factor(d$Species)
# look at species
levels(d$Species)
# all are identified to species, so make a column that's all yes
d$Identified_to_species <- "yes"

d$Year <- as.factor(d$Year)

d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- "On-site visit"


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/LA_Audubon_Delta.csv")


############################################################################################
#################################### END ###################################################
############################################################################################