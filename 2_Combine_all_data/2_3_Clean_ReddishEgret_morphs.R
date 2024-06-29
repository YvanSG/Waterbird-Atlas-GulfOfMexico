############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

## 3_Clean_ReddishEgret_morphs.R
## Summarize and clean up Reddish Egret morph

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

# packages
# library(plyr)
# library(tidyverse)
# library(data.table)

# Use dataframe "d" created in "./R/Atlas/2_Combine_all_data/1_Combine_all_data.R"



##### Create a summary ####
# # to aid in deciding what to do about REEG morphs from TCWS
# # NESTS
# reeg_nests <- 
# d %>%
#       filter(Species == "Reddish Egret" | Species == "Reddish Egret White Morph" | Species == "Reddish Egret Dark Morph") %>%
#       filter(DataProvider == "Texas Colonial Waterbird Society") %>%
#       select(Year, ColonyName, DataProvider, Species, Nests)
# reeg_nests  <- na.omit(reeg_nests )
# 
# # reshape long to wide
# reeg_nests <- 
#   reeg_nests %>%
# pivot_wider(names_from = Species, values_from = Nests)
# 
# # convert to numeric
# reeg_nests$'Reddish Egret' <-  as.numeric(reeg_nests$'Reddish Egret')
# reeg_nests$'Reddish Egret Dark Morph' <-  as.numeric(reeg_nests$'Reddish Egret Dark Morph')
# reeg_nests$'Reddish Egret White Morph' <-  as.numeric(reeg_nests$'Reddish Egret White Morph')
# 
# # make Reddish Egret negative for summing in next step
# reeg_nests$'Reddish Egret' <-  -1*reeg_nests$'Reddish Egret' 
# 
# # Add all the egrets together
# reeg_nests <- 
#  reeg_nests %>%
#   mutate(sum = rowSums(across(c('Reddish Egret Dark Morph', 'Reddish Egret White Morph', 'Reddish Egret')), na.rm=TRUE))
# 
# # remove rows where reddish egret is NA
# reeg_nests <- reeg_nests %>% filter((!is.na(reeg_nests$'Reddish Egret'))) #66
# 
# # remove rows where dark morph and white morph are NA
# reeg_nests <- reeg_nests   %>% filter(!( is.na(reeg_nests$'Reddish Egret Dark Morph') & is.na(reeg_nests$'Reddish Egret White Morph'))) #18
#  
# # 181 rows remain. All but one sum to 0. The One observation that doesn't sum to zero has 12 dark, 6 white, and 0 reddish egrets, so I'm guessing they didn't sum there. For all of the others rows, reddish egret is the sum of the morphs - I suppose reddish egret should be changed to 0.
# 
# 
# # PAIRS
# reeg_pairs <- 
#   d %>%
#   filter(Species == "Reddish Egret" | Species == "Reddish Egret White Morph" | Species == "Reddish Egret Dark Morph") %>%
#   filter(DataProvider == "Texas Colonial Waterbird Society") %>%
#   select(Year, ColonyName, DataProvider, Species, Pairs)
# reeg_pairs  <- na.omit(reeg_pairs)
# 
# # reshape long to wide
# reeg_pairs <- 
#   reeg_pairs %>%
#   pivot_wider(names_from = Species, values_from = Pairs)
# 
# # convert to numeric
# reeg_pairs$'Reddish Egret' <-  as.numeric(reeg_pairs$'Reddish Egret')
# reeg_pairs$'Reddish Egret Dark Morph' <-  as.numeric(reeg_pairs$'Reddish Egret Dark Morph')
# reeg_pairs$'Reddish Egret White Morph' <-  as.numeric(reeg_pairs$'Reddish Egret White Morph')
# 
# # make Reddish Egret negative for summing in next step
# reeg_pairs$'Reddish Egret' <-  -1*reeg_pairs$'Reddish Egret' 
# 
# # Add all the egrets togeether
# reeg_pairs <- 
#   reeg_pairs %>%
#   mutate(sum = rowSums(across(c('Reddish Egret Dark Morph', 'Reddish Egret White Morph', 'Reddish Egret')), na.rm=TRUE))
# 
# # remove rows where reddish egret is NA
# reeg_pairs <- reeg_pairs %>% filter((!is.na(reeg_pairs$'Reddish Egret'))) #98
# 
# # remove rows where dark morph and white morph are NA
# reeg_pairs <- reeg_pairs   %>% filter(!( is.na(reeg_pairs$'Reddish Egret Dark Morph') & is.na(reeg_pairs$'Reddish Egret White Morph'))) #92
# # End TCWS REEG summaries



#### Clean up Reddish Egret morph data ####

# Pull out only the reddish egrets and morphs from TCWS (1078)
reeg <- d %>%
  filter(Species == "Reddish Egret" | Species == "Reddish Egret White Morph" | Species == "Reddish Egret Dark Morph") %>%
  filter(DataProvider == "Texas Colonial Waterbird Society")

# remove these reeg from d (full data frame)
d <- setdiff(d, reeg)

# change data types
reeg$Species <- as.character(reeg$Species)

# drop columns - these all have NA or all the same entry and can be easily added back in later
# this makes it easier to look at the dataset
reeg  <- subset(reeg , 
                select = -c(Birds, Fledglings, Chicks, All.birds_ad_juv, AtlasNo, 
                            SpCountMethod, Identified_to_species, 
                            DataContact1, DataContact2, DataContactEmail1, DataContactEmail2,
                            DataContactAffiliation1, DataContactAffiliation2, 
                            State, DataProvider)) 

# pivot table wider so there's one entry per year per colony
reeg <- pivot_wider(reeg, names_from = Species, 
                    values_from = c(Pairs, Nests, Adults, OriginalPairs, OriginalNests))

# split into pairs and nests to resolve problems. Will recombine at the end. 
preeg <- reeg
nreeg <- reeg
areeg <- reeg

# drop pairs and adults from nests. adults and nests from pairs. pairs and nests from adults
preeg  <- subset(reeg , select = -c(`Nests_Reddish Egret White Morph` , `Nests_Reddish Egret Dark Morph` , `Nests_Reddish Egret`
                                    ,`Adults_Reddish Egret White Morph` , `Adults_Reddish Egret Dark Morph` , `Adults_Reddish Egret`) ) 
nreeg  <- subset(reeg , select = -c(`Pairs_Reddish Egret White Morph` ,`Pairs_Reddish Egret Dark Morph` , `Pairs_Reddish Egret`
                                    ,`Adults_Reddish Egret White Morph` , `Adults_Reddish Egret Dark Morph` , `Adults_Reddish Egret`) ) 
areeg<- subset(reeg , select = -c(`Pairs_Reddish Egret White Morph` ,`Pairs_Reddish Egret Dark Morph` , `Pairs_Reddish Egret`,
                                  `Nests_Reddish Egret White Morph` , `Nests_Reddish Egret Dark Morph` , `Nests_Reddish Egret`) ) 


## Nests
# first fix outlier that needs to be addressed directly (see meeting notes for details) (1)
nreeg <- within(nreeg, `Nests_Reddish Egret`[ColonyName == 'Green Island Spoils - D' & 
                                               Year == 2015 ] <- 18 )

# which rows already have NA for both morphs (271)
nreeg_done <- nreeg  %>%
  filter(is.na(nreeg$`Nests_Reddish Egret Dark Morph`) & 
           is.na(nreeg$`Nests_Reddish Egret White Morph`))

# drop these rows from nreeg
nreeg <- setdiff( nreeg, nreeg_done)

# which rows are sum of morphs to reeg?
# sum the morphs
nreeg <- dplyr::mutate(nreeg, sum = rowSums(across(c('Nests_Reddish Egret Dark Morph', 'Nests_Reddish Egret White Morph')), na.rm=TRUE))

#move columns for easier viewing
nreeg <-nreeg%>% relocate(c('Nests_Reddish Egret','Nests_Reddish Egret Dark Morph', 'Nests_Reddish Egret White Morph'), .after=sum)

# put true in new column equal if sum and 'Nests_Reddish Egret' are equal
nreeg <- mutate(nreeg, equal = if_else(nreeg$sum == nreeg$'Nests_Reddish Egret', "TRUE", "FALSE"))

# pull out true (181)
t <-  nreeg  %>% filter(nreeg$equal == TRUE)

# drop these rows from nreeg
nreeg <- setdiff( nreeg, t)

# remove columns that were added
t <- subset(t, select = -c(equal, sum) ) 

# add to the done rows
nreeg_done <- rbind(nreeg_done, t)
rm(t)

# in the rows left in nreeg, reddish egret is NA so the sum  of the morphs should replace the NA
# drop columns
nreeg <- nreeg %>% subset(select = -c(`Nests_Reddish Egret`, equal  ) ) # equal

# rename sum to reddish egret 
nreeg <- nreeg %>% dplyr::rename(`Nests_Reddish Egret` = sum)

# add all the rows together and nests are done
nreeg_done <- rbind(nreeg, nreeg_done)
rm(nreeg)


## Pairs
#fix outliers that needs to be addressed directly (8)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'South Pass Island A' & Year ==  2010] <-  1)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Cedar Lakes' & Year ==  2012] <-  6)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Green Island Spoils - D' & Year == 2015 ] <-  12)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Green Hill Spoil Island - B' & Year ==  2015] <-  6)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Laguna Vista Spoil - A' & Year ==  2010] <-  6)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Second Chain of Islands-J' & Year ==  2013] <- 10 )
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Second Chain of Islands-K' & Year == 2013 ] <-  3)
preeg <- within(preeg, `Pairs_Reddish Egret`[ColonyName == 'Second Chain of Islands-G' & Year ==  2020] <-  8)

# which rows already have NA for both morphs (92)
preeg_done <- preeg  %>%
  filter(is.na(preeg$`Pairs_Reddish Egret Dark Morph`) & is.na(preeg$`Pairs_Reddish Egret White Morph`))

# drop these rows from preeg
preeg <- setdiff( preeg, preeg_done)

# which rows are sum of morphs to reeg?
# sum the morphs
preeg <-  dplyr::mutate(preeg, sum = rowSums(across(c('Pairs_Reddish Egret Dark Morph', 'Pairs_Reddish Egret White Morph')), na.rm=TRUE))

#move columns for easier viewing
preeg <-preeg%>% relocate(c('Pairs_Reddish Egret','Pairs_Reddish Egret Dark Morph', 'Pairs_Reddish Egret White Morph'), .after=sum)

# put true in new column equal if sum and 'Pairs_Reddish Egret' are equal
preeg <- mutate(preeg, equal = if_else(preeg$sum == preeg$'Pairs_Reddish Egret', "TRUE", "FALSE"))

# pull out true and false
t <-  preeg  %>% filter(preeg$equal == TRUE | preeg$equal == FALSE)

# drop these rows from preeg
preeg <- setdiff( preeg, t)

# remove columns that were added
t <- subset(t, select = -c(equal, sum) ) 

# add to the done rows
preeg_done <- rbind(preeg_done, t)
rm(t)

# in the rows left in preeg, reddish egret is NA so the sum  of the morphs should replace the NA
# drop columns
preeg <- preeg %>% subset(select = -c(`Pairs_Reddish Egret`, equal  ) ) # equal

# rename sum to reddish egret 
preeg <- preeg %>% dplyr::rename(`Pairs_Reddish Egret` = sum)

# add all the rwos together and nests are done
preeg_done <- rbind(preeg, preeg_done)
rm(preeg)


## Adults

# which rows already have NA for both morphs
areeg_done <- areeg  %>%
  filter(is.na(areeg$`Adults_Reddish Egret Dark Morph`) & is.na(areeg$`Adults_Reddish Egret White Morph`))

# drop these rows from areeg
areeg <- setdiff( areeg, areeg_done)

# which rows are sum of morphs to reeg?
# sum the morphs
areeg <-  dplyr::mutate(areeg, sum = rowSums(across(c('Adults_Reddish Egret Dark Morph', 'Adults_Reddish Egret White Morph')), na.rm=TRUE))

#move columns for easier viewing
areeg <-areeg%>% relocate(c('Adults_Reddish Egret','Adults_Reddish Egret Dark Morph', 'Adults_Reddish Egret White Morph'), .after=sum)

# put true in new column equal if sum and 'Adults_Reddish Egret' are equal
areeg <- mutate(areeg, equal = if_else(areeg$sum == areeg$'Adults_Reddish Egret', "TRUE", "FALSE"))


# pull out true (95)
t <-  areeg  %>% filter(areeg$equal == TRUE)

# drop these rows from preeg
areeg <- setdiff( areeg, t)

# remove columns that were added
t <- subset(t, select = -c(equal, sum) ) 

# add to the done rows
areeg_done <- rbind(areeg_done, t)
rm(t)


# in the rows left in areeg, reddish egret is NA so the sum  of the morphs should replace the NA
# drop columns
areeg <- areeg %>% subset(select = -c(`Adults_Reddish Egret`, equal  ) ) # equal

# rename sum to reddish egret 
areeg <- areeg %>% dplyr::rename(`Adults_Reddish Egret` = sum)

# add all the rows together and adults are done
areeg_done <- rbind(areeg, areeg_done)
rm(areeg)


# join the nest and pair dataframes back together
join <- c("ColonyName", "ColonyCode", "Year", "Latitude", "Longitude", "File", 
          "SurveyVantagePoint", "Notes", "Date", "Subcolony", "Status", 
          'OriginalPairs_Reddish Egret','OriginalPairs_Reddish Egret Dark Morph', 
          'OriginalPairs_Reddish Egret White Morph', 'OriginalNests_Reddish Egret',
          'OriginalNests_Reddish Egret Dark Morph', 'OriginalNests_Reddish Egret White Morph', 
          'OriginalAdults')

reeg_new <- inner_join(preeg_done , nreeg_done , 
                       by=join)

reeg_new <- inner_join(reeg_new , areeg_done , 
                       by=join)

# remove separate dataframes
rm(nreeg_done, preeg_done, areeg_done)

# remove columns with morphs
reeg_new <- reeg_new %>% 
  subset(select = -c(`Adults_Reddish Egret Dark Morph`, `Adults_Reddish Egret White Morph`,
                     `OriginalPairs_Reddish Egret Dark Morph`, 
                     `OriginalPairs_Reddish Egret White Morph`, 
                     `OriginalNests_Reddish Egret Dark Morph`, 
                     `OriginalNests_Reddish Egret White Morph`, 
                     `Pairs_Reddish Egret Dark Morph`, `Pairs_Reddish Egret White Morph`,
                     `Nests_Reddish Egret Dark Morph`, `Nests_Reddish Egret White Morph`) )

# rename columns
reeg_new <- reeg_new %>% dplyr::rename(Nests = `Nests_Reddish Egret`,
                                       Pairs = `Pairs_Reddish Egret`,
                                       Adults = `Adults_Reddish Egret`,
                                       OriginalPairs = `OriginalPairs_Reddish Egret`,
                                       OriginalNests = `OriginalNests_Reddish Egret`)

# add columns removed earlier back on
reeg_new$Species <- "Reddish Egret"
reeg_new$Birds <- NA
reeg_new$Fledglings <- NA
reeg_new$Chicks <- NA
reeg_new$All.birds_ad_juv <- NA
reeg_new$AtlasNo <- NA
reeg_new$SpCountMethod <- NA
reeg_new$Identified_to_species <- "yes"
reeg_new$DataContact1 <- "David Essian"
reeg_new$DataContact2 <- NA
reeg_new$DataContactEmail1 <- "david.essian@tamucc.edu"
reeg_new$DataContactEmail2 <- NA
reeg_new$DataContactAffiliation1 <- "Harte Research Institute"
reeg_new$DataContactAffiliation2 <- NA
reeg_new$State <- "Texas" 
reeg_new$DataProvider <- "Texas Colonial Waterbird Society"

# some columns were duplicated during the join
reeg_new<-select(reeg_new, -c(DateReceived.x, DateReceived.y))
reeg_new<-select(reeg_new, -c(HasAtlasMetric.x, HasAtlasMetric.y))
reeg_new<-select(reeg_new, -c(AtlasSiteCode.x, AtlasSiteCode.y))
reeg_new<-select(reeg_new, -c(ProviderColonyName.x, ProviderColonyName.y))
reeg_new<-select(reeg_new, -c(index.x, index.y))


# add TCWS REEGs back to full dataset d
d <-rbind(d, reeg_new)
rm(reeg, reeg_new)

# drop the empty levels
d$Species <- droplevels(d$Species)

KEEP<-d

print("###################### Reddish Egret morphs integrated into dataset ##########################")

############################################################################################
#################################### END ###################################################
############################################################################################