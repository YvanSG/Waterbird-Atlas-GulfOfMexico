############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Gulf Islands National Seashore data
# Provided by Cody Haynes (National Park Service)


# Three GUIS_SRS_Shorebird files need to be combined
# and max numbers per species per site per year pulled out
# One GUIS_MS_Colonial_shorebird_summary file needs column modification:
# Species names have an s on the end

############################################################################################

## Started 2023-07-14 (KH)
## Finalized 2024-04-25 (YS)

############################################################################################

#### ---- Packages

library(tidyverse)

##### read in data and names ####

# a is a log of every visit for those years so a summary needs to be made
# needs coordinates
a <- read.csv("./data_original/GINS/GUIS_SRS_Shorebird_data_2010-2012.csv") 
# add column for filename
a$filename <- "GUIS_SRS_Shorebird_data_2010-2012.csv"

# b is a summary already - needs coordinates
b <- read.csv("./data_original/GINS/GUIS_SRS_Shorebird_data_2013.csv") 
# add column for filename
b$filename <- "GUIS_SRS_Shorebird_data_2013.csv"

# b and c can be combined, but need column names changes

# c is a summary already - needs coordinates
c <- read.csv("./data_original/GINS/GUIS_SRS_Shorebird_data_2014.csv") 
# add column for filename
c$filename <- "GUIS_SRS_Shorebird_data_2014.csv"

# remove s from all the species names 
d <-  read.csv("./data_original/GINS/GUIS_MS_Colonial_shorebird_summary.csv") 
# add column for filename
d$filename <- "GUIS_MS_Colonial_shorebird_summary.csv"
# latitude and longitude are swapped for three sites
corlon<-d$Latitude[d$Location == "West Ship Island - North Beach (East of Tower) "] %>% unique()
d$Latitude[d$Location == "West Ship Island - North Beach (East of Tower) "]<-unique(d$Longitude[d$Location == "West Ship Island - North Beach (East of Tower) "])
d$Longitude[d$Location == "West Ship Island - North Beach (East of Tower) "]<-corlon

corlon<-d$Latitude[d$Location == "West Ship Island - South (E of Swim Beach)"] %>% unique()
d$Latitude[d$Location == "West Ship Island - South (E of Swim Beach)"]<-unique(d$Longitude[d$Location == "West Ship Island - South (E of Swim Beach)"])
d$Longitude[d$Location == "West Ship Island - South (E of Swim Beach)"]<-corlon

corlon<-d$Latitude[d$Location == "West Ship Island - North Beach (West of Fort) "] %>% unique()
d$Latitude[d$Location == "West Ship Island - North Beach (West of Fort) "]<-unique(d$Longitude[d$Location == "West Ship Island - North Beach (West of Fort) "])
d$Longitude[d$Location == "West Ship Island - North Beach (West of Fort) "]<-corlon
rm(corlon)

#remove s from all the species names (they are all plural)
d$Species <- sub("s$", "", d$Species)

# rename some columns
d <- d %>% rename(Chicks = Chick.Peak.Count, 
                        Fledglings = Fledge.Peak.Count,
                        ColonyName = Location, 
                        Adults = Adult.Peak.Count)

# move Adult Peak date in the notes column 
#(this is bc the peak adult count may not be the same date at the peak chick or fledgling date - this survey return multiple times during the breeding season)
# pull out rows that have peak adult date
e <- filter(d, Adult.Peak.Date != "" )

# remove these from d  - now d is only rows that did not have adult date
d <- setdiff(d, e)

# move adult peak date to notes column
e$Notes <- paste(e$Adult.Comments, e$Adult.Peak.Date, sep=". Adult peak date: ")
e <- subset(e, select = -c(Adult.Comments))

# in d change adult.comments to notes
d <- d %>% rename(Notes = Adult.Comments)

# recombine e and d then remove e
d<- bind_rows(d, e)
rm(e)

# drop some columns
d <- subset(d, select = -c(Fledge.Comments, Chick.Comments, Adult.Peak.Date))


##### a ####

# make year a factor so filtering is easier
a$Year <- as.factor(a$Year)

# replace "no count" with NA so summary below will work
a$Adult <- na_if(a$Adult, "no count")
a$Chick <- na_if(a$Chick, "no count")
a$Fledgling <- na_if(a$Fledgling , "no count")

# remove special characters 
a$Adult <- gsub("[[:punct:]]", "", a$Adult)
a$Adult <- as.numeric(a$Adult)
a$Chick <- as.numeric(a$Chick)
a$Fledgling <- as.numeric(a$Fledgling)

# the summary is taking the max number of adults (which is what FL did) and chicks
a_summary <-
  a %>%
  drop_na(Adult) %>% 
  group_by(Island, Location, Year, Bird.Species, filename) %>%
  summarise(Adults = max(Adult, na.rm = TRUE),
            Chicks = max(Chick, na.rm = TRUE),
            Fledglings = max(Fledgling, na.rm = TRUE))


##### b ####

# rename some columns
b <- b %>% rename(Fledglings = Fledges,
                  Adults = Adults.Observed,
                  Location = Location.Colony)

# the summary is taking the max number of adults (which is what FL did) and chicks
# there are multiple entries for least tern at a few sites
b <- b %>%
  group_by(Island, Location, Bird.Species, Year) %>%
  summarise(Adults = max(Adults, na.rm = TRUE),
            Pairs = max(Pairs),
            Nests = max(Nests, na.rm = TRUE),
            Chicks = max(Chicks, na.rm = TRUE),
            Fledglings = max(Fledglings, na.rm = TRUE))
b$filename <- "GUIS_SRS_Shorebird_data_2013.csv"


##### c ####

# rename some columns
c <- c %>% rename(Fledglings = Fledges,
                  Adults = Adults.Observed,
                  Location = Location.Colony)

# make max of downy chicks and feathered chicks equal to chicks
c$Chicks <- pmax(c$Feathered.Chicks, c$Downy.Chicks, na.rm = TRUE)

# the summary is taking the max number of adults (which is what FL did) and chicks -- there are multiple entries for least tern at a few sites
c <- c %>%
  group_by(Island, Location, Bird.Species, Year) %>%
  summarise(Adults = max(Adults, na.rm = TRUE),
            Pairs = max(Pairs),
            Nests = max(Nests, na.rm = TRUE),
            Chicks = max(Chicks, na.rm = TRUE),
            Fledglings = max(Fledglings, na.rm = TRUE))
c$filename <- "GUIS_SRS_Shorebird_data_2014.csv"


##### Combine datasets ####

total <- plyr::rbind.fill(a_summary, b, c)

# make a few edits to this before combining w d
#rename columns
total <- total %>% rename(Species = Bird.Species)

# combine Island and Location to ColonyName
total$ColonyName <- paste(total$Island, total$Location, sep=" - ")

# combine d and dataframe that is a_summary, b, and c
temp <- plyr::rbind.fill(total, d)

d <- temp

# remove temporary dataframes
rm(a, a_summary, b , c, total, temp)


##### Format combined GINS data to match Atlas format ##### 

### Add columns
d$DataProvider <-  "Gulf Islands National Seashore"
d$DateReceived <- "2023-06-21"


### Fix colony names so they are consistent across years

## East Ship Island
d<- within(d, ColonyName[ColonyName == 'East Ship Island - '] <- "East Ship Island")
d<- within(d, ColonyName[ColonyName == 'East Ship Island - East End'] <- "East Ship Island - East Tip: East End")
d<- within(d, ColonyName[ColonyName == 'East Ship Island - East Tip'] <- 'East Ship Island - East Tip: East End')

d<- within(d, ColonyName[ColonyName == 'East Ship Island - West End'] <- "East Ship Island - West Tip: West End")
d<- within(d, ColonyName[ColonyName == 'East Ship Island - West Tip'] <- "East Ship Island - West Tip: West End")

d<- within(d, ColonyName[ColonyName == 'East Ship Island - West Tip Middle'] <- "East Ship Island - West Tip: Middle")

# Edit coordinates to more appropriate location
d$Latitude[(d$ColonyName == "East Ship Island")] <- 30.237533
d$Longitude[(d$ColonyName == "East Ship Island")] <- -88.887652

d$Latitude[(d$ColonyName == "East Ship Island - West Tip: Middle")] <- 30.23080
d$Longitude[(d$ColonyName == "East Ship Island - West Tip: Middle")] <- -88.90010

d$Latitude[(d$ColonyName == "East Ship Island - West Tip: West End")] <- 30.230680
d$Longitude[(d$ColonyName == "East Ship Island - West Tip: West End")] <- -88.901280

d$Latitude[(d$ColonyName == "East Ship Island - East Tip: Middle")] <- 30.244390
d$Longitude[(d$ColonyName == "East Ship Island - East Tip: Middle")] <- -88.877370

d$Latitude[(d$ColonyName == "East Ship Island - East Tip: West End")] <- 30.242830
d$Longitude[(d$ColonyName == "East Ship Island - East Tip: West End")] <- -88.883470

d$Latitude[(d$ColonyName == "East Ship Island - East Tip: East End")] <- 30.249150
d$Longitude[(d$ColonyName == "East Ship Island - East Tip: East End")] <- -88.872560

d$Latitude[(d$ColonyName == "East Ship Island - South Shore West Tip")] <- 30.228050
d$Longitude[(d$ColonyName == "East Ship Island - South Shore West Tip")] <- -88.903830

## West Ship Island
d<- within(d, ColonyName[ColonyName == 'West Ship Island - ' ] <- "West Ship Island")
d<- within(d, ColonyName[ColonyName == 'West Ship Island - North Beach (West of Fort) '] <- "West Ship Island - North Beach West of Fort Massachusetts")
d<- within(d, ColonyName[ColonyName == 'West Ship Island- East' ] <- "West Ship Island - East")
d<- within(d, ColonyName[ColonyName == 'West Ship Island - East Tip' ] <- "West Ship Island - East")
d<- within(d, ColonyName[ColonyName == 'West Ship Island - East Tip-West End' ] <- "West Ship Island - East Tip: West End")

d<- within(d, ColonyName[ColonyName == 'West Ship Island - West ' ] <- "West Ship Island - West")
d<- within(d, ColonyName[ColonyName == 'West Ship Island - West Tip' ] <- "West Ship Island - West")

d<- within(d, ColonyName[ColonyName == 'West Ship Island - North Beach (East of Tower) ' ] <- "West Ship Island - North Beach east of range tower")

# Remove duplicates
d<- d[!(d$ColonyName == "West Ship Island - East End"),]
d<- d[!(d$ColonyName == "West Ship Island - West End"),]
d<- d[!(d$ColonyName == "West Ship Island - East of the Range Tower"),]
d<- d[!(d$ColonyName == "West Ship Island - North Beach West of Fort Massachusetts" &
          is.na(d$Latitude)),]

# Edit coordinates to more appropriate location
d$Latitude[(d$ColonyName == "West Ship Island")] <- 30.21064
d$Longitude[(d$ColonyName == "West Ship Island")] <- -88.967865

d$Latitude[(d$ColonyName == "West Ship Island - South Shore")] <- 30.20760
d$Longitude[(d$ColonyName == "West Ship Island - South Shore")] <- -88.97470

d$Latitude[(d$ColonyName == "West Ship Island - Northwest Shore")] <- 30.211520
d$Longitude[(d$ColonyName == "West Ship Island - Northwest Shore")] <- -88.980400


d$Latitude[(d$ColonyName == "West Ship Island - East")] <- 30.217900
d$Longitude[(d$ColonyName == "West Ship Island - East")] <- -88.943500

d$Latitude[(d$ColonyName == "West Ship Island - East Tip: West End")] <- 30.214550
d$Longitude[(d$ColonyName == "West Ship Island - East Tip: West End")] <- -88.949150

d$Latitude[(d$ColonyName == "West Ship Island - West")] <- 30.209920
d$Longitude[(d$ColonyName == "West Ship Island - West")] <- -88.981500

# Swap coordinates between
# "West Ship Island - North Beach West of Fort Massachusetts" and "West Ship Island - North Beach (East of Tower)"
lat<-d$Latitude[(d$ColonyName == "West Ship Island - North Beach east of range tower")] %>% unique()
lon<-d$Longitude[(d$ColonyName == "West Ship Island - North Beach east of range tower")] %>% unique()
d$Latitude[(d$ColonyName == "West Ship Island - North Beach east of range tower")] <- d$Latitude[(d$ColonyName == "West Ship Island - North Beach West of Fort Massachusetts")]
d$Longitude[(d$ColonyName == "West Ship Island - North Beach east of range tower")] <- d$Longitude[(d$ColonyName == "West Ship Island - North Beach West of Fort Massachusetts")]
d$Latitude[(d$ColonyName == "West Ship Island - North Beach West of Fort Massachusetts")] <- lat
d$Longitude[(d$ColonyName == "West Ship Island - North Beach West of Fort Massachusetts")] <- lon
rm(lat, lon)


## Horn Island 
d<- within(d, ColonyName[ColonyName == 'Horn Island - East End'] <- "Horn Island - East")
d<- within(d, ColonyName[ColonyName == 'Horn Island - East Tip'] <- "Horn Island - East")
d<- within(d, ColonyName[ColonyName == 'Horn Island - Mouth Big Lagoon'] <- "Horn Island - Mouth of Big Lagoon")
d<- within(d, ColonyName[ColonyName == 'Horn Island - Northeast Shore'] <- "Horn Island - Northeast")
d<- within(d, ColonyName[ColonyName == 'Horn Island - Northwest Shore'] <- "Horn Island - Northwest")
d<- within(d, ColonyName[ColonyName == 'Horn Island - Southeast Shore'] <- "Horn Island - Southeast")
d<- within(d, ColonyName[ColonyName == 'Horn Island - Southwest Shore'] <- "Horn Island - Southwest")

# Edit coordinates to more appropriate location
d$Latitude[(d$ColonyName == "Horn Island - East")] <- 30.224300
d$Longitude[(d$ColonyName == "Horn Island - East")] <- -88.586600

d$Latitude[(d$ColonyName == "Horn Island - North Shore")] <- 30.234500
d$Longitude[(d$ColonyName == "Horn Island - North Shore")] <- -88.659570

d$Latitude[(d$ColonyName == "Horn Island - Northeast")] <- 30.227800
d$Longitude[(d$ColonyName == "Horn Island - Northeast")] <- -88.611490

d$Latitude[(d$ColonyName == "Horn Island - Northwest")] <- 30.245860
d$Longitude[(d$ColonyName == "Horn Island - Northwest")] <- -88.747610

d$Latitude[(d$ColonyName == "Horn Island - Southeast")] <- 30.226130
d$Longitude[(d$ColonyName == "Horn Island - Southeast")] <- -88.624180

d$Latitude[(d$ColonyName == "Horn Island - Southwest")] <- 30.240280
d$Longitude[(d$ColonyName == "Horn Island - Southwest")] <- -88.758420

d$Latitude[(d$ColonyName == "Horn Island - West End")] <- 30.242420
d$Longitude[(d$ColonyName == "Horn Island - West End")] <- -88.778590


## Petit Bois
d<- within(d, ColonyName[ColonyName == 'Petit Bois Island - East Tip'] <- "Petit Bois Island - East")
d<- within(d, ColonyName[ColonyName == 'Petit Bois Island - West Tip'] <- "Petit Bois Island - West")
d<- within(d, ColonyName[ColonyName == 'Petit Bois Island - West End'] <- "Petit Bois Island - West")

# Edit coordinates to more appropriate location
d$Latitude[(d$ColonyName == "Petit Bois Island - East End Sand Flat")] <- 30.208820
d$Longitude[(d$ColonyName == "Petit Bois Island - East End Sand Flat")] <- -88.413310

d$Latitude[(d$ColonyName == "Petit Bois Island - East")] <- 30.2075300
d$Longitude[(d$ColonyName == "Petit Bois Island - East")] <- -88.4152100

d$Latitude[(d$ColonyName == "Petit Bois Island - North Shore")] <- 30.207450
d$Longitude[(d$ColonyName == "Petit Bois Island - North Shore")] <- -88.431040

d$Latitude[(d$ColonyName == "Petit Bois Island - South Shore")] <- 30.199670
d$Longitude[(d$ColonyName == "Petit Bois Island - South Shore")] <- -88.443170

d$Latitude[(d$ColonyName == "Petit Bois Island - South Shore Middle")] <- 30.202010
d$Longitude[(d$ColonyName == "Petit Bois Island - South Shore Middle")] <- -88.471260

d$Latitude[(d$ColonyName == "Petit Bois Island - West")] <- 30.215170
d$Longitude[(d$ColonyName == "Petit Bois Island - West")] <- -88.506260


## Spoil Island: Change name to "West Petit Bois Island"
d<- within(d, ColonyName[ColonyName == 'Spoil Island - Entire'] <- "West Petit Bois Island")
d<- within(d, ColonyName[ColonyName == 'Spoil Island - NorthWest'] <- "West Petit Bois Island - Northwest")

d<- within(d, ColonyName[ColonyName == 'Spoil Island - SouthWest'] <- "West Petit Bois Island - West")
d<- within(d, ColonyName[ColonyName == 'Spoil Island - West'] <- "West Petit Bois Island - West")

d$Latitude[(d$ColonyName == "West Petit Bois Island - West")] <- 30.223900
d$Longitude[(d$ColonyName == "West Petit Bois Island - West")] <- -88.524600

d$Latitude[(d$ColonyName == "West Petit Bois Island - Northwest")] <- 30.225420
d$Longitude[(d$ColonyName == "West Petit Bois Island - Northwest")] <- -88.526180

d<- d[!(d$ColonyName == "Spoil Island - West Side Sand Flat"),] # Redundant of WPBI - West


## Sand Island: Change name to "West Petit Bois Island"
d<- within(d, ColonyName[ColonyName == 'Sand Island - '] <- "West Petit Bois Island")
d<- within(d, ColonyName[ColonyName == 'Sand Island'] <- "West Petit Bois Island")
d$Latitude[(d$ColonyName == "West Petit Bois Island")] <- 30.222620
d$Longitude[(d$ColonyName == "West Petit Bois Island")] <- -88.518910

d<- within(d, ColonyName[ColonyName == 'Sand Island - Southeast'] <- "West Petit Bois Island - Southeast")
d$Latitude[(d$ColonyName == "West Petit Bois Island - Southeast")] <- 30.221830
d$Longitude[(d$ColonyName == "West Petit Bois Island - Southeast")] <- -88.515960

d<- within(d, ColonyName[ColonyName == 'Sand Island - South Shore'] <- "West Petit Bois Island - South Shore")
d$Latitude[(d$ColonyName == "West Petit Bois Island - South Shore")] <- 30.221530
d$Longitude[(d$ColonyName == "West Petit Bois Island - South Shore")] <- -88.522200
  
d<- within(d, ColonyName[ColonyName == 'Sand Island - South Dredged Area'] <- "West Petit Bois Island - South Dredged Area")
d$Latitude[(d$ColonyName == "West Petit Bois Island - South Dredged Area")] <- 30.218860
d$Longitude[(d$ColonyName == "West Petit Bois Island - South Dredged Area")] <- -88.520760

d<- within(d, ColonyName[ColonyName == 'Sand Island - Dredged Area'] <- "West Petit Bois Island - Dredged Area")
d$Latitude[(d$ColonyName == "West Petit Bois Island - Dredged Area")] <- 30.220220
d$Longitude[(d$ColonyName == "West Petit Bois Island - Dredged Area")] <- -88.519590


## Cat Island
d<- within(d, ColonyName[ColonyName == 'Cat Island - '] <- "Cat Island")
d$Latitude[(d$ColonyName == "Cat Island")] <- 30.2223750
d$Longitude[(d$ColonyName == "Cat Island")] <- -89.075760


### Clean up
# drop some columns
d <- subset(d, select = -c(Island, Location))

# check out levels for ColonyName
d$ColonyName <- as.factor(d$ColonyName)
levels(d$ColonyName)

# Some species names corrections: 
d<- within(d, Species[ Species == 'Gulf-billed Tern'] <- "Gull-billed Tern")
d<- within(d, Species[ Species == 'Black Skimmer '] <- "Black Skimmer")

# check out levels for Species
d$Species <- as.factor(d$Species)
levels(d$Species)

# check out levels for Year
d$Year <- as.factor(d$Year)
levels(d$Year)

## add column for state
d$State <- "Mississippi"

# add column for id to spp
d$Identified_to_species <- "yes"


##### Take look at duplicates ####

duplicates <-
  d %>%
  select(Year, ColonyName, Species, filename) %>%
  group_by(Year, ColonyName, Species) %>%
  summarise(n = n())
duplicates<- filter(duplicates, n>1)

d <- d[!(d$Year == "2011" & d$Species == "Black Skimmer" & 
          d$ColonyName == "Horn Island - East" & d$filename == "GUIS_SRS_Shorebird_data_2010-2012.csv"),]

d <- d[!(d$Year == "2012" & d$Species == "Black Skimmer" & 
           d$ColonyName == "Horn Island - East" & d$filename == "GUIS_SRS_Shorebird_data_2010-2012.csv"),]

d <- d[!(d$Year == "2011" & d$Species == "Least Tern" & 
           d$ColonyName == "Horn Island - East" & d$filename == "GUIS_SRS_Shorebird_data_2010-2012.csv"),]

d <- d[!(d$Year == "2012" & d$Species == "Gull-billed Tern" & 
           d$ColonyName == "Horn Island - East" & d$filename == "GUIS_SRS_Shorebird_data_2010-2012.csv"),]

rm(duplicates)


d$SpCountMethod <- "Maximum reported count"
d$SurveyVantagePoint <- "On-site visit"


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/GINS_data.csv")

############################################################################################
#################################### END ###################################################
############################################################################################