############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Upper Texas Coast 2016-2019 datasets
# Provided by Woody Woodrow (U.S. Fish and Wildlife Service)
# this data was extracted from Access database "TCWS Database 11012019.accdb" 

############################################################################################

## Started 2023-06-30 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

# read in data and names
d <- read.csv("./data_original/Texas/TX_Upper_Coast_2016-2019.csv") 

##### ----- Remove some columns
d <- subset(d, select = -c(County, Region, ColonyHistory, LastModifiedByBirds, 
                           RecordOwnerBirds, DateModifiedBirds, DateCreatedBirds, 
                           LastModifiedByEffort,  StartTime, EndTime, RecordOwnerEffort,
                           DateCreatedEffort, DateModifiedEffort, ColonyID, 
                           PredominantReproductiveStage))

##### ----- Add some columns
#data provider
d$DataProvider <-  "Texas Colonial Waterbird Society"
d$DateReceived <- "2023-01-11"

#state
d$State <- "Texas"



##### ----- Change some column names
d <- d %>% rename(Species = SpeciesName)



##### Pivot table ####

# Pivot the table so count units (adults and nests) become columns .
# The problem is that there are blanks.

# in column "units", convert blanks to Unknown metric
d["units"][d["units"] == ''] <- "Unknown metric"

# in column "species", convert blanks to NAs
d["Species"][d["Species"] == ''] <- "Species Unknown"


##### Fix these mistakes before Spread

# make "countid" a factor
# this is a unique identifer by row and can be used to identify problem rows
d$CountID <- as.factor(d$CountID)

# delete this row
# theres no count data, no metric, and no species and it says no survey was performed
# but there are other rows with data on same day
d <- d %>% 
  filter(!(CountID== "62436" ))


### Mistakes found by spread() (which are causing spread() to not work)

# * 1512, 1518  and # * 1513, 1519 
# "Great Egret" is double counted
# we kept lower values (nest and pair = 2)
d <- d %>% 
  filter(!(CountID== "63253" | CountID == "63254" ))

# * 830, 832
# "White-faced Ibis" should be "White Ibis"
d <- within(d, Species[CountID == '62565'] <- "White Ibis")

# * 1010, 1013
# "Little Blue Heron" should be "Tricolored Heron"
d <- within(d, Species[CountID == '62754'] <- "Tricolored Heron")

# * 989, 990
d <- d %>% 
  filter(!(CountID== "62724" | CountID == "62725" ))

# * 1890, 1891
# fix unknown metric with clues form other columns
d <- within(d, units[CountID == '63669'] <- "nests")
d <- within(d, units[CountID == '63670'] <- "adults")
d <- within(d, units[CountID == '63671'] <- "pairs")

# * 902, 903
# there are two unknown metrics for Black Skimmer - deleted the higher count
d <-  d %>% 
  filter(!(CountID== "62638"))

# * 435, 437
# Cattle Egrets adults in 2016 on Hull-Daisetta Marsh (NRCS) appear twice
# looked at  pages 7/117 and 9/117 in Upper Coast 2016 raw data sheets
# fixed counts  
d <- within(d, Count[CountID == '62211'] <- "950") #nests
d <- within(d, units[CountID == '62211'] <- "nests")
d <- within(d, Count[CountID == '62212'] <- "600") #adults
d <- within(d, units[CountID == '62210'] <- "pairs")

#* 483, 484
# McAllis Point Mounds Black Skimmer adults counted twice
# pairs should be 63
d <- within(d, units[CountID == '62273'] <- "pairs")


##### ----- Need to take out these duplicates from these 3 sites

##### ----- Alligator Point 2019, North Deer Island 2018, and West Bay Mooring 2019
# all have duplicates that don't filter out in unique below because
# of differing "SurveyComments".
# Pull those out and remove duplicates but retain "SurveyComments."

# pull out only Alligator Point 2019
a <- filter(d, ColonyName =="Alligator Point" & Year == "2019")
# select which set of duplicates to keep by location (black skimmer is not duplicate)
q <- a[c(15, 16, 17:30),]

# pull out only North Deer Island 2018
b <- filter(d, ColonyName =="North Deer Island" & Year == "2018")
# select which set of duplicates to keep by location
r <- b[c(1:22),]

# pull out only West Bay Mooring Facility
c <- filter(d, ColonyName =="West Bay Mooring Facility" & Year == "2019")
# select which set of duplicates to keep by location (snowy egret is not duplicate)
s <- c[c(31, 32, 1:23),]

remove <- rbind(a,b,c)
add_back <- rbind(q,r,s)
rm(a,b,c,q,r,s)

#remove these from d
d <- setdiff(d, remove)

# add the un-duplicated back in
d <- rbind(d, add_back)

rm(remove, add_back)

##### ----- Bay Harbor 2016 600526
# there are 2 datasheets in Upper Coast 2016 on pg94/117 and 114/117.
# My best guess here is that there were two groups surveying this site
# so I'm going to add them together.
# There are duplicates for most spp.

# pull out only those trouble rows
z <- filter(d, ColonyName == "Bay Harbor Bar" & Year == "2016")

# remove those from d 
d <- setdiff(d, z)

# pivot wider
z <- pivot_wider(z, names_from= "units", values_from = "Count")

# pull out only the counts
x <- select(z, c(Species, adults, pairs))

# calculate the total by species
x$Species <- as.factor(x$Species)
x$adults <- as.numeric(x$adults)
x$pairs <- as.numeric(x$pairs)

summary <- x %>%
  group_by(Species) %>%
  summarise(adults = sum(adults, na.rm = TRUE),
            pairs = sum(pairs, na.rm = TRUE))

# add summary data back to the full columns in z
# drop one of the sheets data
keep <- z %>% filter(CountID == "62226")
keep <- subset(keep, select = -c(CountID, adults, pairs, SpeciesComments, SurveyTypeAdults)) 

z <- z %>% filter(!(Observers == "Phil Glass, Donna Anderson"))

# drop columns
z <- subset(z, select = -c(CountID, adults, pairs, SpeciesComments, SurveyTypeAdults)) 

# remove duplicates
z <- unique(z)

z<- rbind(keep, z)

z <- left_join(z, summary,  by = c("Species"))

# success! remove all those extras and add back to the full dataset below 
rm(x, summary, keep)


# delete columns then do distinct() to drop exact copy rows
d <- subset(d, select = -c(CountID, SpeciesComments, SurveyTypeNests, SurveyTypeAdults, SurveyID, notes, Observers))

d <- d %>%
  distinct()


##### ----- Use spread to put turn count units into columns

e <- spread(d, key= units , value= Count)

##### ----- Add rows from Bay Harbor back in

# change columns so they align
z <- subset(z, select = -c( SurveyTypeNests, SurveyID, notes, Observers))
z$nests <- NA

# bind them together
e <- rbind(e, z)

# remove no longer needed data frames
rm(d, z)



##### ----- Change some column names

e <- e %>% rename(Adults = adults,
                  Pairs = pairs,
                  Nests = nests, 
                  Notes = SurveyComments,
                  Date = SurveyDate)


##### ----- Add Identified_to_species column based on species column

e$Identified_to_species <- with(e, ifelse( Species == "Species Unknown", 'no', 'yes'))


##### ----- Change species names to match the rest of the data

# Reddish Egret various forms to dark morph
e<- within(e, Species[Species == 	'Reddish Egret - red morph'] <- "Reddish Egret Dark Morph")

# Reddish Egret various forms to white morph
e<- within(e, Species[Species == 'Reddish Egret - white morph'] <- "Reddish Egret White Morph")

# double check all the species
e$Species <- as.factor(e$Species)
levels(e$Species)



####### ----- Corrections and alterations to make names align among datasets

e$ColonyCode <- as.factor(e$ColonyCode)

# Burnett Bay Mounds N 
e<- within(e, ColonyName[ColonyCode == '600168'] <- "Burnet Bay N. Mound")

# 288 Acre Mash Boliva
e <- within(e, ColonyName[ColonyName == '288 Acre Mash Bolivar'] <- "288 Acre Marsh Bolivar")



####### ----- Corrections and alterations to make coordinates align among datasets

# North Deer Island
e <- within(e, Longitude[ColonyName == 'North Deer Island'] <- '-94.92388889')
e <- within(e, Latitude[ColonyName == 'North Deer Island'] <- '29.28194444')	



####### ----- Coordinates flipped and missing signs

##### longitude missing - sign
# 600119 CL Rookery
e<- within(e, Longitude[ColonyCode == '600119'] <- -94.823889)
# 600555
e<- within(e, Longitude[ColonyCode == '600555'] <- -94.933972)
# 600122
e<- within(e, Longitude[ColonyCode == '600122'] <- -94.752708)



##### ----- 600563 Drum Bay Island missing coords

# make table with coords
a <- c('Drum Bay Island 2', 29.01237084, -95.22515144)
b <- c('Drum Bay Island 4', 29.01525095, -95.22233693)
c <- c('Drum Bay Island 6', 29.019488, -95.21921871)
drumbay <- rbind(a,b,c)
drumbay <- data.frame(drumbay)
rm(a,b,c)
drumbay <- drumbay %>% rename(ColonyName = X1,
                  Latitude = X2,
                  Longitude = X3)
drumbay$Latitude  <- as.numeric(drumbay$Latitude )
drumbay$Longitude  <- as.numeric(drumbay$Longitude )

# pull out rows that need coordinates
need_coords <- filter(e, is.na(Latitude))

# drop those rtows from full dataset
e <- setdiff(e, need_coords)

# drop lat longs
# drop columns
need_coords <- subset(need_coords, select = -c(Latitude, Longitude))

# join coords to rows
need_coords <- inner_join(need_coords, drumbay, by = "ColonyName")

# add rows back to full dataset
e <- rbind(e, need_coords)

# remove bits no longer needed
rm(drumbay, need_coords)



##### ----- coordinates are flipped

# pull out rows that need to be flipped
flip <- filter(e, Longitude > 0)
# drop them from full dataset
e <- setdiff(e, flip)

# change column names
flip <- flip  %>% rename(Longitude_right = Latitude,
                         Latitude = Longitude) 
flip <- flip  %>% rename(Longitude = Longitude_right)

# rejoin data
e <- rbind(e, flip)

d <- e
rm(e, flip)

d$SpCountMethod <- NA


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/TX_upper_coast2016-2019.csv")


############################################################################################
#################################### END ###################################################
############################################################################################