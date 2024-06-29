############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Central coast data (2016 - 2022)
# Provided by Brent Ortego 
# Re-organize, correct, and fill in blanks
# With help from spreadsheets TGLO COLONIAL WATERBIRDS 2021 - COLONY NAME HELP.xlsx 
# and TX_2010_2015_corrected_2022.12.08.csv


## Steps
# make corrections within the dataframe 
# try to fill is missing coords from other coords within Brent's dataframe
# bring in TCWS data (which has already had Daniel's coords added to it) to further fill in corrected coords
# bring in Daniel's data to fill in still missing coords
# contacted David Newstead and got a few missing coords
# dropped some colonies for which data was limited or none and no location info could be located

############################################################################################

## Started 2023-02-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(data.table)
library(readbulk)
library(parzer)
library(dplyr)


# use read_bulk to read in and combine Brent's central coast 2016-2022 data
d <- read_bulk(directory = "./data_original/Texas/Ortego_data", 
               subdirectories = FALSE, extension = ".csv", verbose = TRUE, fun = fread )  



##### ----- Corrections to Year
d$Year<- as.factor(d$Year)
levels(d$Year)



##### ----- Corrections to status

# make status a factor and correct spelling errors ("inacitve")
d$Status<- as.factor(d$Status)
levels(d$Status)
levels(d$Status)[levels(d$Status)=="inacitve"] <- "inactive"
levels(d$Status)[levels(d$Status)=="INACTIVE"] <- "inactive"
levels(d$Status)[levels(d$Status)=="?"] <- "unknown"
levels(d$Status)[levels(d$Status)=="?????"] <- "unknown"
levels(d$Status)[levels(d$Status)=="unkown"] <- "unknown"
levels(d$Status)[levels(d$Status)=="unknown status"] <- "unknown"
levels(d$Status)[levels(d$Status)=="actuve"] <- "active"
levels(d$Status)[levels(d$Status)=="SUBMERGED"] <- "submerged"
levels(d$Status)[levels(d$Status)=="not survyed"] <- "not surveyed"
levels(d$Status)[levels(d$Status)=="dnc"] <- "dns"
levels(d$Status)[levels(d$Status)=="DNS"] <- "dns"
levels(d$Status)[levels(d$Status)=="dns"] <- "not surveyed"
levels(d$Status)[levels(d$Status)=="active ????"] <- "unknown" # this one not surveyed
levels(d$Status)[levels(d$Status)=="active ??"] <- "active"



##### ----- Corrections to Survey.Type

# make Survey.Type a factor
d$Survey.Type<- as.factor(d$Survey.Type)
levels(d$Survey.Type)
levels(d$Survey.Type)[levels(d$Survey.Type)=="on-site-drone"] <- "drone"
levels(d$Survey.Type)[levels(d$Survey.Type)=="aerial drone"] <- "drone"
levels(d$Survey.Type)[levels(d$Survey.Type)=="dns"] <- "not surveyed"
levels(d$Survey.Type)[levels(d$Survey.Type)=="adjoining"] <- "adjacent"

# Need to move 'not surveyed' from status to survey type 
d <- within(d, Survey.Type[Status == 'not surveyed' & Survey.Type == ''] <- 'not surveyed')
d <- within(d, Status[Status == 'not surveyed' & Survey.Type == 'not surveyed'] <- 'unknown')

d <- within(d, Survey.Type[Status == 'active but not surveyed' & Survey.Type == ''] <- 'not surveyed')
d <- within(d, Status[Status == 'active but not surveyed' & Survey.Type == 'not surveyed'] <- 'active')

d$Status <- droplevels(d$Status) # remove empty factor level

# Need to move inactive from survey type to status
d <- within(d, Status[Status == '' & Survey.Type == 'inactive'] <- 'inactive')
d <- within(d, Survey.Type[Status == 'inactive' & Survey.Type == 'inactive'] <- '')
d$Survey.Type <- droplevels(d$Survey.Type)# remove empty factor level


# remove File column
d <- select(d, -File)



##### ----- Correct missing colony names

# 614-221c == Naval Air Station Islands - c
d <- within(d, Colony.Name[Colony.Code == '614-221c' & Colony.Name == ''] <- 'Naval Air Station Islands - c')

# 614347 == Marker 85 A Spoil Island (NM 165)
d <- within(d, Colony.Name[Colony.Code == '614-347'] <- 'Marker 85 A Spoil Island (NM 165)')

# 614-221i == Naval Air Station Islands - I
d <- within(d, Colony.Name[Colony.Code == '614-221i' & Colony.Name == ''] <- 'Naval Air Station Islands - i')

# 614-201 == East Shore Spoil
d <- within(d, Colony.Name[Colony.Code == '614-201B'] <- 'East Shore Spoil')

# 614-362a == South Baffin Bay Island - a
d <- within(d, Colony.Name[Colony.Code == '614-362a' & Colony.Name == ''] <- 'South Baffin Bay Island - a')

# 614-222h == Kennedy Causeway Islands - h
d <- within(d, Colony.Name[Colony.Code == '614-222h' & Colony.Name == ''] <- 'Kennedy Causeway Islands - h')

# two rows still don't have colony names, IDs, or latlong - dunno how to identify those



#### ---- Correct colony names

# 3rd chain == Third chain
d <- within(d, Colony.Name[Colony.Code == '609-424' & Colony.Name == '3rd chain'] <- 'Third Chain')

# Corey Covey == Corey Cove
d <- within(d, Colony.Name[Colony.Name == 'Corey Covey'] <- 'Corey Cove')

# South sweeny switch  == South Swinney Switch
d <- within(d, Colony.Name[Colony.Name == 'South sweeny switch'] <- 'South Swinney Switch')



##### ----- Correct missing colony codes

# North Bay Sanctuary  == 614293
d <- within(d, Colony.Code[Colony.Name == 'North Bay Sanctuary' & Colony.Code == ''] <- '614-293')

# Third Chain == 609424
d <- within(d, Colony.Code[Colony.Name == 'Third Chain A' & Colony.Code == ''] <- '609-424')
d <- within(d, Colony.Code[Colony.Name == 'Third Chain A1' & Colony.Code == ''] <- '609-424')
d <- within(d, Colony.Code[Colony.Name == 'Third Chain A2' & Colony.Code == ''] <- '609-424')
d <- within(d, Colony.Code[Colony.Name == 'Third Chain B, D' & Colony.Code == ''] <- '609-424')
d <- within(d, Colony.Code[Colony.Name == 'Third Chain D' & Colony.Code == ''] <- '609-424')

# Pure oil channel == 614-308
d <- within(d, Colony.Code[Colony.Name == 'Pure oil channel' & Colony.Code == ''] <- '614-308')

# Chaney #12 == 614-380
d <- within(d, Colony.Code[Colony.Name == 'chaney #12' & Colony.Code == ''] <- '614-380')

# Chaney 23 == 614-362d
d <- within(d, Colony.Code[Colony.Name == 'chaney #23' ] <- '614-362d')

# Chaney 26 == 614-361
d <- within(d, Colony.Code[Colony.Name == 'chaney #26' & Colony.Code == ''] <- '614-361b')
d <- within(d, Colony.Code[Colony.Name == 'chaney #26' & Colony.Code == 'b'] <- '614-361b')

# Chaney 27 == 614-361 c
d <- within(d, Colony.Code[Colony.Name == 'chaney #27'] <- '614-361c')

# Chaney 28 == 614-361 d (Marker 103-117 Spoil (NM 207-221) - D)
d <- within(d, Colony.Code[Colony.Name == 'chaney #28' ] <- '614-361d')

# Chaney 29 == 614-361 e (Marker 103-117 Spoil (NM 207-221) - E)
d <- within(d, Colony.Code[Colony.Name == 'chaney #29' ] <- '614-361e')

# Chaney 30 == 614-361 f  (Marker 103-117 Spoil (NM 207-221) - F)
d <- within(d, Colony.Code[Colony.Name == 'chaney #30' ] <- '614-361f')

# Chaney 31 == 614-361  Marker 103-117 Spoil (NM 207-221) - G
d <- within(d, Colony.Code[Colony.Name == 'chaney #31' ] <- '614-361g')

# chaney #58 == 614-305h
d <- within(d, Colony.Code[Colony.Name == 'chaney #58' ] <- '614-305h')

# Little Bay S == Little Bay B == 609-482b  (I made a decision here to make little bay south B bc that seems to me the southernmost available coordinate for little bay)
d <- within(d, Colony.Code[Colony.Name == 'Little Bay s' ] <- '609-482b')

# observation tower road == 609-426
d <- within(d, Colony.Code[Colony.Name == 'observation tower road' & Colony.Code == ''] <- '609-426')

# Corey Cove == 609-324
d <- within(d, Colony.Code[Colony.Name == 'Corey Cove'] <- '609-324')

# South Swinney Switch  == 614-281
d <- within(d, Colony.Code[Colony.Name == 'South Swinney Switch'] <- '614-281')

# Salt Bay (make colony letter lower case)
d <- within(d, Colony.Code[Colony.Name == 'Salt Lake' & Colony.Code == '609-462 A'] <- '609-462 a')
d <- within(d, Colony.Code[Colony.Name == 'Salt Lake' & Colony.Code == '609-462 B'] <- '609-462 b')

# Chaneys with dashes instead of hashes
d <- within(d, Colony.Name[Colony.Name == 'chaney-1' ] <- 'Chaney #1')
d <- within(d, Colony.Name[Colony.Name == 'chaney-4' ] <- 'Chaney #4')
d <- within(d, Colony.Name[Colony.Name == 'chaney-5' ] <- 'Chaney #5')
d <- within(d, Colony.Name[Colony.Name == 'chaney-7' ] <- 'Chaney #7')
d <- within(d, Colony.Name[Colony.Name == 'chaney-8' ] <- 'Chaney #8')


##### ----- Corrects around third chain of islands group

# Third Chain of Islands
d <- within(d, Colony.Name[Colony.Code == '609-424' & Colony.Name == 'Third Chain'] <- 'Third Chain of Islands')

# Third Chain A to Third Chain of Islands - A
d <- within(d, Colony.Name[Colony.Code == '609-424' & Colony.Name == 'Third Chain A'] <- 'Third Chain of Islands-A')

# Third Chain D to Third Chain of Islands - D
d <- within(d, Colony.Name[Colony.Code == '609-424' & Colony.Name == 'Third Chain D'] <- 'Third Chain of Islands-D')

# Colonies that are left with no colony code: 
# Sanctuary Island  - has coords
# Choke Canyon West   - no coords
# chaney #37 Marker 169  - no coords



##### ----- Swap lat longs that are in the wrong columns

# La Quinta Marsh Lat == 27.8686  Long == 97.2802
d <- within(d, Lat[Colony.Name == 'La Quinta Marsh' & Colony.Code =='614-162'] <- '27.8686')
d <- within(d, Long[Colony.Name == 'La Quinta Marsh' & Colony.Code =='614-162'] <- '97.2802')



##### ----- correct lat longs in a different formats

# put all cordinates in same format
d$Latitude <- parse_lat(d$Lat)
d$Longitude <- parse_lon(d$Long)

# rename old column names (there may be info other than coords stored in these columns, which is why I'm keeping them)
d <- d %>% rename(Lat_old = Lat, Long_old = Long)


##### ----- Fill in missing lat longs

# pull out rows WITH coordinates to new dataframe
# first drop nas
xy <- drop_na(d, c(Lat_old, Long_old))
# now drop rows with blanks
xy<- xy[xy$Lat_old != "", ]
xy<- xy[xy$Long_old != "", ]

# xy == dataframe of rows that have coordinates

# create new dataframe of rows that already have coords
# so rows reunited with coords can be added to it later
complete_rows <- xy

# Pull xy rows out of d to leave behind rows that need coordinates to new dataframe
noxy <- setdiff(d, xy)
noxy = subset(noxy, select = -c(Latitude, Longitude) )

# drop columns
xy <- xy %>% select(Colony.Name, Colony.Code, Latitude, Longitude) #, Lat_old, Long_old

# select only unique colony codes
xy <- distinct(xy)


##### ----- Use XY list of locations to fill in missing lat/longs for the rest of data 

t<- left_join(noxy,xy, by = c("Colony.Name", "Colony.Code"))

# relocation Latitude and Longitude columns for ease of viewing
t  <- t  %>% relocate(Latitude, .before = Lat_old)
t  <- t  %>% relocate(Longitude, .before = Lat_old)

# pull out rows still without lat longs
still_noxy <- t[is.na(t$Latitude), ]

# filter for rows that just had coords added 
t <- drop_na(t, c(Latitude, Longitude))

# now add t to complete_rows
complete_rows <- bind_rows(complete_rows,t) 


# prepare still_noxy dataset for joining with TCWS data
# remove special characters from colony code
still_noxy$Colony.Code <- gsub("[[:punct:]]", "", still_noxy$Colony.Code)

# remove space from colony code
still_noxy$Colony.Code <- gsub(" ","", still_noxy$Colony.Code)

# Split Colony.Code into number (colony) and letter (sub-colony) codes
# first use too_few = "debug" to look at errors and make sure ok
# then use too_few = "align_start"
still_noxy <- still_noxy %>% 
  separate_wider_position(cols = Colony.Code, c(Colony.Code = 6, Subcolony.Letter = 10),
                          too_few = "align_start")

# drop columns
still_noxy <- subset(still_noxy, select = -c(Longitude, Latitude))



##### ----- Bring in lat/longs from other sources

# bring in update from Daniel Gao
tcws <- read.csv( "./data_original/Texas/TCWS_w_Gao_updates.csv")

#rename some columns
tcws <- tcws %>% rename(Colony.Code = ColonyID)
tcws <- tcws %>% rename(Subcolony.Letter = Subcolony.code.KH)

# drop columns
tcws <- subset(tcws, select = -c(X, ColonyName))

# rename some columns
tcws$Colony.Code <- as.factor(tcws$Colony.Code)
still_noxy$Colony.Code <- as.factor(still_noxy$Colony.Code)

matched <- left_join(still_noxy,tcws, by = c("Colony.Code", "Subcolony.Letter"))

# relocate column for ease of viewing
matched  <- matched %>% relocate(Colony.Name.y , .before = Colony.Code)
matched  <- matched %>% relocate(Latitude, .before = Lat_old)
matched  <- matched %>% relocate(Longitude, .before = Lat_old)



##### ----- Combine these newly given lat/long rows (matched) 
##### with above dataframe (complete rows) that have coords

### pull out remaining rows without lat/longs
still_noxy2  <-
  matched %>%
  filter(is.na(Latitude))

rm(matched)

# pull out rows that had a match
matched_only <- inner_join(still_noxy,tcws, by = c("Colony.Code", "Subcolony.Letter"))

# Bring together matched and complete rows. 
# Modifications needed so columns names match
# matched: drop Colony.Name.x and rename to Colony.Name 
matched_only <- matched_only %>% relocate(Colony.Name.y , .before = Colony.Code)
matched_only <- subset(matched_only, select = -c(Colony.Name.x ))
matched_only <- matched_only %>% rename(Colony.Name = Colony.Name.y)

# complete_rows: separate Colony.Code and create Subcolony.Letter
#remove special characters from colony code
complete_rows$Colony.Code <- gsub("[[:punct:]]", "", complete_rows$Colony.Code)

# remove space from colony code
complete_rows$Colony.Code <- gsub(" ","", complete_rows$Colony.Code)

# Split Colony.Code into number (colony) and letter (sub-colony) codes
complete_rows <- complete_rows %>% separate_wider_position(cols = Colony.Code, c(Colony.Code = 6, Subcolony.Letter = 8), too_few = "align_start")

# now that columns all match, add matched_only to the bottom of complete_rows
complete_rows <- bind_rows(complete_rows, matched_only)

complete_rows <- complete_rows%>% relocate(Latitude, .before = Lat_old)
complete_rows <- complete_rows %>% relocate(Longitude, .before = Lat_old)

rm(matched_only)


##### ----- See if Daniel Gao's coords match any of the rows still needing coords

# Read in data
daniel <- read.csv( "./data_original/Texas/Texas_Subcolonies_Missing_Coordinates_from_GLO_Rookeries_Polygon_Layer.csv")

# pull out only columns needed
daniel<- select(daniel, Colony.ID,Colony.Name, Colony.Code, Subcolony.code.KH, Subisland, Subcolony, Latitude, Longitude)

# remove special characters from colony code
daniel$Colony.Code <- gsub("[[:punct:]]", "", daniel$Colony.Code)

# remove space from colony code
daniel$Colony.Code <- gsub(" ","", daniel$Colony.Code)

#Split Colony.Code into number (colony) and letter (sub-colony) codes
daniel <- daniel %>% separate_wider_position(cols = Colony.Code, c(Colony.Code = 6, Subcolony.Letter = 2), too_few = "align_start")

# pull out only rows to match
daniel<- select(daniel, Colony.Name, Colony.Code, Subcolony.code.KH, Latitude, Longitude)
# can now match to rows with missing coordinates using Colony.Code and Subcolony.code.KH

# change column names to match tcws data
daniel<- daniel %>% rename(Subcolony.Letter = Subcolony.code.KH)

still_noxy2 <- subset(still_noxy2, select = -c(Longitude, Latitude ))

# do the join. left join keeps all left dataframe
matched_daniel <- left_join(still_noxy2, daniel, by = c("Colony.Code", "Subcolony.Letter"))#, multiple = "all"

# relocate column for ease of viewing
matched_daniel  <- matched_daniel %>% relocate(Colony.Name , .before = Colony.Code)
matched_daniel  <- matched_daniel %>% relocate(Latitude, .before = Lat_old)
matched_daniel  <- matched_daniel %>% relocate(Longitude, .before = Lat_old)

# pull out remaining rows without lat/longs
still_noxy3  <-
  matched_daniel %>%
  filter(is.na(Latitude))

# pull out rows that matched so now have coords
matched_daniel <- setdiff(matched_daniel, still_noxy3)

# make columns align to prep for added these matched rows to completed rows
matched_daniel <- subset(matched_daniel, select = -c(Colony.Name.x, Colony.Name.y))

# add matched rows to dataframe of completed rows
complete_rows <- bind_rows(complete_rows, matched_daniel)

# remove dataframes of rows without coords. leave the one of currents rows without coords
rm(noxy, still_noxy, still_noxy2,  matched_daniel, daniel)



##### ----- Pull out list of colonies that still don't have lat/longs

# removed some columns
still_noxy3 <- subset(still_noxy3, select = -c(Colony.Name.y, Colony.Name, Latitude, Longitude ))

# take a look colonies still without coords
#leftover <- select(still_noxy3, Colony.Name.x, Colony.Code, Subcolony.Letter)
#leftover <- unique(leftover)

# export complete rows to pull up in ArcGIS
## coordinates need corrections
# pull out rows that should have negative Longitude
make_negative <- complete_rows %>% filter (Longitude > 0)

already_negative <- complete_rows %>% filter (Longitude < 0)

# make longitude negative
make_negative$Longitude <- make_negative$Longitude*-1

#combine back with rest of the dataframe 
complete_rows <- bind_rows(make_negative, already_negative)
rm(make_negative, already_negative)


#### Make some corrections #### 

still_noxy3 <- still_noxy3 %>% rename(Colony.Name= Colony.Name.x)


##### ----- Correct colony names

# 2-ring Island (BU north of 2nd chain) == 2-ring Island
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == '2-ring Island (BU north of 2nd chain)'] <- '2 Ring Island')

# Cape Carlos Dugout to  Cape Carlos Dugout Island
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Cape Carlos Dugout'] <- 'Cape Carlos Dugout Island')

#BUJ (headache) to Beneficial Use near Dunham Island
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'BUJ (headache)'] <- 'Beneficial Use near Dunham Island')

# Wright's gravel pits to Wright Gravel Pits
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == "Wright's gravel pits"] <- 'Wright Gravel Pits')

# Salada Mill (Roddy Island) and Salada Mill to Roddy Island / Salada Mill
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == "Salada Mill (Roddy Island)" | Colony.Name == "Salada Mill"] <- 'Roddy Island / Salada Mill')

# Pelican Island to Pelican Island Spoil
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == "Pelican Island"] <- 'Pelican Island Spoil')

# Nueces River Mouth (614292) (careful here this site name has multiple codes) to Nueces River Estuary  
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == "Nueces River Mouth" & Colony.Code == "614292"] <- 'Nueces River Estuary')

# North Bay Sanctuary to North Bay CBA Sanctuary
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'North Bay Sanctuary'] <- 'North Bay CBA Sanctuary')

# No Name Road to Observation Tower Colony / No name road
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'No Name Road'] <- 'Observation Tower Colony / No name road')

# New Island (skimmer island) to Skimmer Island
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'New Island (skimmer island)'] <- 'Skimmer Island')

# Marker 55-57 spoil to GIWW Marker 55-57 Spoil
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Marker 55-57 spoil'] <- 'GIWW Marker 55-57 Spoil')

# Marker 53 Spoil to GIWW Marker 53 Spoil
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Marker 53 Spoil'] <- 'GIWW Marker 53 Spoil')

# Marker 51 Spoil to GIWW Marker 51 Spoil
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Marker 51 Spoil'] <- 'GIWW Marker 51 Spoil')

# Marker 33 Spoil to
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Marker 33 Spoil'] <- 'GIWW Marker 51 Spoil')

# Live Oak Pen/Pine Woodland to  Live Oak Peninsula/Pine woodland Colony
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Live Oak Pen/Pine Woodland'] <- 'Live Oak Peninsula/Pine woodland Colony')

# La Quinta Spoil  to LaQuinta Spoil Islands
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'La Quinta Spoil'] <- 'LaQuinta Spoil Islands')

# Ingleside Point (Berry Island) to Ingleside Point
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Ingleside Point (Berry Island)'] <- 'Ingleside Point')

# Causeway Island to Hog Island Complex
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == "Causeway Island" & Colony.Code == "614123"] <- 'Hog Island Complex')

# Matagorda Is. South Pond to Matagorda Island Airbase 
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == "Matagorda Is. South Pond"] <- 'Matagorda Island Airbase')

# Causeway Island to Causeway Island Platforms
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Causeway Island' & Colony.Code == "614121" & Subcolony.Letter == "A"] <- 'Causeway Island Platforms - A')
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Causeway Island' & Colony.Code == "614121" ] <- 'Causeway Island Platforms')

# chaney #110 to Causeway Islands - e
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'chaney #110' & Colony.Code == "614240" & Subcolony.Letter == "E"] <- 'Causeway Islands - e')

#N Bird Island, Marker 43 to North of Bird Island Marker 43
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'N Bird Island, Marker 43' & Colony.Code == "614304" ] <- 'North of Bird Island Marker 43')

# Second Chain to Second Chain of Islands
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Second Chain' & Colony.Code == "609422" ] <- 'Second Chain of Islands')

# Second Chain A to Second Chain of Islands-A
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Second Chain A' & Colony.Code == "609422" ] <- 'Second Chain of Islands-A')

# Second Chain E to Second Chain of Islands-E
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Second Chain E' & Colony.Code == "609422" ] <- 'Second Chain of Islands-E')

# Second Chain F to Second Chain of Islands-F
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Second Chain F' & Colony.Code == "609422" ] <- 'Second Chain of Islands-F')

# Nueces Bay Marsh Restoration Site to Sunfish Island/Nueces Bay Marsh Restoration Site
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'Nueces Bay Marsh Restoration Site' & Colony.Code == "614144" ] <- 'Sunfish Island/Nueces Bay Marsh Restoration Site')

# 	GIWW Marker 51 Spoil to 	Bay Harbor
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'GIWW Marker 51 Spoil' & Colony.Code == "614104" ] <- 'Bay Harbor')

# chaney #12 to Marker 139-155 Spoil  (19-35)
still_noxy3 <- within(still_noxy3, Colony.Name[Colony.Name == 'chaney #12' & Colony.Code == "614380" ] <- 'Marker 139-155 Spoil  (19-35)')


##### ----- Correct colony codes

# Aransas Refuge Spoil 	   609422 to 609421
still_noxy3 <- within(still_noxy3, Colony.Code[Colony.Name == 'Aransas Refuge Spoil' & Colony.Code == '609422'] <- '609421')


#### Bring in full TCWS to try to match coordinates #### 

# read in data
tx2 <- read.csv("./data_original/Texas/TX_2010_2015_corrected_2022.12.08.csv")

# pull out needed columns
tx2<- select(tx2, ColonyID, ColonyName, Latitude, Longitude)

# rename columns to match
tx2 <- tx2 %>% rename(Colony.Code = ColonyID)
tx2 <- tx2 %>% rename(Colony.Name= ColonyName)

# distinct rows only
tx2 <- distinct(tx2)

# pull out rows that have coordinates 
tx2 <- tx2 %>% filter (Longitude != 0)
tx2$Colony.Code <- as.character(tx2$Colony.Code)
matched_tx2 <- left_join(still_noxy3, tx2, by = c("Colony.Name", "Colony.Code"))
matched_tx2 <- matched_tx2 %>% relocate(Latitude, .before = Lat_old)
matched_tx2  <- matched_tx2%>% relocate(Longitude, .before = Lat_old)

# export tx2 to add subcolony letters
# write.csv(tx2, "./data_original/Texas/TX_2010_2015_corrected2022.12.08_subcolony_letter_added.csv")

# bring that spreadsheet back in w new subcolony letters
tx2 <- read.csv("./data_original/Texas/TX_2010_2015_corrected2022.12.08_subcolony_letter_added.csv")



##### ----- Add matched rows to complete_rows

# pull out still unmatched from from matched_tx2
still_noxy4  <-
  matched_tx2 %>%
  filter(is.na(Latitude))

# remove old unmatched set
rm(still_noxy3)

# pulled out matched rows to add to complete_rows
complete_rows <-  setdiff(matched_tx2, still_noxy4) %>%
  bind_rows(complete_rows)



##### ----- Join TX2 and still_noxy4 by Colony.Code and Subcolony.Letter

# edits to tx2
tx2 <-  subset(tx2, select = -c(X ))
tx2$Colony.Code <- as.character(tx2$Colony.Code) # Colony.Code is a character in still_noxy4 bc some rows have letters

# edits to still_noxy4
still_noxy4 <- subset(still_noxy4, select = -c(Longitude, Latitude ))


matched_tx3<- left_join(still_noxy4, tx2, by = c("Colony.Code",  "Subcolony.Letter"))
rm(matched_tx2)

matched_tx3  <- matched_tx3 %>% relocate(Latitude, .before = Lat_old)
matched_tx3  <- matched_tx3%>% relocate(Longitude, .before = Lat_old)
matched_tx3  <- matched_tx3%>% relocate(Colony.Name.y, .before = Colony.Code)



##### ----- Add matched rows to complete_rows

# pull out still unmatched from from matched_tx2
still_noxy5  <-
  matched_tx3 %>%
  filter(is.na(Latitude))

# remove old unmatched set
rm(still_noxy4)

# pulled out matched rows to add to complete_rows
matched_tx3 <-  setdiff(matched_tx3, still_noxy5) 

# make some edits so columns match
matched_tx3  <- subset(matched_tx3 , select = -c(Colony.Name.x))
matched_tx3  <- matched_tx3  %>% rename(Colony.Name = Colony.Name.y)

# add matched_tx3 to complete colonies
complete_rows <- bind_rows(complete_rows, matched_tx3)

rm(matched_tx3)


##### ----- Check 224 rows left with no lat/longs

# a few edits to the dataframe
still_noxy5  <- subset(still_noxy5, select = -c(Colony.Name.y))
still_noxy5  <- still_noxy5 %>% rename(Colony.Name = Colony.Name.x)

unique(still_noxy5$Colony.Name)
# [1] "Third Chain A1"                    "Third Chain A2"                    "Third Chain B, D"                 
# [5] "Second Chain"                      "Second Chain A"                    "Second Chain E"                    "Second Chain F"                   
# [9]  "Intracoastal Channel Marker 91"    "West Nueces Bay 51 (E) e"         
# [13]"Chaney 201A"                       "chaney-201B"                      
# [17] "chaney #12"                        "chaney #37 Marker 169"             "chaney #58"                        "chaney #94"                       
# [21] "chaney #102"                       "chaney #128"                       "willow dugout"                     "San Jose-Carlos Bay"              
# [25] "Beneficial Use near Dunham Island"  "Redfish Lake"                     
# [29] "Nueces River Mouth"                "Pure oil channel"                  "Hap's cut"                         "Infrastructure Is."               


##### ----- Add some latitude and longitude 

# Causeway Island Platforms - A
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Causeway Island Platforms - A'& Colony.Code == "614121" & Subcolony.Letter == "A"] <- 27.93262222)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Causeway Island Platforms - A'& Colony.Code == "614121" & Subcolony.Letter == "A"] <- -97.09950407)

# Third Chain of Islands - A
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Third Chain of Islands-A'& Colony.Code == "609424"] <- 28.15584976)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Third Chain of Islands-A' & Colony.Code == "609424"] <- -96.87438007)

# Third Chain of Islands - D
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Third Chain of Islands-D'& Colony.Code == "609424"] <- 28.14670715)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Third Chain of Islands-D' & Colony.Code == "609424"] <- -96.87383927)

# Third Chain A1 in Brent's 2022 data is 609-424b
still_noxy5 <- within(still_noxy5, Colony.Name[Colony.Name == 'Third Chain A1'] <- 'Third Chain of Islands - A1')
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Third Chain of Islands - A1'] <- 28.15209631)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Third Chain of Islands - A1' ] <- -96.87321605)

# Third Chain A2 in Brent's 2022 data is 609-424c
still_noxy5 <- within(still_noxy5, Colony.Name[Colony.Name == 'Third Chain A2'] <- 'Third Chain of Islands - A2')
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Third Chain of Islands - A2'] <- 28.15097723)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Third Chain of Islands - A2' ] <- -96.87274271)

# Redfish Lake -- coordinates sent by Brent 5/11/23
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Redfish Lake'] <- 28.62)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Redfish Lake' ] <- -96.39)

# need to separate "Third Chain B, D"  so b and d each get their own rows
# I'm assuming here that these colonies were both empty or submerged 
# so they were included in a single datasheet
thirdchainbd <- still_noxy5 %>% filter (Colony.Name ==	'Third Chain B, D')

# drop these rows from sill_noxy5
still_noxy5 <- setdiff(still_noxy5, thirdchainbd)

# b and d get their own dataframe
thirdchain_b <- thirdchainbd
thirdchain_d <- thirdchainbd
remove(thirdchainbd)

# update information - b
thirdchain_b$Subcolony.Letter <- 'b'
thirdchain_b$Latitude <- 28.15209631
thirdchain_b$Longitude <- -96.87321605
thirdchain_b$Colony.Name <- 'Third Chain of Islands-B'

# update information - d
thirdchain_d$Subcolony.Letter <- 'd'
thirdchain_d$Latitude <- 28.14670715
thirdchain_d$Longitude <- -96.87383927
thirdchain_d$Colony.Name <- 'Third Chain of Islands-D'

# add thirdchain_b and thirdchain_d to complete_rows
# IMPORTANT NOTE: complete rows will now be 6 rows longer than d (the original amt of rows) bc 2 colonies data were previously stored in single rows now separated here
complete_rows <- bind_rows(complete_rows, thirdchain_d)
complete_rows <- bind_rows(complete_rows, thirdchain_b)
rm( thirdchain_b, thirdchain_d)



##### ----- Drop some rows

# drop choke canyon
still_noxy5 <- subset(still_noxy5, Colony.Name != "Choke Canyon West")

# drop blank colony name 
still_noxy5 <- subset(still_noxy5, Colony.Name != "")

# drop single row "NEW"
still_noxy5 <- subset(still_noxy5, Colony.Name != "NEW")



##### ----- Live Oak Pen/Pine Oak Woodland

# There appears to be duplicates 2016-2020 for Live Oak Peninsula/Pine woodland Colony
# already in complete_rows: => drop those years
# pull out duplicate years
remove_liveoak <- subset(still_noxy5, Colony.Name == "Live Oak Pen/Pine Oak Woodland" & Year != "2021" & Year != "2022")
#drop them from still_noxy5
still_noxy5<-setdiff(still_noxy5, remove_liveoak )
rm(remove_liveoak)

# Change name from Live Oak Pen/Pine Oak Woodland to Live Oak Peninsula/Pine woodland Colony
still_noxy5 <- within(still_noxy5, Colony.Name[Colony.Name == 'Live Oak Pen/Pine Oak Woodland'] <- 'Live Oak Peninsula/Pine woodland Colony')

# change colony code from 609431 to 609487
still_noxy5 <- within(still_noxy5, Colony.Code[Colony.Name == 'Live Oak Peninsula/Pine woodland Colony'] <- '609487')

# assign coordinates
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'Live Oak Peninsula/Pine woodland Colony'] <- 28.03863)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'Live Oak Peninsula/Pine woodland Colony' ] <- -97.04156)

#San Jose- Carlos Bay   -- couldn't find coordinates, David wasnt sure so I chose a spot on san jose island near carlos bay  28.115359, -96.889068
# also applied same coords to TCWS colony of same name/numer
still_noxy5 <- within(still_noxy5, Latitude[Colony.Name == 'San Jose-Carlos Bay'] <- 28.115359)
still_noxy5 <- within(still_noxy5, Longitude[Colony.Name == 'San Jose-Carlos Bay' ] <- -96.889068)



##### ----- Pull out rows with coords in still_noxy5 and add to complete rows

still_noxy5 <- still_noxy5[is.na(still_noxy5$Latitude), ]
add_to_complete <- still_noxy5 %>% filter (Latitude > 0)
complete_rows <- bind_rows(complete_rows, add_to_complete)
rm(add_to_complete)

unique(still_noxy5$Colony.Name)



#### Coordinates from David Newstead ####

# read in the David's data
david <- read.csv("./data_original/Texas/David_Newstead_coordinates_2023.05.10.csv")

# drop columns not needed
david <- subset(david, select = -c(Alternate.Colony.Name))
david$Colony.Code <- as.character(david $Colony.Code) 

# drop lat and long columns
still_noxy5 = subset(still_noxy5, select = -c(Latitude, Longitude) )

# join colonies missing coordinates and david's coords
after_david <- left_join(still_noxy5, david, by = c("Colony.Code", "Subcolony.Letter"))

# move lat and long for ease of viewing
after_david  <- after_david %>% relocate(Latitude, .before = Lat_old)
after_david  <- after_david %>% relocate(Longitude, .before = Lat_old)

# drop column
after_david  <- subset(after_david , select = -c(Colony.Name.y) )

#rename colony name
after_david <- after_david %>% rename(Colony.Name = Colony.Name.x)


# new dataframe of rows wo coordinates
still_noxy6 <- after_david[is.na(after_david$Latitude), ]

# pull out matched rows
add_to_complete <- after_david%>% filter (Latitude > 0)

# add them to complete rows
complete_rows <- bind_rows(complete_rows, add_to_complete)
rm(add_to_complete, after_david, still_noxy5, david)

unique(still_noxy6$Colony.Name)


##### ----- Dropping colonies w no info based on David Newstead input

# to drop and why:
# chaney #37 Marker 169 -- there's no spp info, may not have actually been surveyed
# chaney #58 -- David doesn't have records of this one and there's no spp info, may not have actually been surveyed
# chaney #94 -- David doesn't have records of this one and there's no spp info, may not have actually been surveyed
# Intracoastal Channel Marker 91 -- no data and no info from David
# Second Chain of Islands-A,e,f -- David says these likely eroded years ago and theres no data in my spreadsheet 
# willow dugout -- this colony also present in TCWS data but theres no data and David has never heard of it
# chaney-201B -- David didn't have record of this colony and there was only data for gbhe for one yr
# Chaney 201A -- David didn't have record of this colony and only data for 2021 for a few waders
# Pure oil channel -- David didn't have record of this colony and little data
# San Jose- Carlos Bay  -- David didn't have record of this colony and little data

still_noxy6  <- still_noxy6 %>% filter (Colony.Name !=	'chaney #37 Marker 169' & 
                                          Colony.Name !=	'chaney #58' & 
                                          Colony.Name !=	'chaney #94' & 
                                          Colony.Name !=	'Intracoastal Channel Marker 91' &
                                          Colony.Name !=	'Second Chain of Islands-A' &  
                                          Colony.Name !=	'Second Chain of Islands-E' & 
                                          Colony.Name !=	'Second Chain of Islands-F' &
                                          Colony.Name !=	'willow dugout'  &
                                          Colony.Name !=  'chaney-201B' &
                                          Colony.Name !=  'Chaney 201A' & 
                                          Colony.Name !=  'Pure oil channel' &
                                          Colony.Name !=  'San Jose-Carlos Bay')

# Two Colonies left, I emailed these surveyors on 5/15 to asked for coordinates

# Infrastructure Is. -- Trey Barron   28.291116, -96.612031
still_noxy6 <- within(still_noxy6, Latitude[Colony.Name == 'Infrastructure Is.'] <- 28.291116)
still_noxy6 <- within(still_noxy6, Longitude[Colony.Name == 'Infrastructure Is.' ] <- -96.612031)

# West Nueces Bay 51 (E) e --
# Justin LeClaire: "Can't find the exact location of this old colony but 
#                   it is one of the many now-submerged spoils in west nueces bay"
# I assigned this colony a location nearby the other west nueces bay locations
still_noxy6 <- within(still_noxy6, Latitude[Colony.Name == 'West Nueces Bay 51 (E) e'] <- 27.855)
still_noxy6 <- within(still_noxy6, Longitude[Colony.Name == 'West Nueces Bay 51 (E) e' ] <- -97.484)

# add these rows to complete rows - now all rows have coordinates!! 
complete_rows <- bind_rows(complete_rows, still_noxy6)


# write complete rows to csv
# write.csv(complete_rows, "Brent_TXcentralcoast_data2016-2022.csv")



##### ---- Intermediate count of complete rows

# 2132 (Brent's original number of rows)
# + 6 (from separating combined rows of third chain b and third chain d) 
# - 2 (rows that were missing colony name and code so unidentifiable)
# - 1 (row w colony name NEW and no code so unidentifiable)
# - 7 (Choke Canyon west - no coordinates but an inland site)
# - 8 (Live Oak Pen/Pine Oak Woodland duplicates)


# remove dataframes no longer needed
rm(d, still_noxy6, t, tcws, tx2, xy)

# change complete rows into d for easier coding below
d<- complete_rows

rm(complete_rows)



#### Modify data types for species #### 

# Prepare for pivot wider
# Can't pivot to wider if all of the data types aren't the same
# species that need modification bc they aren't integers: AWPE, BRPE, DCCO, BLSK, LEBI

# AWPE
d <- d %>%                               # Replacing values
  mutate(AWPE = replace(AWPE, AWPE == "just loafing birds", 0)) %>%
  mutate(AWPE = replace(AWPE, AWPE == "Submerged", 0))%>%
  mutate(AWPE = replace(AWPE, AWPE == "Z", 0))

d$AWPE <- as.integer(d$AWPE)

# # DCCO
d$DCCO <- as.integer(d$DCCO)

# BRPE
d <- d %>%
  mutate(BRPE = replace(BRPE, BRPE == "submerged", 0))
d$BRPE <- as.integer(d$BRPE) 

# #LEBI
d$LEBI <- as.integer(d$LEBI)

# #GRHE
d$GRHE <- as.integer(d$GRHE)

# BLSK
d <- d %>%
  mutate(BLSK = replace(BLSK, BLSK == "8 (maybe 0)", 8)) %>%
  mutate(BLSK = replace(BLSK, BLSK == "6 (4?)", 6)) %>%
  mutate(BLSK = replace(BLSK, BLSK == "present but no nests", 0))

d$BLSK <- as.integer(d$BLSK)



##### ----- Wide to long format 

# Need to double check with Brent - these numbers are breeding pair?
long <- pivot_longer(d, names_to = "Species", values_to = "Pairs", cols = c(16:47))



##### ----- Add full species name

# rename column for species code
long <- long %>% rename(SpeciesCode = Species)

# ROTE TO ROYT (I looked in Brent's original data to make sure this is royal and not roseate) 
long <- within(long, SpeciesCode[SpeciesCode == 'ROTE' ] <- "ROYT")

# FORTE to FOTE
long <- within(long, SpeciesCode[SpeciesCode == 'FORTE' ] <- "FOTE")

# Bring in species codes
spp <- read.csv("./data_original/Texas/species_codes.csv")

# join spp codes to data
long<- left_join(long, spp, by = "SpeciesCode")

# drop rows where pair == NA
no_na<- long %>% filter(!if_all(c("Pairs"), is.na))

rm(long, d, spp)

# drop some columns 
no_na <- subset(no_na, select = -c(SpeciesCode, ZONE, Lat_old, Long_old, Time, Observer, Assistants))

# add column for state
no_na$State <- "Texas"

# dd column for data provider
no_na$DataProvider <- "Texas Colonial Waterbird Society"
no_na$DateReceived <- "2022-09-19"

# rename some columns
no_na <- no_na %>% rename(ColonyName = Colony.Name, ColonyCode = Colony.Code, 
                          Species = SpeciesName)

# add Identified_to_species column
# make Species a factor
no_na$Species <- as.factor(no_na$Species)
# look at species
levels(no_na$Species)
# all are identified to species, so make a column thats all yes
no_na$Identified_to_species <- "yes"


##### ----- edits to Survey.Type
# rename column
no_na <- no_na %>% rename(SurveyVantagePoint = Survey.Type)

no_na$SurveyVantagePoint <- as.character(no_na$SurveyVantagePoint )
no_na<- within(no_na, SurveyVantagePoint[SurveyVantagePoint == 'on-site'] <- 'On-site visit')
no_na<- within(no_na, SurveyVantagePoint[SurveyVantagePoint == 'adjacent'] <- 'Adjacent')
no_na<- within(no_na, SurveyVantagePoint[SurveyVantagePoint == 'drone'] <- 'Drone')
no_na<- within(no_na, SurveyVantagePoint[SurveyVantagePoint == 'flight line'] <- 'Flight line')

no_na$SurveyVantagePoint <- as.factor(no_na$SurveyVantagePoint )
levels(no_na$SurveyVantagePoint)

# change the name for easier coding
d<- no_na # 3000 rows
rm(no_na)



#### Checking for duplicates ####

duplicates <-
  d %>%
  select(Year, ColonyName, Species, Pairs) %>%
  group_by(Year, ColonyName, Species) %>%
  summarise(n = n())

duplicates<- filter(duplicates, n>1)



##### ----- Working through duplicates

# chaney #106 - seems this site was visited 2x in 2018
# Remove the 2nd visit, which had lesser counts over overlapping spp and fewer spp 
d <- d %>%  # 2998 rows
  filter(!(ColonyName== "chaney #106" & Year == "2018" & Date == "5/29/2018"))



##### ----- Add subcolony letter to ColonyName for rows that have subcolony letter

# Some duplicates are false:
# the subcolony letter is not in colonyname or colonycode columns
# but in a separate standalone column

# Add subcolony letter to ColonyCode for rows that have subcolony letter
d$ColonyCode <- ifelse( !is.na(d$Subcolony.Letter) , paste(d$ColonyCode, d$Subcolony.Letter, sep=""), d$ColonyCode) 

# pull out only rows with subcolony
subco <- d %>%
  filter(!is.na(d$Subcolony.Letter))

# remove these from full dataset
d <- setdiff(d, subco)  # d is now the part of the dataset that does not have subcolony info 

# from subcolonies, pull out rows that already have subcolony letter in their colony name 
x <- subco %>% 
  filter(str_detect(ColonyName, "-"))

# remove rows that already have subcolony letter in their colony name from total subcolony set
subco <- setdiff(subco, x) 

# from x, pull out ones that have a dash not related to subcolony and move them back to subco
not_these <-   x %>% 
  filter(ColonyName == "chaney #43 Marker 63-131" | ColonyName == "chaney #44 Marker 63-65")

x <- setdiff(x, not_these)  # 380
subco <- rbind(subco, not_these) #1609


##### ----- Create a function to capitalize the last letter
mycap <- function(mystr = "") {
  # a: the string without the last character
  a <- substr(mystr, 1, nchar(mystr)-1)
  # b: only the last character 
  b <- substr(mystr, nchar(mystr), nchar(mystr))
  # lower(a) and upper(b)
  paste(a, toupper(b), sep = "")
}

# now run the function to capitalize 
x$ColonyName <- mycap(x$ColonyName)

# done making modifications to x, add it back to the full dataset d
d<- rbind(d,x )
#remove x
rm(x)

# now work with the rows with subcolonies that do not have their letter in their name. 
# add letter to colonyname with " - " in between
subco$ColonyName <- paste(subco$ColonyName, subco$Subcolony.Letter, sep=" - ")

# capitalize last letter
subco$ColonyName <- mycap(subco$ColonyName)

# add subcolonies back yo full data set
d <- rbind(d , subco)
rm(not_these, subco)



##### ----- A few weird subcolonies that will need individual correction: 

# West Nueces Bay - bcfilo
d <- within(d, ColonyName[ColonyName == 'West Nueces Bay - bcfilO'] <- 'West Nueces Bay - bcfilo')

# Crane Island A, B, D
d <- within(d, ColonyName[ColonyName == 'Crane Island A - A'] <- 'Crane Islands - A')
d <- within(d, ColonyName[ColonyName == 'Crane Island B - B'] <- 'Crane Islands - B')
d <- within(d, ColonyName[ColonyName == 'Crane Island C - C'] <- 'Crane Islands - C')
d <- within(d, ColonyName[ColonyName == 'Crane Island D - D'] <- 'Crane Islands - D')

# Laguna Shores - ff
d <- within(d, ColonyName[ColonyName == 'Laguna Shores - fF'] <- 'Laguna Shores - FF')

# E. Nueces Bay - bg
d <- within(d, ColonyName[ColonyName == 'E. Nueces Bay - bG'] <- 'East Nueces Bay - B')
d <- within(d, Latitude[ColonyName  == 'East Nueces Bay - B'] <- 27.856711990)
d <- within(d, Longitude[ColonyName  == 'East Nueces Bay - B'] <- -97.360939550)

# New chaney #105 - ee
d <- within(d, ColonyName[ColonyName == 'New chaney #105 - eE'] <- 'New chaney #105 - EE')

# West Nueces Bay 51 (E) e
d <- within(d, ColonyName[ColonyName == 'West Nueces Bay 51 (E) e - E'] <- 'West Nueces Bay 51 E - E')


##### ----- Check again for duplicates

duplicates <-  d %>%
  select(Year, ColonyName, Species, Pairs) %>%
  group_by(Year, ColonyName, Species) %>%
  summarise(n = n())

duplicates<- filter(duplicates, n>1)

# Yay! no more duplicates
rm(duplicates, mycap)



##### Correct colony names that don't match other spreadsheets ####

m <- d %>%
  select( ColonyCode, ColonyName) %>%
  group_by( ColonyCode, ColonyName) %>%
  summarise(n = n())

#  Second Chain of Islands-H (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'Second Chain of Islands - H' & ColonyCode == "609422h" ] <- 'Second Chain of Islands-H')
d <- within(d, ColonyName[ColonyName == 'Third Chain of Islands - A' & ColonyCode == "609424a" ] <- 'Third Chain of Islands-A')

# Seadrift  (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'Seadrift - B' ] <- 'Seadrift Island-B')
d <- within(d, ColonyName[ColonyName == 'Seadrift - A' ] <- 'Seadrift Island-A')

# Little Bay (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'Little Bay n - B' ] <- 'Little Bay - B')

# Chaney Island (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'chaney Island' ] <- 'Chaney Island')
d <- within(d, Latitude[ColonyCode == '614365'] <- 	27.3582300000)
d <- within(d, Longitude[ColonyCode == '614365'] <- 	-97.3869300000)

# CC Channel Spoil (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'CC Channel Spoil West - A' ] <- 'CC Channel Spoil - A')
d <- within(d, ColonyName[ColonyName == 'CC Channel Spoil East - B' ] <- 'CC Channel Spoil - B')

# South Pass(name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'South Pass B' ] <- 'South Pass Island B')
d <- within(d, ColonyName[ColonyName == 'South Pass A' ] <- 'South Pass Island A')

d <- within(d, Latitude[ColonyName  == 'South Pass Island A'] <- 28.2983000000)
d <- within(d, Longitude[ColonyName  == 'South Pass Island A'] <- -96.6224000000)
d <- within(d, Latitude[ColonyName  == 'South Pass Island B'] <- 28.2962000000)
d <- within(d, Longitude[ColonyName  == 'South Pass Island B'] <- -96.6214000000)

# Cedar Lake (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'Cedar Lake' ] <- 'Cedar Lake Island')
d <- within(d, Latitude[ColonyCode == '609441'] <- 	28.23166667)
d <- within(d, Longitude[ColonyCode == '609441'] <- -96.66444444)

# Rattlesnake Point (name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'Rattlesnake Point 3 islands' ] <- 'Copano Rattlesnake Point')
d <- within(d, Latitude[ColonyCode == '609461'] <- 28.05694444)
d <- within(d, Longitude[ColonyCode == '609461'] <- -97.13222222)

# Rockport Woods - has 2 names and 2 codes
d <- within(d, ColonyName[ColonyName == 'Rockport Woods - C' ] <- 'Rockport Woods')
d <- within(d, ColonyCode[ColonyName == 'Rockport Woods' ] <- '609487')
d <- within(d, Subcolony.Letter[ColonyName == 'Rockport Woods' ] <- NA)

#Little Bay/cove and beach - A(name doesnt match other spreadsheets)
d <- within(d, ColonyName[ColonyName == 'Little Bay/cove and beach - A' ] <- 'Little Bay - A')
d <- within(d, Latitude[ColonyName  == 'Little Bay - A'] <- 28.03312319)
d <- within(d, Longitude[ColonyName  == 'Little Bay - A'] <- -97.03521304)
d <- within(d, Latitude[ColonyName  == 'Little Bay - B'] <- 28.03128466)
d <- within(d, Longitude[ColonyName  == 'Little Bay - B'] <- -97.04267074)

# Saint Charles Mouth - BlackJack Point Reef
d <- within(d, ColonyName[ColonyName == 'Saint Charles Mouth' ] <- 'BlackJack Point Reef')
d <- within(d, Latitude[ColonyName  == 'BlackJack Point Reef'] <- 28.12277778)
d <- within(d, Longitude[ColonyName  == 'BlackJack Point Reef'] <- -96.96694444)

# Crane Island 
d <- within(d, Latitude[ColonyName  == 'Crane Islands - A'] <- 27.65224722)
d <- within(d, Longitude[ColonyName  == 'Crane Islands - A'] <- -97.21110556)

d <- within(d, Latitude[ColonyName  == 'Crane Islands - B'] <- 27.65272222)
d <- within(d, Longitude[ColonyName  == 'Crane Islands - B'] <- -97.21026111)

d <- within(d, Latitude[ColonyName  == 'Crane Islands - C'] <- 27.66425000)
d <- within(d, Longitude[ColonyName  == 'Crane Islands - C'] <- -97.21016944)

d <- within(d, Latitude[ColonyName  == 'Crane Islands - D'] <- 27.66865000)
d <- within(d, Longitude[ColonyName  == 'Crane Islands - D'] <- -97.21054444)

# Corey Cove
d <- within(d, Latitude[ColonyName  == 'Corey Cove'] <- 28.2690961000)
d <- within(d, Longitude[ColonyName  == 'Corey Cove'] <- -96.6302278600)

# 614363 chaney #36
d <- within(d, Latitude[ColonyName  == 'chaney #36'] <- 27.3672222200)
d <- within(d, Longitude[ColonyName  == 'chaney #36'] <- -97.38305556)

# Chester (Sundown) Island
d <- within(d, Latitude[ColonyName  == 'Chester (Sundown) Island'] <- 28.4527777800)
d <- within(d, Longitude[ColonyName  == 'Chester (Sundown) Island'] <- -96.3458333300)

# Panther Reef
d <- within(d, Latitude[ColonyName  == 'Panther Reef'] <- 28.2188888900)
d <- within(d, Longitude[ColonyName  == 'Panther Reef'] <- -96.7050000000)

# Shamrock Island
d <- within(d, Latitude[ColonyName  == 'Shamrock Island'] <- 27.7600000000)
d <- within(d, Longitude[ColonyName  == 'Shamrock Island'] <- -97.1688888900)

# Naval Air Station Islands - C
d <- within(d, Latitude[ColonyName  == 'Naval Air Station Islands - C'] <- 27.6756330000)
d <- within(d, Longitude[ColonyName  == 'Naval Air Station Islands - C'] <- -97.2538860000)

# Seadrift Island-B
d <- within(d, Latitude[ColonyName  == 'Seadrift Island-B'] <- 	28.39674587)
d <- within(d, Longitude[ColonyName  == 'Seadrift Island-B'] <- -96.7229727800)

# South Baffin Bay Island - C
d <- within(d, Latitude[ColonyName  == 'South Baffin Bay Island - C'] <- 	27.25038500)
d <- within(d, Longitude[ColonyName  == 'South Baffin Bay Island - C'] <- -97.40841500)

# Marker 139-155 Spoil  (19-35) - A
d <- within(d, Latitude[ColonyName  == 'Marker 139-155 Spoil  (19-35) - A'] <- 	27.22158900)
d <- within(d, Longitude[ColonyName  == 'Marker 139-155 Spoil  (19-35) - A'] <- -97.41971100)

# Marker 139-155 Spoil  (19-35) - G
d <- within(d, Latitude[ColonyName  == 'Marker 139-155 Spoil  (19-35) - G'] <- 	27.23090200)
d <- within(d, Longitude[ColonyName  == 'Marker 139-155 Spoil  (19-35) - G'] <- -97.41722500)

# Marker 85 A Spoil Island (NM 165)
d <- within(d, Latitude[ColonyName  == 'Marker 85 A Spoil Island (NM 165)'] <- 	27.3797222200)
d <- within(d, Longitude[ColonyName  == 'Marker 85 A Spoil Island (NM 165)'] <- -97.368888890)

# South Baffin Bay Island - A
d <- within(d, Latitude[ColonyName  == 'South Baffin Bay Island - A'] <- 	27.24695200)
d <- within(d, Longitude[ColonyName  == 'South Baffin Bay Island - A'] <- -97.4140160)

# E. Nueces Bay - I
d <- within(d, ColonyName[ColonyName == 'E. Nueces Bay - I' ] <- 'East Nueces Bay - I')

# E. Nueces Bay Causeway Island - A
d <- within(d, ColonyName[ColonyName == 'E. Nueces Bay Causeway Island - A' ] <- 'East Nueces Bay Causeway Island - A')

# remove 1 row with no coordinates: Infrastructure Is. (2022; 42 LAGU pairs)
d <- d[!is.na(d$Longitude),]


d$SpCountMethod <- "Maximum reported count"


##### ----- Save to cleaned data folder for later merging
write.csv(d, "./data_cleaned/Texas_central_coast.csv")


############################################################################################
#################################### END ###################################################
############################################################################################