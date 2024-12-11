############################################################################################
############# Atlas of Breeding Sites for Waterbirds in the Northern Gulf of Mexico ########
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Texas Lower coast data from Jonathan Moczygemba
# Reshaping from wide to long in preparation for GIS

############################################################################################

## Started 2023-05-17 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

# read in data
d <- read.csv("./data_original/Texas/2022_All_CWB_Data.csv")


# drop columns that aren't needed
# data for 2010-2015 came from TCWS so we don't need it from this dataset
d <- subset(d, select = -c(X2010, X2011, X2012, X2013, X2014, X2015) )

# rename year columns, which had x added to them on import
d <- d  %>% rename("2022" = X2022)
d <- d  %>% rename("2021" = X2021)
d <- d  %>% rename("2020" = X2020)
d <- d  %>% rename("2019" = X2019)
d <- d  %>% rename("2018" = X2018)
d <- d  %>% rename("2017" = X2017)
d <- d  %>% rename("2016" = X2016)


# Remove colonies based on Justin LeClaire's input

# SW Mansfield Int - Justin LeClaire unsure of these coordinates 
# and that location is probably underwater - no birds counted (11 rows)
d<- subset(d, Colony.Name != "SW Mansfield Int")

# SE Mansfield Intersection - Justin LeClaire unsure of these coordinates 
# and that location is probably underwater - no birds counted (2 rows)
d<- subset(d, Colony.Name != "SE Mansfield Intersection")

# Port Isabel Spoil - Justin LeClaire had never heard of this - no birds counted (14 rows) 
d<- subset(d, Colony.Name != "Port Isabel Spoil")

# Padre Beach Estates - Justin LeClaire had never heard of this - no birds counted (1 row) 
d<- subset(d, Colony.Name != "Padre Beach Estates")


# Port Isabel Fingers: lat and longs are swapped
d<- within(d, Latitude[Colony.Name == 'Port Isabel Fingers'] <- 26.072915)
d <- within(d, Longitude[Colony.Name == 'Port Isabel Fingers' ] <- -97.221672)

# pivot from wide to long
e <- pivot_longer(d, names_to = "Year", values_to = "Pairs", cols = c(8:14))


##### ----- Drop, add, rename some columns to prep for alignment with other data 

# add state
e$State <- "Texas"
# add data provider
e$DataProvider <- "Texas Colonial Waterbird Society"
e$DateReceived <- "2023-02-22"

# rename column
e <- e %>% rename(ColonyCode = Colony.Code)
e <- e %>% rename(ColonyName = Colony.Name)

# drop columns
e  <- subset(e , select = -c(County, Bay) )

# are all birds identified to species? Yes
d$Species<- as.factor(d$Species)
# levels(d$Species)
e$Identified_to_species <- "yes"

# Drop rows for which there are no data (NA)
# drop rows where pair == NA
e <- e %>%
  filter(!if_all(c("Pairs"), is.na))

# Add a hypen to Double-crested Cormorant to match other datasets
e$Species <- recode_factor(e$Species,  "Double Crested Cormorant" = "Double-crested Cormorant")
#levels(e$Species)

# remove the "-" from ColonyCode (to match other datasets)
e$ColonyCode <- gsub("[[:punct:]]", "", e$ColonyCode)
# transform letters to lower case
e$ColonyCode <- tolower(e$ColonyCode)


##### ----- Check if there are multiple colony names per colony number
m <- e %>%
  select( ColonyCode, ColonyName) %>%
  group_by( ColonyCode, ColonyName) %>%
  summarise(n = n())


# Bahia Grande names don't match the rest of the spreadsheet
e<- within(e, ColonyName[ColonyCode == '618250A'] <- "Bahia Grande- Bird Island-A")
e<- within(e, ColonyName[ColonyCode == '618250B'] <- "Bahia Grande- Bird Island-B")
e<- within(e, ColonyName[ColonyCode == '618250C'] <- "Bahia Grande- Bird Island-C")

# match NE Mansfield int to the rest of the data
e <- within(e, ColonyName[ColonyName == 'NE Mansfield Int'] <-'NE Mansfield int')

# match East Flats Spoil to the rest of the data
e <- within(e, ColonyName[ColonyName == 'East Flats Spoil Dubbs'] <-'East Flats Spoil')

d <- e

rm(e, m)

d$SpCountMethod <- NA
d$SurveyVantagePoint <- NA

##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/Texas_lower_coast.csv")


############################################################################################
#################################### END ###################################################
############################################################################################
