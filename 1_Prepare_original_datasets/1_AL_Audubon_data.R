############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Join Alabama colonial bird data to coordinates 
# Provided by Lianne Koczur (Alabama Audubon)

############################################################################################

## Started 2023-03-17 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)
library(parzer)


#### Read in data ####

al <- read.csv( "./data_original/AL_Audubon/Alabama_reports_to_spreadsheet_2023.05.10.csv")  # include 2022 report data
# Separate files with Site coordinates
xy <- read.csv( "./data_original/AL_Audubon/AL_Sites.csv", fileEncoding="latin1")
xyz <- read.csv( "./data_original/AL_Audubon/AL_Sites2.csv")


#### xy manipulations ####

# split coord column into 2 columns
xy<- separate_wider_delim(data = xy, cols = X, delim = ",", names = c("latitude", "longitude"))

# convert coords
xy$latitude <- parse_lat(xy$latitude)
xy$longitude <- parse_lon(xy$longitude)


#### Filling in still missing coords  ####

# Lianne Koczur sent coordinates for some of the colonies (03/14/2023)
# Some are missing so I had to fill those in based on the reports that she sent (2/28/2023)

# pull out rows that need coords
# need_coord <- 
#   new %>% 
#   filter(is.na(latitude))
xy <- rbind(xy, xyz)

# make site a factor
xy$Site<- as.factor(xy$Site)


#### Manipulations on survey dataset ####

al$Site<- as.factor(al$Site)

# rename a few sites to match xy list and make consistent among yrs
al$Site <- recode_factor(al$Site, "Marsh Island" = "Marsh Island East",
                         "Alabama Point" = "Alabama Point East",
                         "Piggly Wiggly Rooftop" = "Piggly Wiggly",
                         "Beach Club Resort and Spa" = "Beach Club")


#### Join survey count data and coordinates ####

d <- left_join(al, xy, by = "Site")

# remove data frames not longer needed
rm(xy, xyz, al)

#### Edit attributes  ####

# Add state column
d$State <- "Alabama"

# Add data provider column
d$DataProvider <- "Alabama Audubon"

# Add Identified_to_species column
# make Species a factor
d$Species <- as.factor(d$Species)
# look at species
levels(d$Species)
# all are identified to species, so make a column that's all yes
d$Identified_to_species <- "yes"

# rename columns
d <- d %>% rename(Latitude = latitude)
d <- d %>% rename(Longitude = longitude)

# remove columns
d <- subset(d, select = -c(Failed_nests, X))

# convert unk to NA
d$Nests <- na_if(d$Nests, "unk")
d$Chicks <- na_if(d$Chicks, "unk")
d$Fledglings <- na_if(d$Fledglings , "unk")

# Change Site to ColonyName to match total dataset column names (7/24/2023)
d <- d %>% rename(ColonyName = Site)

# Remove duplicate row - Gulf State Park Least Tern 2018 (8/2/2023)
d <- d[-c(29),]

# 6/15/23 checked that attributes listed in attribute roundup match spreadsheet 

# Add DateReceived column
d$DateReceived <- "2023-02-28"
d$DateReceived[d$Year == "2022"]<-"2023-05-03"

d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- "On-site visit"

##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/AL_Audubon_data.csv")



############################################################################################
#################################### END ###################################################
############################################################################################
