# Atlas of Breeding Sites for Waterbirds in the Northern Gulf of Mexico
R scripts to clean, reorganize, merge and export data from waterbird breeding surveys used in the Atlas of Breeding Sites for Waterbirds in the Northern Gulf of Mexico [[atlas address]].

The Atlas is an effort to map the breeding locations of coastal breeding waterbirds in the northern Gulf of Mexico from 2010-2022. The Atlas was developed to provide stakeholders in the region with a means to readily access the location and status (both recent and current) of sites used for breeding activities by a wide range of waterbirds (i.e., nearshore seabirds and wading birds). 
Species include nesting waterbirds common to the region, such as seabirds, herons and egrets. Data in the Atlas include natural sites, anthropogenic sites, and altered colony sites to provide as complete a representation of the breeding populations in the region as feasible, and also to demonstrate and document the broad range of habitat used within the region.  

The Atlas (spatial inventory) and Registry (data) compile the locations and estimates of nesting populations from Texas to Florida. This Atlas and Registry were created to fill a void for an updated and integrated regional repository. It is primarily intended to provide a tool that can be used in conservation planning for waterbird populations that utilize the coast in this region. We developed this product for local, state, and federal resource managers to aid in the development of regional conservation and management plans, to enhance our understanding of species phenology and distribution, and to evaluate important bird use areas. The Atlas may aid research scientists in the selection of study sites, the development of long-term monitoring plans, or assessing nest site fidelity. Ultimately, these data are needed by federal and state land managers who collectively are responsible for the management of the majority of the known seabird resources in the southeastern US.


    Files

- _1_Prepare_original_datasets_: Individual scripts to prepare local dataset for import and combining.
- _2_Combine_all_data_: Combines all local Atlas datasets into a single file; makes edits that are applicable across all datasets; outputs GEOJSON files for import into ArcGIS Online platform.
- _3_Prepare_data_summaries_: Scripts used for various summaries needed throughout the data wrangling process.

Original local datasets are available upon request to data providers.


    Background and objectives

The coastal zone of the northern Gulf of Mexico is a complex system of bays, estuaries, beaches, tidal marshes, and islands with substantial freshwater input. Stretching from the south Texas coast to the Florida Keys, these coastal habitats range from subtropical to temperate, and from xeric to mesic. The coastal zone also supports a diverse array of breeding nearshore seabirds (also often referred to as beach-nesting birds or colonial waterbirds) and wading birds, collectively referred to as 'waterbirds'. Most of these species are colonial and nest on islands, marshes, mainland beaches, or human-made structures. Although nest-site fidelity is common among these species, the dynamic nature of the coastal zone in the northern Gulf of Mexico (and elsewhere in the southeastern U.S.) can result in inter-annual shifts in the locations of colonies and in the existence, size, or stability of the islands or habitats that support them. Such changes can subsequently affect not only the location of breeding sites, but also the population size or structure, as well as likely foraging locations. Overlaid on this dynamic system is a stakeholder network responsible for management of these species and their breeding habitats that includes natural resource agencies from five states, multiple federal agencies, and numerous private organizations.  
 
In an effort to coordinate and facilitate the management and conservation of avian taxa throughout this wide range of habitats and across this complex network of stakeholders, the Gulf of Mexico Avian Monitoring Network (GoMAMN) released strategic monitoring guidelines. The guidelines included assessments of ecological drivers and management actions, and suggested approaches for long-term monitoring including the need for a spatial inventory of breeding sites. Currently, there is no single source of information for nesting sites of either seabirds or wading birds in the northern Gulf of Mexico that is current or readily accessible. Instead, information and data regarding the location and status of colonies in the northern Gulf of Mexico is scattered among numerous agencies and web locations and can be  difficult to source. 

The purpose of the Atlas is to provide a repository for breeding data for waterbirds in the region, including a spatial inventory and an associated Registry. The Atlas is primarily intended for use by local, state, federal, and NGO resource managers. Data from the Atlas may be used in the development of regional conservation and management plans, to enhance understanding of the distribution and status of waterbirds, to evaluate important bird use areas, as a reference or guide for response teams following a natural or anthropogenic stressor (e.g., hurricane, oil spill), as a tool for marine spatial planning, or to support the selection of study sites for research or the development of long-term monitoring plans. This Atlas complements the Seabird Colony Registry and Atlas of the Southeastern U.S. (Ferguson et al. 2018) and the recent development of a series of products that assess trends in waterbird abundance in the Atlantic Flyway (e.g., https://visualizebirds.shinyapps.io/shinyApp/). The development and structure of the Atlas was guided by a Technical Advisory Team (TAT) comprised of stakeholders from throughout the region.   


    Geographic and temporal scope

The Atlas includes and displays data for sites used by breeding waterbirds in Texas, Louisiana, Mississippi, Alabama, and the Gulf coast of Florida including the Florida Keys, located within the following habitat classifications of the National Oceanic and Atmospheric Administration's (NOAA) Coastal Change Analysis Program (C-CAP): estuarine forested wetland, estuarine scrub shrub wetland, estuarine emergent wetland, and estuarine aquatic bed. From a marine perspective, this area represents the Northern Gulf of Mexico and Floridian Ecoregions (Spalding et al. 2007). Administratively the study area is within the Gulf of Mexico Planning area for the Bureau of Ocean Energy Management; Regions two and four for the U.S. Fish and Wildlife Service; and the Gulf Coast, East Gulf Coastal Plain, and Atlantic Coast Joint Ventures. 

The Atlas includes data available from 2010-2022. The Methods section of the Atlas contains detailed information on the temporal range of data included for each state.
 

    Atlas sites and focal species
    
The TAT opted to develop the Atlas based upon 'location'. All breeding sites of waterbirds that were located within the four aforementioned habitat types of the C-CAP layer and were surveyed or monitored by one of the stakeholder groups, were considered for inclusion in the atlas. The Atlas primarily includes species referred to as seabirds, beach-nesting birds, and wading birds. A complete list of species is included in the Methods section of the Atlas. Note that some species of interest or conservation concern that also occur in the study area (e.g., American Oystercatcher, Piping Plover) were not included in the Atlas due to inconsistencies in data collection for these species among the many stakeholders.        

Waterbirds typically nest in large and sometimes dense colonies, but also may nest in small colonies or even solitarily. As traditional nesting sites on barrier islands and beaches have been lost to development, hardened structures, or sea level rise, these species also now nest in altered habitat (e.g., dikes, dredge spoil islands) or on anthropogenic structures (e.g., rooftops). Data in the Atlas include natural sites, anthropogenic sites, and altered sites to provide as complete a representation of the breeding populations in the region as feasible, and to demonstrate and document the broad range of habitat used within the region during the study period.  

    Atlas team

Patrick G.R. Jodice, U.S. Geological Survey South Carolina Cooperative Fish & Wildlife Research Unit, and Department of Forestry and Environmental Conservation, Clemson University, Clemson, SC. Email: pjodice@g.clemson.edu

Kathy Hixson, Department of Forestry and Environmental Conservation, and South Carolina Cooperative Fish & Wildlife Research Unit, Clemson University, Clemson, SC.

Yvan Satgé, Department of Forestry and Environmental Conservation, and South Carolina Cooperative Fish & Wildlife Research Unit, Clemson University, Clemson, SC.

Jeff Gleason, Gulf Restoration Office, U.S. Fish and Wildlife Service, Chiefland, FL.

