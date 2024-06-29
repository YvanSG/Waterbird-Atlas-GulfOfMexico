############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Provided by Abby Darrah (Mississippi Audubon) as reports and presentations
# Join MS colonial bird data to coordinates 
# Find and remove duplicates
# General preparation for spatial display

############################################################################################

## Started 2023-04-13 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)


#### Read in data ####

# Data compiled from reports and presentations
d <- read.csv("./data_original/MS_Audubon/compile_MS_Audubon_data.csv")

# data from shapefile Island_colony_polygons_2021_attributes.shp
island_colonies2021 <- read.csv("./data_original/MS_Audubon/Island_colony_polygons_2021_attributes.csv")


# prepare island_colonies2021

# Wide to Long format 
island_colonies2021 <- pivot_longer(island_colonies2021, cols = Least.Tern:Common.Tern, names_to = "Species", values_to ="Nests")

#fix species names (replace period w space)
island_colonies2021$Species <-gsub(".", " ", island_colonies2021$Species , fixed=TRUE)

# add hypen to Gull-billed Tern
island_colonies2021 <- within(island_colonies2021, Species[Species == 'Gull billed Tern'] <- 'Gull-billed Tern')

# rename columns
island_colonies2021 <- island_colonies2021 %>% rename(Latitude = Lat, Longitude = Long, Site= Island)

# create columns match d
island_colonies2021$Start.Date <- NA
island_colonies2021$End.Date <- NA
island_colonies2021$Fate <- NA
island_colonies2021$Adults <- NA
island_colonies2021$Chicks <- NA
island_colonies2021$Fledglings <- NA

# add source column
island_colonies2021$source <- "Island_colony_polygons_2021_attributes"


# prepare d

# create columns to match island_colonies2021
d$Colony.Name <- NA

# change "U"s to NAs
d[d == "U"] <- NA

# make nests an integer
d$Nests <- as.integer(d$Nests)


# lump slightly different names

#Biloxi Beach to Biloxi Beach - East
d <- within(d, Site[Site == 'Biloxi Beach'] <- 'Biloxi Beach - East')

# Broad Avenue to Broad
d <- within(d, Site[Site == 'Broad Avenue'] <- 'Broad')

# Deer Island -  Deer  to Deer Island
d <- within(d, Site[ Site == 'Deer' ] <- 'Deer Island')

# Deer Island - beneficial use area & Deer & Deer - BU to Deer Island  (8/2/23)
d <- within(d, Site[Site == 'Deer Island - beneficial use area' |  Site == 'Deer - BU'] <- 'Deer Island - beneficial use area')

# Napa Auto Parts & Napa Auto Parts (rooftop)  to Napa Auto Part Rooftop
d <- within(d, Site[Site == 'Napa Auto Parts' | Site == 'Napa Auto Parts (rooftop)'] <- 'Napa Auto Part Rooftop')

# Seamans Sewage Lagoons to Seaman Road Sewage Lagoons
d <- within(d, Site[ Site == 'Seamans Sewage Lagoons'] <- 'Seaman Road Sewage Lagoons')

# Ocean Club to Ocean Club Blvd
d <- within(d, Site[ Site == 'Ocean Club Blvd'] <- 'Ocean Club')

# Pass Christian to Pass Christian Harbor
d <- within(d, Site[ Site == 'Pass Christian'] <- 'Pass Christian Harbor')

# # Deer Island SE & Deer Island SW to Deer Island (commented off on 8/2/23)
# d <- within(d, Site[ Site == 'Deer Island SE'| Site == 'Deer Island SW'] <- 'Deer Island')

# cat Island to Cat Island - Eastern Shell Field
d <- within(d, Site[ Site == 'Cat Island'] <- 'Cat Island - Eastern Shell Field')

# long beach to long beach harbour
d <- within(d, Site[ Site == 'Long Beach'] <- 'Long Beach Harbor')


# swap lat and longs that were entered incorrectly
# for coords in atlas area, longitude should be negative
# pull out rows that need to be flipped
switch <- d %>% filter (Longitude > 0)

# pull out rows that don't need swapped
no_switch <- setdiff(d, switch)

# switch column names
switch  <- switch  %>% rename(Lat2 = Longitude, Longitude = Latitude) %>% 
  rename(Latitude = Lat2)

# recombine all rows
d <- bind_rows(switch, no_switch)

rm(switch, no_switch)



#### Combine d and island colonies ####

d <- bind_rows(d, island_colonies2021)

rm(island_colonies2021)


# fill in missing coords

# pull out rows with coords
coords <- drop_na(d, c(Latitude))

# pull out rows without coords
no_coords <- setdiff(d, coords)

# pull out columns for site and lat, long
coords <- coords %>% select(Site, Latitude, Longitude)

# distinct rows only
coords <- distinct(coords)

# write to .csv 
# write.csv(coords, "distinct_coords.csv")

# When there were several near each other,
# we manually chose which location to use for each colony in ArcGIS

# bring ArcGIS table back into R to join with colony info
coord_update <- read.csv("./data_original/MS_Audubon//distinct_coords.csv") 

# rename column
coord_update  <- coord_update %>% rename("Site" = 1)

# drop lat and long from d
d = subset(d, select = -c(Latitude, Longitude) )

# join coord_update lat and longs onto d
t<- left_join(d, coord_update, by = c("Site"))

d <- t

# remove temporary dataframes
rm(coord_update, coords, no_coords, t)



#### Prepare for alignment with other Atlas data ####

# Add state
d$State <- "Mississippi"

# rename column
d <- d %>% rename(ColonyName = Colony.Name)

# remove columns
d  <- subset(d , select = -c(Fate, Start.Date, End.Date,  ColonyName) ) #source,

# add data provider 
d$DataProvider <- "Audubon Delta"
d$DateReceived <- "2023-03-16"

# Add Identified_to_species column
# make Species a factor
d$Species <- as.factor(d$Species)
# look at species
levels(d$Species)
# all are identified to species, so make a column that's all yes
d$Identified_to_species <- "yes"


# change Site to ColonyName
d <- d %>% rename(ColonyName = Site)

d$Year <- as.factor(d$Year)

# delete duplicate rows (overlap between data reports)
d <-
  d %>% 
  filter(!(ColonyName == "Horn" & Species == "Least Tern" ))

d <-
  d %>% 
  filter(!(ColonyName == "Horn" & Species == "Black Skimmer"))

d <-
  d %>% 
  filter(!(ColonyName == "Horn" &  Species == "Gull-billed Tern"))

d <-  # 8/2/23
  d %>% 
  filter(!(ColonyName == "Deer Island" &  Species == "Least Tern" & source == "BreedingSeason2021_summary_1102"))

d <-  # 8/2/23
  d %>% 
  filter(!(ColonyName == "East/Central Ship" &  Species == "Snowy Plover" & source == "BreedingSeason2022.docx"))

d <-  # 8/2/23
  d %>% 
  filter(!(ColonyName == "Cat Island - Eastern Shell Field" &  Species == "Least Tern" & source == "BreedingSeason2021_summary_1102"))

d <-  # 8/2/23
  d %>% 
  filter(!(ColonyName == "Petit Bois" &  Species == "Least Tern" & source == "Island_colony_polygons_2021_attributes"))

# column that shows report that was the source
d  <- subset(d , select = -c(source) )

d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- "On-site visit"


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/MS_Audubon_Mississippi.csv")


############################################################################################
#################################### END ###################################################
############################################################################################