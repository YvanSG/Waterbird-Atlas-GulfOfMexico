############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

## 4_Fix_Double_counts.R
## Double count problem 

# Some of these problems are because there are rows w presence/absence in SpCountMethod and 1/0 for metric. 
# 2016 seems to be the big year for this problem. Presence/Absence rows are dropped below. 
# There are then other rows that have actual counts. 
# Some of these is that each metric of multiple metrics is in its own row.
# I think this is a result of different groups counting different metrics 
# and/or different SpCountMethod or SurveyVantagePoint. 
# Metrics are combined into a single row below. 
# For others, it is likely the site was visited 2+ times in a year. 
# For these, I took the max count as was done in the FL Seabird database.
# This only impacted a few rows.

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

# library(plyr)
# library(tidyverse)
# library(data.table)

# Use dataframe "d" created in "./R/Atlas/2_Combine_all_data/1_Combine_all_data.R"

#### ---- Remove rows with no Atlas metric values
# keep them for later
keep.nometric <-d[d$HasAtlasMetric == "N",]

d <- setdiff(d, keep.nometric)

#### ---- Keep aside additional information not necessary to clean-up double-counts

keep.col <- d %>% select(c("index", "Year", "Species", "AtlasSiteCode", "ColonyCode", "ColonyName",
  "Birds", "All.birds_ad_juv", "Chicks", "Fledglings", 
  "Latitude", "Longitude", "State", "DataProvider", "Identified_to_species",
  "DateReceived", "File", "AtlasNo", "Notes", "Date", "Subcolony", "Status",
  "ProviderColonyName", "HasAtlasMetric", "DataContact1", "DataContact2", 
  "DataContactEmail1", "DataContactEmail2",
  "DataContactAffiliation1", "DataContactAffiliation2"))

# trim d of these columns
d <- d %>% select(-c("ColonyCode", "ColonyName",
                     "Birds", "All.birds_ad_juv", "Chicks", "Fledglings", 
                     "Latitude", "Longitude", "State", "DataProvider", "Identified_to_species",
                     "DateReceived", "File", "AtlasNo", "Notes", "Date", "Subcolony", "Status",
                     "ProviderColonyName", "HasAtlasMetric", "DataContact1", "DataContact2", 
                     "DataContactEmail1", "DataContactEmail2",
                     "DataContactAffiliation1", "DataContactAffiliation2"))



#### Work on double counts

# ---- Make a summary table that shows which rows are duplicates (described above)

z <- d %>%
  add_count(AtlasSiteCode, Species, Year) %>%
  filter(n>1) %>% 
  select(-n)

# remove these rows from the full dataset  
d <- setdiff(d, z)


# ---- Keep rows with Nests only

# keep columns for later inner_join
w_nests <- z %>% select(-c(Pairs, Adults, OriginalPairs, OriginalAdults)) %>% 
  filter(!is.na(Nests)) %>%
  dplyr::rename(Method_Nests = SpCountMethod, SurveyVantagePoint_Nests = SurveyVantagePoint)

# When counts are different, the following keeps all different counts
# for rows where two different counts are available, keep the maximum
wn <- w_nests %>% 
  ddply(.(AtlasSiteCode, Species, Year), transform, max_count = max(Nests)) %>% 
  group_by(AtlasSiteCode, Species, Year) %>% 
  filter(Nests == max_count) %>% 
  select(-max_count) %>% 
# now, for species where [identical counts with different methods] exist,
# keep method "Maximum reported count"
  arrange(AtlasSiteCode, Species, Year, desc(Method_Nests)) %>% 
  distinct(AtlasSiteCode, Year, Species, Nests, .keep_all = T)

# Check if wn has as many rows as unique Site/Year/Species rows in w_nests
w_nests %>% distinct(AtlasSiteCode, Species, Year) %>% nrow()
wn$Year %>% length()
# ok

# ---- Keep rows with Pairs only
# keep columns for later inner_join
w_pairs <- z %>% select(-c(Nests, Adults, OriginalNests, OriginalAdults))%>%
  filter(!is.na(Pairs)) %>% 
  dplyr::rename(Method_Pairs = SpCountMethod, SurveyVantagePoint_Pairs= SurveyVantagePoint)

# To remove double counts, use same functions as for w_nests
wp <- w_pairs %>% 
  ddply(.(AtlasSiteCode, Species, Year), transform, max_count = max(Pairs)) %>% 
  group_by(AtlasSiteCode, Species, Year) %>% 
  filter(Pairs == max_count) %>% 
  select(-max_count) %>% 
  # now, for species where [identical counts with different methods] exist,
  # keep method "Maximum reported count"
  arrange(AtlasSiteCode, Species, Year, desc(Method_Pairs)) %>% 
  distinct(AtlasSiteCode, Year, Species, Pairs, .keep_all = T)

# Check if wn has as many rows as unique Site/Year/Species rows in w_nests
w_pairs %>% distinct(AtlasSiteCode, Species, Year) %>% nrow()
wp %>% nrow()
# ok


# ---- Keep rows with Adults only
# keep columns for later inner_join
w_adults <- z %>% select(-c(Nests, Pairs, OriginalNests, OriginalPairs))%>%
  filter(!is.na(Adults)) %>% 
  dplyr::rename(Method_Adults = SpCountMethod, SurveyVantagePoint_Adults = SurveyVantagePoint)

# To remove double counts, use same functions as for w_nests
wa <- w_adults %>% 
  ddply(.(AtlasSiteCode, Species, Year), transform, max_count = max(Adults)) %>% 
  group_by(AtlasSiteCode, Species, Year) %>% 
  filter(Adults == max_count) %>% 
  select(-max_count) %>% 
  # now, for species where [identical counts with different methods] exist,
  # keep method "Maximum reported count"
  arrange(AtlasSiteCode, Species, Year, desc(Method_Adults)) %>% 
  distinct(AtlasSiteCode, Year, Species, Adults, .keep_all = T)

# Check if wn has as many rows as unique Site/Year/Species rows in w_nests
w_adults %>% distinct(AtlasSiteCode, Species, Year) %>% nrow()
wa %>% nrow()
# ok


# ---- Join those together so that pairs, nests, and adults from same colonies

# are now in a single row
joints<-c("Year", "Species", "AtlasSiteCode")
z1 <- wn %>% 
  full_join(wp, by = joints) %>% 
  full_join(wa, by = joints) %>% 
  relocate(c(Pairs, Adults), .after = Nests) %>% 
  relocate(c(Method_Nests, SurveyVantagePoint_Nests), .after = AtlasSiteCode)

# Check that no rows were lost in the process
rbind(wp, wn, wa) %>% distinct(AtlasSiteCode, Year, Species) %>% nrow()
z1 %>% nrow()
# ok

# Double check if duplicates remain
z1 %>% 
  add_count(AtlasSiteCode, Species, Year) %>%
  filter(n>1) %>% nrow()
# ok

# select row index: will be used to merge back to metadata in keep.col
z1$index[!is.na(z1$index)] <- z1$index[!is.na(z1$index)]
z1$index[is.na(z1$index) & !is.na(z1$index.x)] <- z1$index.x[is.na(z1$index) & !is.na(z1$index.x)]
z1$index[is.na(z1$index) & is.na(z1$index.x)] <- z1$index.y[is.na(z1$index) & is.na(z1$index.x)]

z1<-select(z1, -c(index.x, index.y))


##### ---- transform d to create the metric-specific methods

# use same process as for z
# ---- Nests
d_nests <- d %>% select(-c(Pairs, Adults, OriginalPairs, OriginalAdults)) %>% 
  filter(!is.na(Nests)) %>%
  dplyr::rename(Method_Nests = SpCountMethod, SurveyVantagePoint_Nests = SurveyVantagePoint) %>% 
  group_by(AtlasSiteCode, Species, Year) # used to count rows later

# ---- Pairs
d_pairs <- d %>% select(-c(Nests, Adults, OriginalNests, OriginalAdults)) %>%
  filter(!is.na(Pairs)) %>% 
  dplyr::rename(Method_Pairs = SpCountMethod, SurveyVantagePoint_Pairs= SurveyVantagePoint) %>% 
  group_by(AtlasSiteCode, Species, Year) # used to count rows later

# ---- Adults
# keep columns for later inner_join
d_adults <- d %>% select(-c(Nests, Pairs, OriginalNests, OriginalPairs)) %>%
  filter(!is.na(Adults)) %>% 
  dplyr::rename(Method_Adults = SpCountMethod, SurveyVantagePoint_Adults = SurveyVantagePoint) %>% 
  group_by(AtlasSiteCode, Species, Year) # used to count rows later


d1 <- d_nests %>% 
  full_join(d_pairs, by = joints) %>% 
  full_join(d_adults, by = joints) %>% 
  relocate(c(Pairs, Adults), .after = Nests) %>% 
  relocate(c(Method_Nests, SurveyVantagePoint_Nests), .after = AtlasSiteCode)

# check if rows were lost in the process
d1 %>% nrow()
rbind(d_nests, d_pairs, d_adults) %>% distinct(AtlasSiteCode, Species, Year) %>% nrow()
d %>% nrow()

# Double check if duplicates exist
d1 %>% 
  add_count(AtlasSiteCode, Species, Year) %>%
  filter(n>1) %>% nrow()
# ok

# select row index: will be used to merge back to metadata in keep.col
d1$index[!is.na(d1$index)] <- d1$index[!is.na(d1$index)]
d1$index[is.na(d1$index) & !is.na(d1$index.x)] <- d1$index.x[is.na(d1$index) & !is.na(d1$index.x)]
d1$index[is.na(d1$index) & is.na(d1$index.x)] <- d1$index.y[is.na(d1$index) & is.na(d1$index.x)]

d1 <- select(d1, -c(index.x, index.y))


# ---- Merge d1 (main dataset) and z1 (dataset with double counts fixed)

dz <- rbind(d1,z1)

# add back the metadata

dz<-keep.col %>% 
  select(-c(AtlasSiteCode, Species, Year)) %>% 
  left_join(dz, ., by = "index")

# create methods columns to receive values from keep.nometric
dz$Method_Others <- NA
dz$SurveyVantagePoint_Others <- NA



#### ---- add back the rows with no counts in atlas metrics (keep.nometric)

# Double check if duplicates exist
keep.nometric %>% 
  add_count(AtlasSiteCode, Species, Year) %>%
  filter(n>1) %>% nrow()
# ok

# create metric-specific methods
keep.nometric$Method_Nests <- NA
keep.nometric$SurveyVantagePoint_Nests <- NA
keep.nometric$Method_Pairs <- NA
keep.nometric$SurveyVantagePoint_Pairs <- NA
keep.nometric$Method_Adults <- NA
keep.nometric$SurveyVantagePoint_Adults <- NA

keep.nometric <- keep.nometric %>% 
  dplyr::rename(Method_Others = SpCountMethod, SurveyVantagePoint_Others = SurveyVantagePoint)



#### ---- merge back with main dataset

d <-rbind(dz, keep.nometric)

KEEP <- d

rm(keep.col, keep.nometric, d_adults, d_nests, d_pairs, d1, dz,
   w_adults, w_nests, w_pairs, wa, wn, wp, z, z1, joints)

print("############################# Double-counts fixed #############################")

############################################################################################
#################################### END ###################################################
############################################################################################