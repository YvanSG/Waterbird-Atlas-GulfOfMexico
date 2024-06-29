############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

## 6_Create_ArcGIS_datasets.R
## Export to ArcGIS Online ####

# Atlas ArcGIS Online platform uses three distinct versions of the main "d" dataset
# 1) A full version (in "long" format) will populate the main map and be used by Category Selectors
# 2) An horizontal version (in "wide" format) will populate graphs and tables
# 3) A summary version will populate the Site list and details tabs

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

library(plyr)
library(tidyverse)
library(sp)
library(rgdal)


# Use dataframe "d" created in "./R/Atlas/2_Combine_all_data/1_Combine_all_data.R"


#### Full dataset ####

# This dataset only keeps Nests, Pairs, and Adults data
# and transposes the data to the "long" format (based on Metrics).
# The full data will be used in the Dashboard category selectors, map and list of sites.
# Users will have access to other metrics in the .csv file

f <- d %>% 
  select(-c(AtlasIndex, Birds, All.birds_ad_juv, Chicks, Fledglings,
            OriginalNests, OriginalPairs, OriginalAdults,
            Method_Nests, Method_Pairs, Method_Adults, Method_Others,
            SurveyVantagePoint_Nests, SurveyVantagePoint_Pairs, SurveyVantagePoint_Adults,
            SurveyVantagePoint_Others, SurveyDate, ProviderColonyCode, ProviderSubcolony,
            ProviderAtlasNumber, ProviderNotes, ProviderColonyStatus, DateReceived,
            AtlasFileName)) %>% 
  as.data.frame()

f <- f %>% tidyr::pivot_longer(cols = c("Pairs", "Nests", "Adults"),
                      names_to = c("Metric"),
                      values_to = "Count")

# Remove rows with no counts
f <- f[!is.na(f$Count),]

# Round Counts to upper integer
f$Count <- ceiling(f$Count) %>% as.integer()

# Add a MetricCode category to sort Metric as: 1. Nest, 2. Pairs, 3. Adults
f$MetricCode <- NA
f$MetricCode[f$Metric=="Nests"] <- 1
f$MetricCode[f$Metric=="Pairs"] <- 2
f$MetricCode[f$Metric=="Adults"] <- 3

# Add a Zero category to filter between 0 and non-0 count values
f$Zero <- NA
f$Zero[f$Count==0] <- "Y"
f$Zero[f$Count!=0] <- "N"

# Sort by Species (so colors in charts make sense), State, ColonyName
f <- plyr::arrange(f, Species, State, AtlasSiteCode)


# Save to .csv
write.csv(f, paste0(getwd(),"/data_output/Atlas_GIS_full_",Sys.Date(),".csv"), 
          row.names = FALSE, na = "")


# Problem with AGOL converting some year columns to STRINGS instead of INTEGER
# Overpass this issue by exporting as GeoJSON

fsp <- f

coordinates(fsp) <- ~Longitude+Latitude
# plot(fsp)
proj4string(fsp) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
# fsp

writeOGR(fsp, dsn = paste0(getwd(),"/data_output/Atlas_GIS_full_",Sys.Date(),".GeoJSON"),
         layer = "Atlas_GIS_full",
         driver = "GeoJSON", overwrite_layer = TRUE)

## In ArcGIS Online: before updating the Feature Layer, 
## remove the date from the GeoJSON file name.
## eg. import Atlas_GIS_full_2024-03-20.GeoJSON as Atlas_GIS_full.GeoJSON



#### Horizontal dataset ####

# This dataset only keeps Nests, Pairs, and Adults data (and associated metadata)
# and transposes the data to the "wide" format (based on Year).
# The horizontal dataset will be used in Dashboard tables and graphs.


h <- f %>% 
  select(-c(Identified_to_species, HasAtlasMetric, 
            DataContact1, DataContact2, DataContactEmail1, DataContactEmail2, 
            DataContactAffiliation1, DataContactAffiliation2))

# Transpose the data to "wide" format

#### ---- Nests
h_n <- h %>% filter(Metric == "Nests")
h_n <- h_n %>% pivot_wider(names_from = Year, values_from = Count)

# Create a vector of Year, to reorder the newly created Year columns
sortcol <- h_n %>% select(starts_with("20")) %>% 
  colnames() %>% as.numeric() %>% 
  sort() %>% as.character()

# Sort Year columns
h_n <- h_n %>% select(-sortcol, sortcol)

h_n <- as.data.frame(h_n)

#### ---- Pairs
h_p <- h %>% filter(Metric == "Pairs")
h_p <- h_p %>% pivot_wider(names_from = Year, values_from = Count)

# Sort Year columns
h_p <- h_p %>% select(-sortcol, sortcol)

h_p <- as.data.frame(h_p)


#### ---- Adults
h_a <- h %>% filter(Metric == "Adults")
h_a <- h_a %>% pivot_wider(names_from = Year, values_from = Count)

# Sort Year columns
h_a <- h_a %>% select(-sortcol, sortcol)

h_a <- as.data.frame(h_a)


# Bind back together
h <- rbind(h_n, h_p, h_a)


# Sort by State, ColonyName, Species
h <- plyr::arrange(h, State, AtlasSiteCode, Species)

# Save to .csv
write.csv(h, paste0(getwd(),"/data_output/Atlas_GIS_horizontal_",Sys.Date(),".csv"), 
          row.names = FALSE, na = "")

# Save to GeoJSON
hsp <- h
coordinates(hsp) <- ~Longitude+Latitude
# plot(hsp)
proj4string(hsp) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
# hsp

writeOGR(hsp, dsn = paste0(getwd(),"/data_output/Atlas_GIS_horizontal_",Sys.Date(),".GeoJSON"),
         layer = "Atlas_GIS_horizontal",
         driver = "GeoJSON", overwrite_layer = TRUE)

## In ArcGIS Online: before updating the Feature Layer, 
## remove the date from the GeoJSON file name.
## eg. import Atlas_GIS_horizontal_2024-03-20.GeoJSON as Atlas_GIS_horizontal.GeoJSON



#### Summary dataset ####

# This dataset only keeps information about sites, and associated metadata
# and collates them into site-specific summaries.
# The summary dataset will be used in the Dashboard tab "Site details".

s <- as.data.frame(d)
s <- s[s$HasAtlasMetric == "Y",]



#### Check lengths of AtlasSiteCode and ProviderColonyName

s$AtlasSiteCode %>% as.factor() %>% levels() %>% length()
s$ProviderColonyName %>% as.factor() %>% levels() %>% length()

# There are more AtlasSiteCode than ProviderColonyName
# This is because some colonies have similar names across datasets
# or some datasets surveyed the same colonies (eg. TIG overlapping with other providers).
# AtlasSiteCode provides more details because it integrates not only the ProviderColonyName
# but also the DataProvider name, etc
## => in ArcGIS Online Dashboard, use AtlasSiteCode



#### ---- Contact information

s$Contact <- paste0(s$DataContact1, " (", s$DataContactEmail1, ", ",
                    s$DataContactAffiliation1, ")")
s$Contact[!is.na(s$DataContact2)] <-
  paste0(s$Contact[!is.na(s$DataContact2)], "<br>",
         s$DataContact2[!is.na(s$DataContact2)], 
         " (", s$DataContactEmail2[!is.na(s$DataContact2)], ", ",
         s$DataContactAffiliation2[!is.na(s$DataContact2)], ")")


#### ---- Metrics

# Concatenate metrics, for those who have them
colAtMet <- c("Nests", "Pairs", "Adults")
colOthMet <- c("Birds","All.birds_ad_juv","Chicks","Fledglings")
s <- s %>% 
  group_by(ProviderColonyName, State, Latitude, Longitude) %>% 
  plyr::mutate(
    AtlasMetric = apply(.[, colAtMet], 1, function(i) paste(colnames(s[,colAtMet])[ !is.na(i) ], collapse = ", ")),
    OtherMetric = apply(s[, colOthMet], 1, function(i) paste(colnames(s[,colOthMet])[ !is.na(i) ], collapse = ", "))
  )

rm(colAtMet, colOthMet)

#### ---- Summarize

# Add number of species
s <- ddply(s, .(AtlasSiteCode), transform,
           Number_of_species = length(levels(droplevels(as.factor(Species)))))

# Add Zero column (Presence/Absence)
s$n <- ifelse(s$Nests == 0, "Y", "N")
s$p <- ifelse(s$Pairs == 0, "Y", "N")
s$a <- ifelse(s$Adults == 0, "Y", "N")

s$Zero <- apply(cbind(s$n, s$p, s$a), 1, 
                    function(x) paste(x[!is.na(x)], collapse = ","))
s$Zero <- sapply(strsplit(as.character(s$Zero), ","), 
                     function(x) paste(unique(x), collapse=","))
s$Zero[s$Zero == "Y,N"] <- "N,Y"

s$n <- NULL
s$p <- NULL
s$a <- NULL

# Summarize
s <- ddply(s, .(AtlasSiteCode, ProviderColonyName, State, Latitude, Longitude, Number_of_species),
           summarise,
           Years = paste(levels(droplevels(as.factor(Year))), collapse = "; "),
           Species = paste(levels(droplevels(as.factor(Species))), collapse = "; "),
           Providers = paste(levels(droplevels(as.factor(DataProvider))), collapse = "; "),
           Contacts = paste(levels(droplevels(as.factor(Contact))), collapse = "; "),
           AtlasMetrics = paste(levels(droplevels(as.factor(unique(AtlasMetric)))), collapse = ", "),
           OtherMetrics = paste(levels(droplevels(as.factor(unique(OtherMetric)))), collapse = ", "),
           Methods_Nests = paste(levels(droplevels(as.factor(Method_Nests))), collapse = "; "),
           Methods_Pairs = paste(levels(droplevels(as.factor(Method_Pairs))), collapse = "; "),
           Methods_Adults = paste(levels(droplevels(as.factor(Method_Adults))), collapse = "; "),
           Methods_Other = paste(levels(droplevels(as.factor(Method_Others))), collapse = "; "),
           TIG = paste(levels(droplevels(as.factor(TIGDisplay))), collapse = "; "),
           Zero = paste(levels(droplevels(as.factor(Zero))), collapse = "; "))

# Check Metrics levels
s$AtlasMetrics %>% as.factor() %>% levels() # metrics were duplicated during the concatenation

# Remove metrics duplicates
s$AtlasMetrics <- sapply(strsplit(as.character(s$AtlasMetrics), ", "), function(x) paste(unique(x), collapse=", "))
s$AtlasMetrics <- gsub("^\\W+|\\W+$", "", s$AtlasMetrics)
s$AtlasMetrics %>% as.factor() %>% levels() # multiple combinations of the three metrics exist

# Keep only necessary metric combinations
s$AtlasMetrics[s$AtlasMetrics=="Adults, Nests"] <- "Nests, Adults"
s$AtlasMetrics[s$AtlasMetrics=="Adults, Nests, Pairs"] <- "Nests, Pairs, Adults"
s$AtlasMetrics[s$AtlasMetrics=="Nests, Adults, Pairs"] <- "Nests, Pairs, Adults"
s$AtlasMetrics %>% as.factor() %>% levels() # ok

##### ---- Other metrics
# remove sites that don't have any Atlas metrics
s$OtherMetrics <- sapply(strsplit(as.character(s$OtherMetrics), ", "), function(x) paste(unique(x), collapse=", "))
s$OtherMetrics <- gsub("^\\W+|\\W+$", "", s$OtherMetrics)
s$OtherMetrics[s$OtherMetrics=="All.birds_ad_juv"] <- "All birds (adults and juveniles)"
s$OtherMetrics %>% as.factor() %>% levels() # ok


#### ---- Methods

# Check levels
s$Methods_Nests %>% as.factor() %>% levels() # ok
s$Methods_Pairs %>% as.factor() %>% levels() # ok
s$Methods_Adults %>% as.factor() %>% levels() # ok


#### ---- Presence/Absence

# Clean up duplicates codes
s$Zero <- sapply(strsplit(as.character(s$Zero), ";"), 
                     function(x) paste(unique(x), collapse=","))
s$Zero <- sapply(strsplit(as.character(s$Zero), ", "), 
                     function(x) paste(unique(x), collapse=","))
s$Zero <- sapply(strsplit(as.character(s$Zero), ","), 
                     function(x) paste(unique(x), collapse=","))
s$Zero %>% as.factor() %>% summary() # ok

#### ---- Reference

s$Reference <- NA

s$Reference[s$State == "Texas"] <- 
  'Texas Waterbird Society. 2023. <i>Maps and Data Portal. </i><a href="https://www.texaswaterbirds.org/data">https://www.texaswaterbirds.org/data</a>'

s$Reference[s$Providers == "DWH Regionwide TIG"] <-
  'Deepwater Horizon Regionwide Trustee Implementation Group. 2023. <i>Avian Data Monitoring Portal. </i><a href="https://www.avianmonitoring.com">https://www.avianmonitoring.com</a>'

s$Reference[s$Providers == "Alabama DCNR"] <-
  'Alabama Department of Conservation and Natural Resources. 2010-2022. <i>Division of Wildlife and Freshwater Fisheries — Nongame Wildlife Program. </i><a href="https://www.outdooralabama.com/about-us/wildlife-and-freshwater-fisheries-division">https://www.outdooralabama.com/about-us/wildlife-and-freshwater-fisheries-division</a>'

s$Reference[s$Providers == "Alabama Audubon"] <-
  'Alabama Audubon Coastal Bird Stewardship Program. 2023. <a href="https://alaudubon.org/research">https://alaudubon.org/research</a>'

s$Reference[s$State == "FL" & s$Providers %in% c("Florida Rooftop Colony Database", "Florida Shorebird Database")] <- 
  'Florida Shorebird Database. 2023. <i>Online tool for entering and exploring data on Florida’s shorebirds and seabirds, developed and maintained by the Florida Fish and Wildlife Conservation Commission. </i><a href="https://app.myfwc.com/crossdoi/shorebirds/">https://app.myfwc.com/crossdoi/shorebirds/</a>'

s$Reference[s$State == "FL" & s$Providers == "Florida Wading Bird Colony Database" ] <- 
  'Florida Fish and Wildlife Conservation Commission Research Institute. 2023. <i>Wading Bird database. </i><a href="https://myfwc.com/research/">https://myfwc.com/research/</a>'

s$Reference[s$Providers == "Gulf Islands National Seashore"] <- ""
  
s$Reference[s$Providers == "Audubon Delta"] <-
  'Audubon Delta Coastal Bird Stewardship Program. 2023. <a href="https://delta.audubon.org/landingconversation/coastal-stewardship-program">https://delta.audubon.org/landingconversation/coastal-stewardship-program</a>'


s <- plyr::arrange(s, ProviderColonyName)

# Save to .csv
write.csv(s, paste0(getwd(),"/data_output/Atlas_GIS_summary_",Sys.Date(),".csv"), 
          row.names = FALSE, na = "")


# Save to GeoJSON

ssp <- s
coordinates(ssp) <- ~Longitude+Latitude
# plot(ssp)
proj4string(ssp) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")

writeOGR(ssp,
         dsn = paste0(getwd(),"/data_output/Atlas_GIS_summary_",Sys.Date(),".GeoJSON"),
         layer = "Atlas_GIS_summary",
         driver = "GeoJSON", overwrite_layer = TRUE)

## In ArcGIS Online: before updating the Feature Layer, 
## remove the date from the GeoJSON file name.
## eg. import Atlas_GIS_summary_2024-03-20.GeoJSON as Atlas_GIS_summary.GeoJSON

rm(f, fsp, h, h_a, h_n, h_p, hsp, s, ssp, sortcol)

print("############################## ArcGIS files created ############################")

############################################################################################
#################################### END ###################################################
############################################################################################