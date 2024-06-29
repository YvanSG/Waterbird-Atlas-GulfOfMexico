############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

# Scripts used for various summaries needed throughout the data wrangling process 

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

library(plyr)
library(tidyverse)
library(data.table)
library(dplyr)

# #### ----- Create unique list of site locations to measure distance in arcpro -----
latlong<- select(d, "ColonyName", "DataProvider", "State", "Latitude", "Longitude")
latlong <- unique(latlong)
write.csv(latlong, "./output/unique_sites.csv")

# ### Summary of nests vs pairs vs etc. by species
# #### ----- Summarize number of rows per spp ------
metric_summary <-
d %>%
  group_by(Identified_to_species, Species) %>%
  summarise(Observations = n(),
            Pairs = sum(!is.na(Pairs)),
            #Breeding.pairs = sum(!is.na(Breeding.pairs)),
            Nests = sum(!is.na(Nests)),
            Adults = sum(!is.na(Adults)),
            Birds = sum(!is.na(Birds)),
            Chicks = sum(!is.na(Chicks)),
            Fledglings = sum(!is.na(Fledglings)),
            "All_birds(adults & juvs)" = sum(!is.na(All.birds_ad_juv)),
            Unknown_metric = sum(!is.na(Unknown.metric)))

# write.csv(metric_summary, "/data_output/atlas_metric_summary.csv")
#
#
#
#### ----- Summary of nests vs pairs vs etc. by data provider ------
data_provider_summary <-
  d %>%
  group_by(DataProvider) %>%
  summarise(Observations = n(),
            Pairs = sum(!is.na(Pairs)),
            #Breeding.pairs = sum(!is.na(Breeding.pairs)),
            Nests = sum(!is.na(Nests)),
            Adults = sum(!is.na(Adults)),
            Birds = sum(!is.na(Birds)),
            Chicks = sum(!is.na(Chicks)),
            Fledglings = sum(!is.na(Fledglings)),
            "All_birds(adsjuvs)" = sum(!is.na(All.birds_ad_juv)))


write.csv(data_provider_summary , 
          paste0(getwd(),"/data_output/data_provider_summary.csv"))

#### ----- Summary of nests vs pairs vs etc. by year ------
 year_summary <-
   d %>%
   group_by(Year, DataProvider) %>%
   summarise(Observations = n())

 year_summary  <- pivot_wider(year_summary, names_from= "Year", values_from = "Observations")

 year_summary [is.na(year_summary )] <- 0

 # write.csv(year_summary , "/data_output/z_combine_all_data/year_summary.csv")




#### ----- Summaries of rows with nests and pairs ------

 # Nests or pairs
 nests_or_pairs<-
   d %>%
   filter(!is.na(Nests) | !is.na(Pairs))

 nests_or_pairs  <-
 nests_or_pairs %>%
   group_by(DataProvider) %>%
   summarise( Observations = n(),
              Pairs = sum(!is.na(Pairs)),
              Nests = sum(!is.na(Nests) ))



 # Nests AND pairs
 nests_pairs_together_all <-
   d %>%
   filter(!is.na(Nests) & !is.na(Pairs))

 nests_pairs_together_summary <-
 nests_pairs_together_all %>%
 group_by(DataProvider) %>%
   summarise( Observations = n())

# Look at of those lines w nests and pair, how many are the same
 # help here: https://www.statology.org/r-check-if-multiple-columns-are-equal/
 nests_pairs_together_all_temp <-
 nests_pairs_together_all %>%
   select('Pairs', 'Nests' ) %>%
   rowwise %>%
   mutate(match = n_distinct(unlist(cur_data())) == 1) %>%
   ungroup()

 nests_pairs_together_all$match <- nests_pairs_together_all_temp$match

 # change true/false to 1/0
 #nests_pairs_together_all$match <- as.numeric(nests_pairs_together_all$match)

 # sum(nests_pairs_together_all$match)
 # 3712

 # now to calculate percent difference
 # pull out only false rows (rows where nest and pairs are not equal)
not_matched <-
  nests_pairs_together_all  %>%
   filter(match == FALSE)

# pull out rows w range from Pairs
range<-
not_matched  %>%
  filter(str_detect(Pairs, "-"))

# pull out rows w range from Nests
range2<-
  not_matched  %>%
  filter(str_detect(Nests, "-"))

# combine those 2
r <- rbind(range, range2)
rm(range, range2)

# remove rows w range from not_matched data frame
not_matched <- setdiff(not_matched, r)

# Pat sat to used mid the midpoint for the range
# drop nests and rows column from r
r <- select(r, -c(Pairs, Nests))

# calculate midpoint then substitute
r$Pairs <- c((13+15)/2,
              (66+86)/2,
              (32+48)/2,
              500,
              330)

r$Nests <- c(15, 86, 48,
              (520+580)/2,
              (128+307)/2)

# # add r back to not_matched
nm <- rbind(not_matched, r)
rm(r, not_matched)

# name nests and pairs numeric
nm$Nests <- as.numeric(nm$Nests)
nm$Pairs <- as.numeric(nm$Pairs)

# calculate percent_difference  ##whether Pair or Nest comes first, it doesn't make
nm$percent_difference <- abs(((nm$Nests - nm$Pairs)/((nm$Nests + nm$Pairs)/2)*100))

nm<-
nm %>% relocate(percent_difference, .before = Adults)

# pull out rows where nest and row do not equal zero
no_zeros <-
nm %>% filter(Nests > 0 & Pairs > 0)

#what is the mean percent difference?  40.25209
mean(no_zeros$percent_difference)

# how many rows have zero value for nest? 1873
# nests <-
#   nm %>% filter(Nests == 0 )

# how many rows have zero value for pair? 39
# pairs <-
#   nm %>% filter(Pairs == 0 )


#### ----- Look at number of species per site per year------

duplicate_species <-
  d %>%
  select(DataProvider, Year, ColonyName, Species, Pairs) %>%
  group_by(Year, DataProvider, ColonyName, Species) %>%
  summarise(Observations = n())

#### ----- Look at colony duplicates ------
  duplicates <-
    d %>%
    select(File, Year, ColonyName, Species, Pairs) %>%
    group_by(File, Year, ColonyName, Species) %>%
    summarise(n = n())

  duplicates<- filter(duplicates, n>1)

  # 8/16/23: 1780 duplicates
  # 8/21/23: 1756 duplicates

#### ----- How many colonies w no names ------
blank <- filter(d, ColonyName == "" | ColonyName == " ")

blank$AtlasNo <- as.factor(blank$AtlasNo)

blank %>%
      group_by(AtlasNo) %>%
      summarise(n = n())


### ----- Distribution of Gulfwide TIG data distance to nearest non-TIG site (LA not included) -----
TIG <- read.csv("./output/Gulfwide_TIG_noLA_2023_11.csv")

ggplot(TIG, aes(x=NEAR_DIST)) +
  geom_histogram( bins = 100)

### ------ Change column names to match AKN Atlantic Flyway Colonial Waterbird Core Fields -----
d <- d %>% rename(Old_Name = New_Name)
d <- d %>% rename(CountMethod = SpCountMethod)


############################################################################################
#################################### END ###################################################
############################################################################################