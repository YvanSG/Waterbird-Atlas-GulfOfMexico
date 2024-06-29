############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# CWB Gulfwide Database from Eva Windhoffer at the Water Institute 
# need to add full species names to this data 

############################################################################################

## Started 2023-06-06 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

# read in data and species names
d <- read.csv("./data_original/Gulfwide_TIG_Colibri/Colibri2010-2021CWB_DatabaseMerged_All.csv") 
spp <- read.csv("./data_original/Gulfwide_TIG_Colibri/species_codes.csv")

# Change outlier species codes to match the rest
# change UnTE to UNTE
d<- within(d, SpeciesCode[SpeciesCode == 'UnTE' ] <- "UNTE")

# change UnGu to UNGU
d<- within(d, SpeciesCode[SpeciesCode == 'UnGu' ] <- "UNGU")

# change UNSH to UNSB 
d<- within(d, SpeciesCode[SpeciesCode == 'UNSH' ] <- "UNSB")

# change UNSH to UNSB 
d<- within(d, SpeciesCode[SpeciesCode == 'DUCK' ] <- "UNDU")

# change UnWa to UNWA 
d<- within(d, SpeciesCode[SpeciesCode == 'UnWa' ] <- "UNWA")

# change UnWa to UNWA 
d<- within(d, SpeciesCode[SpeciesCode == 'UnDu' ] <- "UNDU")


# add in species codes
f<- left_join(d, spp, by = "SpeciesCode")


# Drop species not related to the Atlas 
# drop row with turtle (1)
f<- subset(f, SpeciesCode != "TURTLE")

# drop row with Red-shouldered Hawk (1)
f<- subset(f, SpeciesCode != "RSHA")

# drop row with Osprey (1)
f<- subset(f, SpeciesCode != "OSPR")

# drop rows with ducks (27)
f<- subset(f, SpeciesCode != "MODU" & SpeciesCode != "BBWD" & SpeciesCode != "FUWD" & SpeciesCode != "UNDU")

# drop more ducks - Northern Shoveler (1) and Blue-wing Teal (2)
f<- subset(f, SpeciesCode != "NSHO" & SpeciesCode != "BWTE")

# drop row with wilson's Phalarope (maybe this should be wilson's plover? - its unclear if this is a mistake)
f<- subset(f, SpeciesCode != "WIPH")

# drop gt grackle (1) and fish crow (1) and unknown crow (1)
f<- subset(f, SpeciesCode != "GTGR" & SpeciesCode != "FICR" & SpeciesCode != "UNCR")

# drop GRFL (1) -- Gray Flycatcher - but I think they  meant greater flamingo - sightings in this area on ebird
f<- subset(f, SpeciesCode != "GRFL")

# drop Canada Goose (7)
f<- subset(f, SpeciesCode != "CANG")

# drop Crested Carara (2)
f<- subset(f, SpeciesCode != "CRCA")

# make species and species code a factor then check out the levels
f$SpeciesName<- as.factor(f$SpeciesName)
levels(f$SpeciesName)

f$SpeciesCode<- as.factor(f$SpeciesCode)
levels(f$SpeciesCode)


# add full state name
# rename state column
f <- f %>% rename(StateCode = State)

# create dataframe to add full state name to data 
state <- data.frame(State = c("Texas", "Louisiana", "Alabama", "Mississippi", "Florida"),
                    StateCode = c("TX", "LA", "AL", "MS", "FL"))

# join the state names to the data
f<- left_join(f, state, by = "StateCode")

# drop state code columm
f <- subset(f, select = -c(StateCode))

# remove temporary dataframes
rm(state, spp, d)


# drop and rename some columns to prep for alignment with other data 
f <- f %>% rename(Species = SpeciesName)
f<- subset(f, select = -c(SpeciesCode, GeoRegion, ID) )
f <- subset(f, select = -c(SpeciesName_old))

# add column for data provider
f$DataProvider <- "DWH Regionwide TIG"
f$DateReceived <- "2023-06-05"


# add column for survey vantage point and fill in with aerial photography
f$SurveyVantagePoint <- "Aerial photography"


##### ----- Save to cleaned data folder for later merging
write.csv(f, "./data_cleaned/Gulfwide_TIG.csv")



############################################################################################
#################################### END ###################################################
############################################################################################