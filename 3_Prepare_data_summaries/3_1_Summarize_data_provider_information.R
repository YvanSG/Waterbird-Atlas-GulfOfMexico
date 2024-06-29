############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

## Summarize_data_provider_information.R

############################################################################################

## Started 2024-03-15 (YS)

############################################################################################

#### ---- Packages

library(plyr)
library(tidyverse)


# Use dataframe "d" created in "./R/Atlas/2_Combine_all_data/1_Combine_all_data.R"

c <- as.data.frame(d)

c$Contact <- paste0(c$DataContact1, " (", c$DataContactEmail1, ")")

c$DataProvider2 <- c$DataProvider %>% as.character()

c$DataProvider2[c$DataProvider== "Alabama DCNR"] <- "Alabama Department of Conservation & Natural Resources"
c$DataProvider2[c$DataProvider== "DWH Regionwide TIG"] <- "Deepwater Horizon Regionwide Trustee Implementation Group"
c$DataProvider2[c$DataProvider== "Florida Rooftop Colony Database"] <- "Florida Fish & Wildlife Conservation Commission"
c$DataProvider2[c$DataProvider== "Florida Shorebird Database"] <- "Florida Fish & Wildlife Conservation Commission"
c$DataProvider2[c$DataProvider== "Florida Wading Bird Colony Database"] <- "Florida Fish & Wildlife Conservation Commission"

c <- ddply(c, .(DataProvider2, Contact), summarise,
           States = paste(levels(droplevels(as.factor(State))), collapse = ", "),
           Years = paste(levels(droplevels(as.factor(Year))), collapse = "; "))

c$Contact <- paste0("Contact: ", c$Contact)
c$States <- paste0("State(s): ", c$States)
c$Years <- paste0("Year(s): ", c$Years)

c$Logo <- NA
c$Logo[c$DataProvider2 == "Alabama Audubon"] <- "https://images.squarespace-cdn.com/content/v1/645950dc9b340533357d66b8/ca02ad92-4bc2-4c90-a926-b29af4124212/ALAUD_Sym_black.png"
c$Logo[c$DataProvider2 == "Alabama Department of Conservation & Natural Resources"] <- "https://www.arcgis.com/sharing/rest/content/items/574f5b809b994091983e3174bdbf02b7/resources/DCNR%20Alabama%20State%20Seal.png"
c$Logo[c$DataProvider2 == "Audubon Delta"] <- "https://delta.audubon.org/sites/default/files/styles/article_teaser_list/public/editorial-card-images/pressrelease/delta_2.png"
c$Logo[c$DataProvider2 == "Florida Fish & Wildlife Conservation Commission"] <- "https://upload.wikimedia.org/wikipedia/commons/a/a3/Patch_of_Florida_Fish_and_Wildlife_Commission.jpg"
c$Logo[c$DataProvider2 == "Florida Fish & Wildlife Conservation Commission"] <- "https://upload.wikimedia.org/wikipedia/commons/a/a3/Patch_of_Florida_Fish_and_Wildlife_Commission.jpg"
c$Logo[c$DataProvider2 == "Gulf Islands National Seashore"] <- "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/US-NationalParkService-Logo.svg/1573px-US-NationalParkService-Logo.svg.png"

# Save to .csv
write.csv(c, paste0(getwd(),"/data_output/Atlas_GIS_DataProviders.csv"), 
          row.names = FALSE, na = "")


############################################################################################
#################################### END ###################################################
############################################################################################