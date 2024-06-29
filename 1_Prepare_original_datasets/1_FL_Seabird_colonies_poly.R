############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Prepare Florida Seabird Colony database
# Provided by Janell Brush and Emma LeClerc (Florida Fish & Wildlife Conservation Commission)

############################################################################################

## Started 2023-06-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

# read in data
d <- read.csv("./data_original/FL_Seabird_colonies/FloridaGroundColonies_20112022_20240216.csv")

##### ----- Drop, add, and rename some columns to prep for alignment with other data 

# rename columns
d <- d %>% dplyr::rename(Year = SurveyYr)
d <- d %>% dplyr::rename(Nests = MaxNests)
d <- d %>% dplyr::rename(Adults = MaxAdults)
d <- d %>% dplyr::rename(ColonyName = PolyRefID)


# add data provider 
d$DataProvider <- "Florida Shorebird Database"
d$DateReceived <- "2024-02-16"


# make species a factor
d$Species[d$Species=="BLSK"] <- "Black Skimmer"
d$Species[d$Species=="BRTE"] <- "Bridled Tern"
d$Species[d$Species=="BRPE"] <- "Brown Pelican"
d$Species[d$Species=="CATE"] <- "Caspian Tern"
d$Species[d$Species=="GBTE"] <- "Gull-billed Tern"
d$Species[d$Species=="LAGU"] <- "Laughing Gull"
d$Species[d$Species=="LETE"] <- "Least Tern"
d$Species[d$Species=="MAFR"] <- "Magnificent Frigatebird"
d$Species[d$Species=="MABO"] <- "Masked Booby"
d$Species[d$Species=="ROST"] <- "Roseate Tern"
d$Species[d$Species=="ROYT"] <- "Royal Tern"
d$Species[d$Species=="SATE"] <- "Sandwich Tern"
d$Species[d$Species=="SOTE"] <- "Sooty Tern"

d$Species<- as.factor(d$Species)
levels(d$Species)


d$Identified_to_species <- "yes"

d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- NA


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/FL_Seabird_Colonies.csv")


############################################################################################
#################################### END ###################################################
############################################################################################