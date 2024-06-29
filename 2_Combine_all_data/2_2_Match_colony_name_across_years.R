############################################################################################
############# Atlas of Waterbird Breeding Sites in the Northern Gulf of Mexico #############
############################################################################################

## Written by Kathy Hixson
## Adapted by Yvan Satgé
## Clemson University - South Carolina Cooperative Fish and Wildlife Research Unit

############################################################################################

## 2_Match_colony_name_across_years.R
## Modify colony names so they match across years

# This is mostly for Texas data
# Some of these are fully different names (like the Chaney Islands),
# some are plurals/singulars, some are different spellings or misspellings.
# Also for Texas, check if coordinates are the same across years
# if multiple sets of coordinates are used for a single colony, use the historic one.
# Most of these locations are just slightly different from each other
# so, at the Atlas level, it is not significant which one we use. 

############################################################################################

## Started 2023-6-15 (KH)
## Finalized 2024-02-23 (YS)

############################################################################################

#### ---- Packages

# library(plyr)
# library(tidyverse)
# library(data.table)


# Use dataframe "d" created in "./R/Atlas/2_Combine_all_data/1_Combine_all_data.R"


# 614363 : chaney #36 / Diked Island NM 178
d <- within(d, ColonyName[ColonyCode == '614363' ] <- 'Diked Island NM 178/chaney #36')

# 614302 : chaney #60 / Marker 37 - 38 Spoil NM 79
# colony w multiple names and the A subcolony from central coast data has coordinates of the east side of Padre Island (likely incorrect)
d <- within(d, ColonyName[ColonyName == 'chaney #60 - A' | ColonyName == 'Marker 37 - 38 Spoil NM 79 - A'] <- 'Marker 37 - 38 Spoil NM 79/chaney #60 - A')
d <- within(d, ColonyName[ColonyName == 'Marker 37 - 38 Spoil NM 79 - B'] <- 'Marker 37 - 38 Spoil NM 79/chaney #61 - B')
d <- within(d, Latitude[ColonyName == 'Marker 37 - 38 Spoil NM 79/chaney #60 - A'] <- 27.55418)
d <- within(d, Longitude[ColonyName == 'Marker 37 - 38 Spoil NM 79/chaney #60 - A'] <- -97.2863)

# 614306 : North Bird Island / chaney #50
d <- within(d, ColonyName[ColonyName == 'North Bird Island' | ColonyName == 'chaney #50 North Bird Island'] <- 'North Bird Island/chaney #50')
d <- within(d, Latitude[ColonyName == 'North Bird Island/chaney #50'] <- 27.5200000000)
d <- within(d, Longitude[ColonyName == 'North Bird Island/chaney #50'] <- -97.2908333300)

# 614343 : Marker 69 Spoil (NM 141) / chaney #42  :: coordinates are slightly different, so I make them all the same 
d <- within(d, ColonyName[ColonyCode == '614343'] <- 'Marker 69 Spoil (NM 141)/chaney #42')
d <- within(d, Latitude[ColonyCode == '614343'] <- 27.43278)
d <- within(d, Longitude[ColonyCode == '614343'] <- -97.34083)

# 614344 : Marker 72 Spoil Island (NM 152) / chaney #41 :: coordinates are slightly different, so I make them all the same 
d <- within(d, ColonyName[ColonyCode == '614344'] <- 'Marker 72 Spoil Island (NM 152)/chaney #41')
d <- within(d, Latitude[ColonyCode == '614344'] <- 27.42083)
d <- within(d, Longitude[ColonyCode == '614344'] <- -97.355)

# 614345 : Marker 81 Spoil Island (NM 163) / chaney #38 :: coordinates are slightly different, so I make them all the same 
d <- within(d, ColonyName[ColonyCode == '614345'] <- 'Marker 81 Spoil Island (NM 163)/chaney #38')
d <- within(d, Latitude[ColonyCode == '614345'] <- 27.391110)
d <- within(d, Longitude[ColonyCode == '614345'] <- -97.363050)

# Yellow House Spoil (NM 162) / chaney #40 :: coordinates are slightly different, so I make them all the same
d <- within(d, ColonyName[ColonyCode == '614348'] <- 'Yellow House Spoil (NM 162)/chaney #40')
d <- within(d, Latitude[ColonyCode == '614348'] <- 27.41672)
d <- within(d, Longitude[ColonyCode == '614348'] <- -97.35872)

# Sundown Island / Chester (Sundown) Island
d <- within(d, ColonyName[ColonyCode == '609300'] <- 'Sundown Island/Chester Island')

# Turnstake / Turnstake Spoil:: names and coordinates slightly different 
d <- within(d, ColonyName[ColonyCode == '609320'] <- 'Turnstake / Turnstake Spoil')
d <- within(d, Latitude[ColonyCode == '609320'] <- 28.31530)
d <- within(d, Longitude[ColonyCode == '609320'] <- -96.68260)

# 614304: chaney #59 B / North of Bird Island Marker 43 - B:: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'chaney #59 - B' | ColonyName == 'North of Bird Island Marker 43 - B'] <- 'North of Bird Island Marker 43/chaney #59 - B')
d <- within(d, Latitude[ColonyName == 'North of Bird Island Marker 43/chaney #59 - B'] <- 27.53459)
d <- within(d, Longitude[ColonyName == 'North of Bird Island Marker 43/chaney #59 - B'] <- -97.29774)

# 614342 : Marker 63-65 Spoil (NM 127-131) - A / chaney #43 :: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'chaney #43 Marker 63-131 - A' | ColonyName == 'Marker 63-65 Spoil (NM 127-131) - A'] <- 'Marker 63-65 Spoil (NM 127-131)/chaney #43 - A')
d <- within(d, Latitude[ColonyName == 'Marker 63-65 Spoil (NM 127-131)/chaney #43 - A'] <- 27.45220)
d <- within(d, Longitude[ColonyName == 'Marker 63-65 Spoil (NM 127-131)/chaney #43 - A'] <- -97.33206200)

# 614342 : Marker 63-65 Spoil (NM 127-131) - B /  chaney #44 Marker 63-65 - B :: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'chaney #44 Marker 63-65 - B' | ColonyName == 'Marker 63-65 Spoil (NM 127-131) - B'] <- 'Marker 63-65 Spoil (NM 127-131)/chaney #44 - B')
d <- within(d, Latitude[ColonyName == 'Marker 63-65 Spoil (NM 127-131)/chaney #44 - B'] <- 27.45936400)
d <- within(d, Longitude[ColonyName == 'Marker 63-65 Spoil (NM 127-131)/chaney #44 - B'] <- -97.32825400)

# 614384 The Hole / Chaney #1  :: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'Chaney #1 - A' | ColonyName == 'The Hole - A'] <- 'The Hole/chaney #1 - A')
d <- within(d, Latitude[ColonyName == 'The Hole/chaney #1 - A'] <- 27.1788020000)
d <- within(d, Longitude[ColonyName == 'The Hole/chaney #1 - A'] <- -97.4276690000)

# 614384 The Hole / Chaney #2  :: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'chaney #2 - B' | ColonyName == 'The Hole - B'] <- 'The Hole/chaney #2 - B')
d <- within(d, Latitude[ColonyName == 'The Hole/chaney #2 - B'] <- 27.1816350000)
d <- within(d, Longitude[ColonyName == 'The Hole/chaney #2 - B'] <- -97.4283440000)

# 609261 Kenyon Island / Guadalupe Delta :: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'Kenyon Island' | ColonyName == 'Guadalupe Delta'] <- 'Kenyon Island/Guadalupe Delta')
d <- within(d, Latitude[ColonyName == 'Kenyon Island/Guadalupe Delta'] <- 28.4483333300)
d <- within(d, Longitude[ColonyName == 'Kenyon Island/Guadalupe Delta'] <- -96.7986111100)

# 614383 South Yarbourough Pass (NM 41-47) - B / Chaney #4 - B :: 2 names and slightly different coordinates
d <- within(d, ColonyName[ColonyName == 'South Yarbourough Pass (NM 41-47) - B' | ColonyName == 'Chaney #4 - B'] <-'South Yarbourough Pass (NM 41-47)/Chaney #4 - B')
d <- within(d, Latitude[ColonyName == 'South Yarbourough Pass (NM 41-47)/Chaney #4 - B'] <- 27.1957970000)
d <- within(d, Longitude[ColonyName == 'South Yarbourough Pass (NM 41-47)/Chaney #4 - B'] <- -97.4252100000)

# 614383 South Yarbourough Pass (NM 41-47) - C / 	Chaney #5 - C  :: 2 names and slightly different coordinates   QUITE
d <- within(d, ColonyName[ColonyName == 'South Yarbourough Pass (NM 41-47) - C' | ColonyName == 'Chaney #5 - C'] <-'South Yarbourough Pass (NM 41-47)/Chaney #5 - C')
d <- within(d, Latitude[ColonyName == 'South Yarbourough Pass (NM 41-47)/Chaney #5 - C'] <- 27.1975990000)
d <- within(d, Longitude[ColonyName == 'South Yarbourough Pass (NM 41-47)/Chaney #5 - C'] <- -97.4250170000)

# 618250 Bahia Grande- Bird Island-C / Bahia Grande: Railroad Is.
d <- within(d, ColonyName[ColonyName == 'Bahia Grande- Bird Island-C' | ColonyName == 'Bahia Grande: Railroad Is.'] <-'Bahia Grande:Railroad Is./Bird Island - C')
d <- within(d, Latitude[ColonyName == 'Bahia Grande:Railroad Is./Bird Island - C'] <- 26.0354)
d <- within(d, Longitude[ColonyName == 'Bahia Grande:Railroad Is./Bird Island - C'] <- -97.30183)

# 618250 Bahia Grande- Bird Island-B / Bahia Grande: Bird Is. East
d <- within(d, ColonyName[ColonyName == 'Bahia Grande- Bird Island-B' | ColonyName == 'Bahia Grande: Bird Is. East'] <-'Bahia Grande: Bird Is. East/Bird Island - B')
d <- within(d, Latitude[ColonyName == 'Bahia Grande: Bird Is. East/Bird Island - B'] <- 26.04403)
d <- within(d, Longitude[ColonyName == 'Bahia Grande: Bird Is. East/Bird Island - B'] <- -97.30575)

# 618250 Bahia Grande- Bird Island-A / Bahia Grande: Bird Island
d <- within(d, ColonyName[ColonyName == 'Bahia Grande: Bird Island' | ColonyName == 'Bahia Grande- Bird Island-A'] <-'Bahia Grande: Bird Island - A')

#614221i chaney #125 - I / Naval Air Station Islands - I
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - I' | ColonyName == 'chaney #125 - I'] <-'Naval Air Station Islands/chaney #125 - I')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #125 - I'] <- 27.6634101868)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #125 - I'] <- -97.2466278076)

# 614382 Chaney #7 - A / North Yarborough Pass (NM 37-39) - A
d <- within(d, ColonyName[ColonyName == 'Chaney #7 - A' | ColonyName == 'North Yarborough Pass (NM 37-39) - A'] <-'North Yarborough Pass (NM 37-39)/Chaney #7 - A')
d <- within(d, Latitude[ColonyName == 'North Yarborough Pass (NM 37-39)/Chaney #7 - A'] <- 27.2042940000)
d <- within(d, Longitude[ColonyName == 'North Yarborough Pass (NM 37-39)/Chaney #7 - A'] <- -97.4235700000)

# 614382 North Yarborough Pass (NM 37-39) - B / Chaney #8 - B  
d <- within(d, ColonyName[ColonyName == 'North Yarborough Pass (NM 37-39) - B' | ColonyName == 'Chaney #8 - B'] <-'North Yarborough Pass (NM 37-39)/Chaney #8 - B')
d <- within(d, Latitude[ColonyName == 'North Yarborough Pass (NM 37-39)/Chaney #8 - B'] <- 27.2069980000)
d <- within(d, Longitude[ColonyName == 'North Yarborough Pass (NM 37-39)/Chaney #8 - B'] <- -97.4226540000)

# 600151 Armand Bayou Nature Center, West Bank and East Bank
# In 2022, this site was split into east bank and west bank but the coordinate included are incorrect. There are no overlapping spp between east and west so in the interest of simplicity and  matching past years, I'm dropping the east and west.
d <- within(d, ColonyName[ColonyName == 'Armand Bayou Nature Center (West Bank)' | ColonyName == 'Armand Bayou Nature Center (East Bank)'] <-'Armand Bayou Nature Center')
d <- within(d, Latitude[ColonyName == 'Armand Bayou Nature Center'] <- 29.573792)
d <- within(d, Longitude[ColonyName == 'Armand Bayou Nature Center'] <- -95.082636)
d <- within(d, ColonyCode[ColonyName == 'Armand Bayou Nature Center'] <- 600151)

# 614221 Naval Air Station Islands - B / chaney #118 - B
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - B' | ColonyName == 'chaney #118 - B'] <-'Naval Air Station Islands/chaney #118 - B')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #118 - B'] <- 27.6856330000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #118 - B'] <- -97.2387180000)

# 614221 Naval Air Station Islands - C / chaney #119 - C
d <- within(d, ColonyName[ColonyName == 'chaney #119 - C' | ColonyName == 'Naval Air Station Islands - C'] <-'Naval Air Station Islands/chaney #119 - C')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #119 - C'] <- 27.6756330000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #119 - C'] <- -97.25388600)

# 614221 Naval Air Station Islands - D / chaney #120 - D
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - D' | ColonyName == 'chaney #120 - D'] <-'Naval Air Station Islands/chaney #120 - D')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #120 - D'] <- 27.6743030000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #120 - D'] <- -97.2514150000)

# 614221 Naval Air Station Islands - E / chaney #121 - E
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - E' | ColonyName == 'chaney #121 - E'] <-'Naval Air Station Islands/chaney #121 - E')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #121 - E'] <- 27.6722000000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #121 - E'] <- -97.2500580000)

# 614221 Naval Air Station Islands - F / chaney #122 - F
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - F' | ColonyName == 'chaney #122 - F'] <-'Naval Air Station Islands/chaney #122 - F')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #122 - F'] <- 27.6706120000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #122 - F'] <- -97.2484590000)

# 614221 Naval Air Station Islands - G / chaney #123 - G
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - G' | ColonyName == 'chaney #123 - G'] <-'Naval Air Station Islands/chaney #123 - G')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #123 - G'] <- 27.6686810000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #123 - G'] <- -97.2518510000)

# 614221 Naval Air Station Islands - H / chaney #124 - H
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - H' | ColonyName == 'chaney #124 - H'] <-'Naval Air Station Islands/chaney #124 - H')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #124 - H'] <- 27.6638750000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #124 - H'] <- -97.2486040000)

# 614221 Naval Air Station Islands - J / chaney #126 - J
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - J' | ColonyName == 'chaney #126 - J'] <-'Naval Air Station Islands/chaney #126 - J')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #126 - J'] <- 27.6580380000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #126 - J'] <- -97.2454070000)

# 614221 Naval Air Station Islands - K / chaney #127 - K
d <- within(d, ColonyName[ColonyName == 'chaney #127 - K' | ColonyName == 'Naval Air Station Islands - K'] <-'Naval Air Station Islands/chaney #127 - K')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #127 - K'] <- 27.6534890000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #127 - K'] <- -97.2420150000)

# 614221 Naval Air Station Islands - O / chaney #131 - O
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - O' | ColonyName == 'chaney #131 - O'] <-'Naval Air Station Islands/chaney #131 - O')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #131 - O'] <- 27.6630590000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #131 - O'] <- -97.2545160000)

# 614221 Naval Air Station Islands - P / chaney #132 - P
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - P' | ColonyName == 'chaney #132 - P'] <-'Naval Air Station Islands/chaney #132 - P')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #132 - P'] <- 27.6704410000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #132 - P'] <- -97.2583430000)

# 614221 Naval Air Station Islands - S / chaney #135 tern - S
d <- within(d, ColonyName[ColonyName == 'Naval Air Station Islands - S' | ColonyName == 'chaney #135 tern - S'] <-'Naval Air Station Islands/chaney #135 tern - S')
d <- within(d, Latitude[ColonyName == 'Naval Air Station Islands/chaney #135 tern - S'] <- 27.6576950000)
d <- within(d, Longitude[ColonyName == 'Naval Air Station Islands/chaney #135 tern - S'] <- -97.2509790000)

# 614222 Kennedy Causeway Islands - Z / chaney #100 - Z
d <- within(d, ColonyName[ColonyName == 'Kennedy Causeway Islands - Z' | ColonyName == 'chaney #100 - Z'] <-'Kennedy Causeway Islands/chaney #100 - Z')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/chaney #100 - Z'] <- 27.6320310000)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/chaney #100 - Z'] <- -97.2763780000)

# 614364 Side Channel Island (NM 199) - A / chaney #32 - A
d <- within(d, ColonyName[ColonyName == 'Side Channel Island (NM 199) - A' | ColonyName == 'chaney #32 - A'] <-'Side Channel Island (NM 199)/chaney #32 - A')
d <- within(d, Latitude[ColonyName == 'Side Channel Island (NM 199)/chaney #32 - A'] <- 27.3270000000)
d <- within(d, Longitude[ColonyName == 'Side Channel Island (NM 199)/chaney #32 - A'] <- -97.3921520000)

# 614364 Side Channel Island (NM 199) - B / chaney #33 - B
d <- within(d, ColonyName[ColonyName == 'Side Channel Island (NM 199) - B' | ColonyName == 'chaney #33 - B'] <-'Side Channel Island (NM 199)/chaney #33 - B')
d <- within(d, Latitude[ColonyName == 'Side Channel Island (NM 199)/chaney #33 - B'] <- 27.3257120000)
d <- within(d, Longitude[ColonyName == 'Side Channel Island (NM 199)/chaney #33 - B'] <- -97.3905220000)

# 614364 Side Channel Island (NM 199) - C / chaney #34 - C
d <- within(d, ColonyName[ColonyName == 'Side Channel Island (NM 199) - C' | ColonyName == 'chaney #34 - C'] <-'Side Channel Island (NM 199)/chaney #34 - C')
d <- within(d, Latitude[ColonyName == 'Side Channel Island (NM 199)/chaney #34 - C'] <- 27.3243440000)
d <- within(d, Longitude[ColonyName == 'Side Channel Island (NM 199)/chaney #34 - C'] <- -97.388438000)

# 614380 Marker 139-155 Spoil  (19-35) - B / chaney #10 - B
d <- within(d, ColonyName[ColonyName == 'Marker 139-155 Spoil  (19-35) - B' | ColonyName == 'chaney #10 - B'] <-'Marker 139-155 Spoil (19-35)/chaney #10 - B')
d <- within(d, Latitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #10 - B'] <- 27.2218200000)
d <- within(d, Longitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #10 - B'] <- -97.4196410000)

# 614380  Marker 139-155 Spoil  (19-35) - C / chaney #11 - C
d <- within(d, ColonyName[ColonyName == 'Marker 139-155 Spoil  (19-35) - C' | ColonyName == 'chaney #11 - C'] <-'Marker 139-155 Spoil (19-35)/chaney #11 - C')
d <- within(d, Latitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #11 - C'] <- 27.2243000000)
d <- within(d, Longitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #11 - C'] <- -97.4187000000)

# 614380 Marker 139-155 Spoil  (19-35) - D / chaney #13 - D
d <- within(d, ColonyName[ColonyName == 'Marker 139-155 Spoil  (19-35) - D' | ColonyName == 'chaney #13 - D'] <-'Marker 139-155 Spoil (19-35)/chaney #13 - D')
d <- within(d, Latitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #13 - D'] <- 27.227677780)
d <- within(d, Longitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #13 - D'] <- -97.4183472200)

# 614380 Marker 139-155 Spoil  (19-35) - H / chaney #17 - H
d <- within(d, ColonyName[ColonyName == 'Marker 139-155 Spoil  (19-35) - H' | ColonyName == 'chaney #17 - H'] <-'Marker 139-155 Spoil (19-35)/chaney #17 - H')
d <- within(d, Latitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #17 - H'] <- 27.2325330000)
d <- within(d, Longitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #17 - H'] <- -97.4166940000)

# 614380 Marker 139-155 Spoil  (19-35) - E / chaney #14 - E
d <- within(d, ColonyName[ColonyName == 'Marker 139-155 Spoil  (19-35) - E' | ColonyName == 'chaney #14 - E'] <-'Marker 139-155 Spoil (19-35)/chaney #14 - E')
d <- within(d, Latitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #14 - E'] <- 27.2289638519)
d <- within(d, Longitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #14 - E'] <- -97.4180297852)

# 614380 Marker 139-155 Spoil  (19-35) - F / chaney #15 - F
d <- within(d, ColonyName[ColonyName == 'Marker 139-155 Spoil  (19-35) - F' | ColonyName == 'chaney #15 - F'] <-'Marker 139-155 Spoil (19-35)/chaney #15 - F')
d <- within(d, Latitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #15 - F'] <- 27.2309703827)
d <- within(d, Longitude[ColonyName == 'Marker 139-155 Spoil (19-35)/chaney #15 - F'] <- -97.4174804688)

# 614361 Marker 103-117 Spoil (NM 207-221) - A / chaney #25 - A
d <- within(d, ColonyName[ColonyName == 'Marker 103-117 Spoil (NM 207-221) - A' | ColonyName == 'chaney #25 - A'] <-'Marker 103-117 Spoil (NM 207-221)/chaney #25 - A')
d <- within(d, Latitude[ColonyName == 'Marker 103-117 Spoil (NM 207-221)/chaney #25 - A'] <- 27.2858820000  )
d <- within(d, Longitude[ColonyName == 'Marker 103-117 Spoil (NM 207-221)/chaney #25 - A'] <- -97.4055540000)

# 614300 Pita Island / Humble Channel - B / chaney #66 - B
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - B' | ColonyName == 'chaney #66 - B'] <-'Pita Island/Humble Channel/chaney #66 - B')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #66 - B'] <- 27.5926780000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #66 - B'] <- 	-97.264484000)

# 614300 Pita Island / Humble Channel - C
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - C' | ColonyName == 'chaney #67 - C'] <-'Pita Island/Humble Channel/chaney #67 - C')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #67 - C'] <- 27.5936650000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #67 - C'] <- -97.2677280000)

# 614300 Pita Island / Humble Channel - D / chaney #68 - D
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - D' | ColonyName == 'chaney #68 - D'] <-'Pita Island/Humble Channel/chaney #68 - D')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #68 - D'] <- 27.5951240000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #68 - D'] <- -97.270392000)

# 614300 Pita Island / Humble Channel - E / chaney #69 - E
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - E' | ColonyName == 'chaney #69 - E'] <-'Pita Island/Humble Channel/chaney #69 - E')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #69 - E'] <- 27.5958110000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #69 - E'] <- -97.2736840000)

# 614300 Pita Island / Humble Channel - F /  chaney #70 - F
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - F' | ColonyName == 'chaney #70 - F'] <-'Pita Island/Humble Channel/chaney #70 - F')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #70 - F'] <- 27.5976130000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #70 - F'] <- -97.2731530000)

# 614300 Pita Island / Humble Channel - G / chaney #71 - G
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - G' | ColonyName == 'chaney #71 - G'] <-'Pita Island/Humble Channel/chaney #71 - G')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #71 - G'] <- 27.6022480000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #71 - G'] <- -97.2708280000)

# 614300 Pita Island / Humble Channel - H / chaney #72 - H
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - H' | ColonyName == 'chaney #72 - H'] <-'Pita Island/Humble Channel/chaney #72 - H')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #72 - H'] <- 27.6056390000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #72 - H'] <- -97.2724750000)

# 614300 Pita Island / Humble Channel - I / chaney #73 - I
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - I' | ColonyName == 'chaney #73 - I'] <-'Pita Island/Humble Channel/chaney #73 - I')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #73 - I'] <- 27.601347000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #73 - I'] <- -97.2754760000)

# 614300 Pita Island / Humble Channel - J / chaney #74 - J
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - J' | ColonyName == 'chaney #74 - J'] <-'Pita Island/Humble Channel/chaney #74 - J')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #74 - J'] <- 27.5973560000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #74 - J'] <- -97.2772190000)

# 614300 Pita Island / Humble Channel - L / chaney #76 (Pita Island) - L
d <- within(d, ColonyName[ColonyName == 'Pita Island / Humble Channel - L' | ColonyName == 'chaney #76 (Pita Island) - L'] <-'Pita Island/Humble Channel/chaney #76 - L')
d <- within(d, Latitude[ColonyName == 'Pita Island/Humble Channel/chaney #76 - L'] <- 27.6024630000)
d <- within(d, Longitude[ColonyName == 'Pita Island/Humble Channel/chaney #76 - L'] <- -97.2875600000)

# 614240 Causeway Islands - A / chaney #106 - A
d <- within(d, ColonyName[ColonyName == 'Causeway Islands - A' | ColonyName == 'chaney #106 - A'] <-'Causeway Islands/chaney #106 - A')
d <- within(d, Latitude[ColonyName == 'Causeway Islands/chaney #106 - A'] <- 27.6356790000)
d <- within(d, Longitude[ColonyName == 'Causeway Islands/chaney #106 - A'] <- -97.2353210000)

# 614240  Causeway Islands - B / chaney #107 - B
d <- within(d, ColonyName[ColonyName == 'Causeway Islands - B' | ColonyName == 'chaney #107 - B'] <-'Causeway Islands/chaney #107 - B')
d <- within(d, Latitude[ColonyName == 'Causeway Islands/chaney #107 - B'] <- 27.6437040000)
d <- within(d, Longitude[ColonyName == 'Causeway Islands/chaney #107 - B'] <- -97.2321720000)

# 614240 Causeway Islands - G / chaney #112 - G
d <- within(d, ColonyName[ColonyName == 'Causeway Islands - G' | ColonyName == 'chaney #112 - G'] <-'Causeway Islands/chaney #112 - G')
d <- within(d, Latitude[ColonyName == 'Causeway Islands/chaney #112 - G'] <- 27.6628020000)
d <- within(d, Longitude[ColonyName == 'Causeway Islands/chaney #112 - G'] <- -97.2270860000)

# 614240 Causeway Islands - J / chaney #115 - J
d <- within(d, ColonyName[ColonyName == 'Causeway Islands - J' | ColonyName == 'chaney #115 - J'] <-'Causeway Islands/chaney #115 - J')
d <- within(d, Latitude[ColonyName == 'Causeway Islands/chaney #115 - J'] <- 27.6767060000)
d <- within(d, Longitude[ColonyName == 'Causeway Islands/chaney #115 - J'] <- -97.2232580000)

# 614240 Causeway Islands - L / Kayak Island - L
d <- within(d, ColonyName[ColonyName == 'Causeway Islands - L' | ColonyName == 'Kayak Island - L'] <-'Kayak Island/Causeway Islands - L')
d <- within(d, Latitude[ColonyName == 'Kayak Island/Causeway Islands - L'] <- 27.6351027800)
d <- within(d, Longitude[ColonyName == 'Kayak Island/Causeway Islands - L'] <- -97.230138890)

# 614362 South Baffin Bay Island - A / chaney #20 - A
d <- within(d, ColonyName[ColonyName == 'South Baffin Bay Island - A' | ColonyName == 'chaney #20 - A'] <-'South Baffin Bay Island/chaney #20 - A')
d <- within(d, Latitude[ColonyName == 'South Baffin Bay Island/chaney #20 - A'] <- 27.2434120178)
d <- within(d, Longitude[ColonyName == 'South Baffin Bay Island/chaney #20 - A'] <- -97.4146118164)

# 614362 South Baffin Bay Island - B /   chaney #21 (rabbit) - B
d <- within(d, ColonyName[ColonyName == 'South Baffin Bay Island - B' | ColonyName == 'chaney #21 (rabbit) - B'] <-'South Baffin Bay Island/chaney #21 (rabbit) - B')
d <- within(d, Latitude[ColonyName == 'South Baffin Bay Island/chaney #21 (rabbit) - B'] <- 27.2466030121)
d <- within(d, Longitude[ColonyName == 'South Baffin Bay Island/chaney #21 (rabbit) - B'] <- -97.4141616821)

# 614222 Kennedy Causeway Islands - G / chaney #83 - G
d <- within(d, ColonyName[ColonyName == 'Kennedy Causeway Islands - G' | ColonyName == 'chaney #83 - G'] <-'Kennedy Causeway Islands/chaney #83 - G')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/chaney #83 - G'] <- 27.6517300000)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/chaney #83 - G'] <- -97.2615300000)

# 614222 Kennedy Causeway Islands - EE / New chaney #105 - EE
d <- within(d, ColonyName[ColonyName == 'New chaney #105 - EE' | ColonyName == 'Kennedy Causeway Islands - EE'] <-'Kennedy Causeway Islands/New chaney #105 - EE')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/New chaney #105 - EE'] <- 27.6494791800)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/New chaney #105 - EE'] <- -97.271700110)

# 614222 Kennedy Causeway Islands - U / chaney #97 - U
d <- within(d, ColonyName[ColonyName == 'chaney #97 - U' | ColonyName == 'Kennedy Causeway Islands - U'] <-'Kennedy Causeway Islands/chaney #97 - U')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/chaney #97 - U'] <- 27.6219030000)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/chaney #97 - U'] <- -97.2724060000)

# 614222 Kennedy Causeway Islands - Q / chaney #93 - Q
d <- within(d, ColonyName[ColonyName == 'Kennedy Causeway Islands - Q' | ColonyName == 'chaney #93 - Q'] <-'Kennedy Causeway Islands/chaney #93 - Q')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/chaney #93 - Q'] <- 27.6249070000)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/chaney #93 - Q'] <- -97.2727940000)

# 614222 Kennedy Causeway Islands - O / chaney #91 - O
d <- within(d, ColonyName[ColonyName == 'Kennedy Causeway Islands - O' | ColonyName == 'chaney #91 - O'] <-'Kennedy Causeway Islands/chaney #91 - O')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/chaney #91 - O'] <- 27.6289420000)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/chaney #91 - O'] <- -97.2701780000)

# 614222 Kennedy Causeway Islands - S / chaney #95 - S
d <- within(d, ColonyName[ColonyName == 'Kennedy Causeway Islands - S' | ColonyName == 'chaney #95 - S'] <-'Kennedy Causeway Islands/chaney #95 - S')
d <- within(d, Latitude[ColonyName == 'Kennedy Causeway Islands/chaney #95 - S'] <- 27.6255531311)
d <- within(d, Longitude[ColonyName == 'Kennedy Causeway Islands/chaney #95 - S'] <- -97.2763900757)

# 614222 others
# Laguna Shores - FF / Kennedy Causeway Islands - FF
#   These look like two different places even though they have the same colonycode and are ff.
#   Leave as is
# Kennedy Causeway Islands - I / chaney #85 (zig zag) - I
#   totally different islands. Leave as is. 
# Kennedy Causeway Islands - Y / chaney #101 - Y
#totally different islands. Leave as is. 

# 614140 - I have no idea what is going on w this colony group.
# There are West Nueces Bay 51 E and West Nueces Bay 51 W with the same colony code
# and colony letters. I'm not sure if the E is a typo or not
# (w and e are next to each other on the keyboard).

print("######################## Colony names matched across years ##########################")

############################################################################################
#################################### END ###################################################
############################################################################################