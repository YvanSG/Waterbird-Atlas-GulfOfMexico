## Atlas of Breeding Sites for Waterbirds in the Northern Gulf of Mexico - Methodology

This page provides details of the decisions and methodology used to create the Atlas.

### Table of Content

1.  [Characteristics of Atlas data](#data)
    a.  [Sites](#sites)
    b.  [Species](#species)
    c.  [Years](#years)
    d.  [Geographic scope](#geographic)
        i.  [States](#states)
        ii. [Footprint](#footprint)
    e.  [Metrics](#metrics)
2.  [Building the Atlas](#building)
    a.  [Datasets received](#receiving)
    b.  [Cleaning the data](#cleaning)
    c.  [Combining and unifying the data](#combining)
    d.  [Mapping the data](#mapping)
        i.  [Spatial datasets](#spatial)
        ii. [User interface](#ui)
3.  [Using the Atlas](#using)
    a.  [Category selectors](#selectors)
    b.  [Map](#map)
    c.  [Registry](#registry)
    d.  [Tables](#tables)
    e.  [Site list](#list)
    f.  [Site summary card](#%20card)
    g.  [Indices](#%20indices)
4.  [Registry attributes](#attributes)
5.  [References](#references)
6.  [Appendix](#appendix)
    a.  [Species list](#sp_list)
    b.  [R scripts](#scripts)

------------------------------------------------------------------------

### 	1. Characteristics of Atlas data{#data}
The Atlas was designed to provide spatial information on breeding sites of waterbirds. Although they are integral to the Atlas, population counts are provided as additional, site-specific information.

<br>

#### a. Sites {#sites}

Sites are the spatial representation of breeding locations of waterbirds that were surveyed by data providers. A breeding site was typically defined as an aggregation of breeding waterbirds (e.g., a colony), although some sites included a single pair or low number of pairs. Geographic coordinates for sites were provided by data providers. In general, sites were surveyed across multiple years and retained a constant location, although some sites moved slightly or disappeared entirely due to changes in local conditions (e.g. movements of sand bank, flooding, habitat modification). 

Surveys for breeding waterbirds were usually conducted annually by a recurring group of observers using the same list of site locations each year. This results in naming and location (i.e., geographic coordinates) consistency for a given site. However, in the case of the Florida Shorebird Database, the Florida Fish and Wildlife Conservation Commission (FWCC) relies on an extensive network of groups and individuals (i.e., citizen scientists) to conduct surveys at their own convenience and schedule. As a result, the geographic coordinates reported for a given site may vary among years depending on the surveyor. To address this particular issue, the FWCC calculated the centroid of all reported locations for a given nesting area. We use this centroid (derived from spatially-aggregated colony footprints) for locating sites within the Atlas.

<br>

#### b. Species {#species}

The coastal zone of the northern Gulf supports a diverse array of waterbirds. The Atlas includes those species for which breeding data were available within the spatial footprint of the Atlas(see [Geographic scope](#geographic)). A complete list of species is provided in Appendix 1 ([Table A1](#table_species)).

In most cases, data were provided to the species level. In some cases, however, data that were either more or less detailed than the species level were provided or needed. 
For example, Reddish Egrets were reported with details on their morphotype (dark or white morph). This was not, however, reported consistently across the Atlas footprint and this led to instances where, when summed, totals of morphs did not always match species-level totals. Therefore, we did not differentiate between morphotypes and included Reddish Egret at the species level only. {#REEG_morphs} 

There also were three groups of species for which distinguishing to the species level was difficult depending on survey conditions. For these, we classified observations as species groups instead of individual species. The pairings included Brown Noddy/Sooty Tern, Glossy Ibis/White-faced Ibis, and Royal Tern/Sandwich Tern.

Although other species of interest or conservation concern may breed at some of the sites within the Atlas footprint, we chose not to include them here due to inconsistencies in data collection among the data providers. These species were: American Oystercatcher, Black-necked Stilt, Limpkin, Snowy Plover, Willet, and Wilson's Plover. Similarly, we did not include American Coot and Common Gallinule. 

In the case of the Herring Gull, which typically does not nest in the Atlas footprint, we chose to keep two observations of single nests but we did not include observations of adults if they were not confirmed by records of nests. 

We also chose to not include waterbird species that do not breed within the Atlas footprint but that were recorded in the original datasets received from data providers as “Adult” or “Birds” (i.e., no record of breeding). These species were: American Avocet, American Bittern, Black-bellied Plover, Black Tern, Lesser Black-backed Gull, Marbled Godwit, Red Knot, Ring-billed Gull, Ruddy Turnstone, and Short-billed Dowitcher.

<br>

#### c. Years {#years}

The Atlas includes data made available to the Atlas team from 2010-2022. However, data providers followed their own survey schedule and no single year was surveyed by all data providers (see [Table 1](#table_years)). The years with the most coverage included 2011-2013, 2018, and 2020. The Alabama Department of Conservation & Natural Resources, FWCC, and the Texas Waterbird Society (TWS) provided data for all years. 

The Atlas provides a single population number for each species at each site for each survey year. However, due to specific survey methodologies, Audubon Delta and FWCC’s Florida Shorebird Database may have recorded multiple visits per year to a single site. In these cases, the population count provided in the Atlas corresponds to the maximum count of nests, pairs, or adults recorded during a given year. This is different from most other datasets where sites were only visited once per year, and the population count provided in the Atlas corresponds to a snapshot census. Details on the methodologies used by data providers may be found in the Registry, under attributes [Method_Nests](#meth_nest), [Method_Pairs](#meth_pairs), and [Method_Adults](#meth_adults).

<br>

###### **Table 1. Temporal availability of Atlas data.** {#table_years}

| Dataset                         | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 |
|------|------|------|------|------|------|------|------|------|------|------|------|------|------|
| Alabama Audubon                 |      |      |      |      |      |      |      |      | X    | X    | X    | X    | X    |
| Alabama DCNR                    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    |
| Audubon Delta                   |      | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    |
| DWH Regionwide TIG              | X    | X    | X    | X    |      | X    |      |      | X    |      |      | X    |      |
| Florida Rooftop Colony Database | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    |
| Florida Shorebird Database      | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    | X    |

<br>

#### d. Geographic scope {#geographic}

##### i. States {#states}

All five U.S. states bordering the Gulf of Mexico are included in the Atlas. Within states, the extent of surveys depends on local objectives and capacity.

Except for Louisiana, where data were compiled from aerial surveys lead by the Deepwater Horizon Regionwide Trustee Implementation Group (more information at [avianmonitoring.com](https://avianmonitoring.com/), population data in other States were collected during ground surveys. Specific methodologies may be obtained from data providers.

<br>

##### ii. Footprint {#footprint}

The Atlas includes waterbird breeding sites located within the following habitat classifications of the National Oceanic and Atmospheric Administration's Coastal Change Analysis Program (C-CAP): estuarine forested wetland, estuarine scrub shrub wetland, estuarine emergent wetland, and estuarine aquatic bed. This designation essentially limits the inland distribution of the study area and focuses the Atlas on the coastal zone, a stated objective of the Technical Advisory Team for the Atlas (TAT).

From a marine perspective, this area represents the Northern Gulf of Mexico and Floridian Ecoregions ([Spalding et al. 2007](https://doi.org/10.1641/B570707)). Administratively the study area is within the Gulf of Mexico Planning area for the Bureau of Ocean Energy Management; Regions II (Southwest) and IV (Southeast) for the U.S. Fish and Wildlife Service; and the Gulf Coast, East Gulf Coastal Plain, and Atlantic Coast Joint Ventures. 

To create the footprint, we considered using existing boundaries such as [EPA ecoregions](https://www.epa.gov/eco-research/ecoregions), the [RESTORE Act boundary](https://www.restorethegulf.gov/), and [Joint Venture boundaries](https://mbjv.org/joint-venture-map/) but these boundaries did not provide the level of detail necessary to distinguish between coastal and inland sites. We also considered four publicly available land classification datasets, each with a unique set of defined land cover classes: [National Land Cover Database](https://www.usgs.gov/centers/eros/science/national-land-cover-database), [LANDFIRE’s Existing Vegetation Type](https://landfire.gov/evt.php), [National Wetlands Inventory](https://www.fws.gov/program/national-wetlands-inventory/data-download) , and [C-CAP](https://coast.noaa.gov/digitalcoast/data/ccapregional.html). We did not use the National Land Cover Database because it did not distinguish between wetland types. We did not use LANDFIRE’s existing vegetation type because it was overly detailed for our purposes. Finally, while the National Wetlands Inventory and C-CAP classes appeared similar, we decided to use C-CAP because it is updated regularly, practitioners are likely to be familiar with it, and the Gulf Coast Joint Venture uses it most frequently.

We decided to use C-CAP’s three estuarine wetland classes (Estuarine Forested Wetland, Estuarine Scrub/Shrub Wetland, and Estuarine Emergent Wetland) but found that areas far inland may be erroneously classified as estuarine. Therefore, in ArcGIS, we used the [aggregate polygons](https://pro.arcgis.com/en/pro-app/latest/tool-reference/cartography/aggregate-polygons.htm) tool with an aggregation distance of 10 km to create the inland boundary. A 10-km distance resulted in a boundary that best suited the project’s needs of including coastal areas while not including areas far inland. 

To make a cut-off point to include Florida sites identified as being in the Gulf (and to exclude those on the state’s Atlantic coast), we identified a gap in the location of sites near Key Largo, FL. Therefore, we decided to trace the boundary in that area along US Route 1, a conveniently located existing line that is easily referenced. 

The Atlas’ inland boundary is visible as a purple line in the map. The footprint’s shapefile is available upon request.

<br>

#### e. Metrics {#metrics}

Not all data providers used the same, unique metric (e.g., nests, pairs, or adults) when reporting count data (see [Table 2](#table_sum)), nor was there consistency in the number of metrics reported. Among all data providers, the following metrics were used to provide count data: numbers of nests (75.3% of all observations), pairs (37.2%), adults (24.4%), birds (16.3%), chicks (1.1%), fledglings (1.5%), and “all birds” (all age classes; 0.3%). Based on the frequency of occurrence of each metric among all data sets, we decided to include the three metrics that best represented breeding activity; numbers of nests, pairs, and adults. 

Note that, within a single dataset, reported counts for different metrics may not be directly comparable. For example, FWCC’s Florida Shorebird Database includes the highest reported counts for nests and adults (reported as individuals, not pairs): these may, and often do, occur on different days. Before making comparisons between metrics, we suggest that users contact data providers to enquire if methodologies allow for such comparisons.

<br>

###### **Table 2. Distribution of observations reported in the Atlas.** An observation corresponds to a count for a combination of species/site/year/data provider. {#table_sum}

| Dataset                             | Observations | Pairs | Nests | Adults | Birds | Chicks | Fledglings | All age classes |
|--------|--------|--------|--------|--------|--------|--------|--------|--------|
| Alabama Audubon                     | 91           | 91    | 85    | 0      | 0     | 73     | 85         | 0               |
| Alabama DCNR                        | 165          | 165   | 0     | 0      | 0     | 0      | 0          | 0               |
| Audubon Delta                       | 438          | 94    | 340   | 8      | 0     | 62     | 182        | 0               |
| DWH Regionwide TIG                  | 5327         | 0     | 5327  | 0      | 5327  | 0      | 0          | 0               |
| Florida Rooftop Colony Database     | 852          | 0     | 0     | 852    | 0     | 0      | 0          | 0               |
| Florida Shorebird Database          | 1736         | 0     | 1736  | 1736   | 0     | 0      | 0          | 0               |
| Florida Wading Bird Colony Database | 15373        | 3357  | 12291 | 135    | 0     | 0      | 0          | 89              |
| Gulf Islands National Seashore      | 235          | 0     | 65    | 235    | 0     | 235    | 235        | 0               |
| Texas Waterbird Society    | 8559         | 8481  | 4834  | 5040   | 0     | 0      | 0          | 0               |
|                                     |              |       |       |        |       |        |            |                 |
| TOTAL                               | 32776        | 12188 | 24678 | 8006   | 5327  | 370    | 502        | 89              |
| Frequency of occurrence             | 100%         | 37.2% | 75.3% | 24.4%  | 16.3% | 1.1%   | 1.5%       | 0.3%            |

<br>

### 2. Building the Atlas {#building}

Given the scale of the coastal northern Gulf of Mexico and the number of stakeholders taking part in waterbird surveys, there was no consistent survey methodology used across the Atlas footprint. As a result, data are collected, digitalized, and managed differently by different stakeholders. 
Building the Atlas, therefore, required two primary steps. The [first step](#receiving) involved seeking and receiving datasets; cleaning and streamlining the data; and merging and unifying the data into a coherent structure, using a consistent methodology. We did all data formalizing and manipulations in R and kept annotated R scripts for future reference and reproducibility ([Appendix b](#scripts)).
Once the full dataset was unified into a [Registry](#registry), the [second step](#mapping) involved building the user interface in the ArcGIS Online environment. 
The main details of these steps are provided below.

<br>

#### a. Datasets received {#receiving}

We received a total of 42 datasets, in multiple format types: XLSX and CSV spreadsheets, PDF reports, Microsoft Word and PowerPoint documents, shapefiles, and scanned field datasheets ([Table 3](#table_received)). Spreadsheets usually contained whole datasets. In some cases, the coordinates of breeding locations were stored in independent spreadsheets although in such cases we were able to connect survey data and locations. In contrast, datasets that were not provided in tabular form (e.g., provided as a PDF report) required extensive data mining.

<br>

###### **Table 3. Types of datasets received for the Atlas. {#table_received}**

| Data provider                       | Number of files | File format(s)                  | Date received            | File type                    | Data mining | Data cleaning |
|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| Alabama Audubon                     | 6               | PDF, XLSX                       | 2023-02-28 to 2023-05-03 | Reports with survey data     | High        | Low           |
| Alabama DCNR                        | 1               | XLSX                            | 2023-08-08               | Survey data with coordinates | No          | Low           |
| Audubon Delta                       | 11              | DOCX, PDF, PPTX, SHP, XLSX      | 2023-03-16 to 2024-03-04 | Collection of documents      | Very high   | No            |
| DWH Regionwide TIG                  | 1               | XLSX                            | 2023-05-09               | Survey data with coordinates | No          | Low           |
| Florida Rooftop Colony Database     | 1               | XLSX                            | 2023-12-21               | Survey data with coordinates | No          | No            |
| Florida Shorebird Database          | 1               | XLSX                            | 2024-02-16               | Survey data with coordinates | No          | No            |
| Florida Wading Bird Colony Database | 1               | CSV                             | 2023-03-13               | Survey data with coordinates | No          | Very low      |
| Gulf Islands National Seashore      | 3               | XLSX                            | 2023-06-21               | Survey data with coordinates | No          | High          |
| Texas Waterbird Society    | 17              | Access Database, PDF, SHP, XLSX | 2022-09-27 to 2023-06-21 | Collection of documents      | Very high   | Very high     |

###### Data mining: the amount of work needed to gather data from files provided.

###### Data cleaning: the amount of work needed to clean or streamline the files provided.

<br>

#### b. Cleaning the data {#cleaning}

All datasets were reviewed prior to incorporation into the dataset structure. The extent of data cleaning or streamlining that was needed varied across data sets. Issues that needed to be addressed typically included double counts within datasets, erroneous and/or conflicting location coordinates across years, missing or conflicting location names across years, and swapped latitudes and longitudes. Details specific to each dataset may be found in the annotated [R scripts: 1_Prepare_original_datasets](#scripts_1).

<br>

#### c. Combining and unifying the data {#combining}

Once reviewed and cleaned, datasets provided basic survey information such as location name, location coordinates, survey year, species, count unit, and count. The subsequent step was to combine data sets into a coherent structure. Below, we describe the primary decision points that occurred during this process. Specific details may be found in the annotated [R scripts: 2_Combine_all_data](#scripts_2). 

-  **C-CAP footprint**: We kept only survey locations that occurred within the C-CAP footprint. Following methods described above (see [Footprint](#footprint)), we use an ad-hoc shapefile to filter out colonies that occurred beyond (i.e., inland of) the 10-km buffered C-CAP estuarine limit, or north of Key Largo, FL.

-  **Sites with multiple coordinates**: Some sites were recorded with more than one set of geographic coordinates, either because the same name was used for two distinct locations, because different sets of coordinates were used for a single site, or a combination of both occurred. We used our best judgement to resolve such issues: for example, when choosing between two sets of coordinates within a single islet we chose the set that had the most records; when choosing between two sets with the same name but on distinct islets, we renamed each islet with a categorizer (e.g., “North…” or “South…”); or if sites with questionable sets of locations corresponded to DWH Regionwide TIG datasets, we used the TIG dataset as a reference to make the distinction between sites. See R script [2_2_Match_colony_name_across_years.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_2_Match_colony_name_across_years.R) for details. 

-  **Species categories (including Reddish Egret morphs)**: As described above (see [Species](#species)), we included most but not all waterbird species reportedly breeding in the northern Gulf of Mexico (see [Appendix 1](#sp_list) for a complete list). In some datasets, Reddish Egrets were reported with details on their morphotype (dark or white morph). This level of detail was not consistent across the Atlas footprint; therefore we decided to not differentiate between morphotypes and included Reddish Egret at the species level only. See R script [2_3_Clean_ReddishEgret_morphs.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_3_Clean_ReddishEgret_morphs.R ) for details.

-  **Double counts within datasets**: In some cases (mostly in the Florida Wading Bird Colony Database), sites had more than one record per species per site per year, with different count values. This was often due to duplicate records with “presence”/”absence” information in methodology, and 1/0 values in metrics: in this case, we corrected “presence”/”absence” with -1/0 values in metrics (as described earlier), and deleted the records with “presence”/”absence”. In other cases, duplicate records had actual count data but, when different count units were reported, each unit was reported as an individual record. In these cases, we combined information into a single record. Finally, when duplicates were a result of multiple surveys occurring during the same year, we kept the maximum count for that year. See R script[2_4_Fix_Double_counts.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_4_Fix_Double_counts.R) for details.

-  **Double counts between datasets**: Surveys from the DWH Regionwide TIG (hereafter, TIG) sometimes overlapped temporally (same years) or geographically (same sites) with surveys conducted by other data providers (mainly TWS, Audubon Delta, Alabama Audubon, and FWCC). As a result, data are available from two sources for the same year for some sites (i.e., sites were surveyed more than once per year by two different data providers). If not remedied, these double surveys could result in double-counting issues in the Atlas because tables within the Atlas provide sums of counts over all datasets in a spatial selection. Because TIG surveys did not occur every year, we could not prevent double-counting by simply excluding TIG data from being used when summations were calculated. We also wanted to ensure that TIG data were included because they provide consistent information across years and States, and are the only data available for a large extent of the state of Louisiana. Therefore, instead of flagging the whole TIG dataset, we only flagged actual instances of double-counting (or “TIG overlap”). This allowed us to retain TIG data without the risk of inflating counts at certain colonies in certain years. In short, we accomplished this by adding a selection tool within the Atlas that allows the user to specify the use or exclusion of TIG data. We describe the details for how this was accomplished below.
To address TIG overlap, we created a new data column labeled "TIGDisplay" in which records to be displayed at the same time in the Atlas map (and summed in the Atlas Tables) were assigned a value of "together" and those to be displayed separately in two different maps, or with a specific button, were assigned a value of "separate". We first selected colonies that were within a 500-m distance: given the high spatial precision of TIG surveys, we considered sites beyond this threshold to be individual sites (and that could be displayed together). We then selected sites with same names in both overlapping datasets: sites with same names were assigned “separate” and sites with different names were assigned “together”. Finally, for all sites that were assigned “separate”, we checked temporal overlap: if no overlap existed (same location, same name but surveyed on different years), sites were reassigned “together”; otherwise, they remained assigned as “separate”. See R script [2_5_Manage_TIG_overlap.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_5_Manage_TIG_overlap.R) for details of the computing.

-  **Presence-only records**: In some instances, records were reported without counts but with a mention of breeding activity (reported as “present”, or “active”). We use the value “-1” to indicate that nests, pairs, or adults were present, but not counted. We chose a value of “-1” instead of “9999”, “-9999” or “-Inf” (as is sometimes used) because “-1” allows for simple flagging, sorting, and filtering in data tables while having limited impact on count totals that appear in Atlas tables. For example, Atlas tables display summed counts over spatial selections and numerical values of “9999” or "-9999" would have been included in those summations.

-  **Counts provided as ranges**: In some cases, counts were not provided as single numerical values but instead as ranges (e.g. “5-10” nests). Because counts must be in numerical format to allow for spatial summing, we replaced ranges by their midpoint value in the Atlas ”Nest”, “Pairs”, and “Adults” metrics. We archived the original count data in new dataset columns “OriginalNests”, “OriginalPairs”, “OriginalAdults” to ensure they are available if needed.

-   **Datasets with no Atlas metrics**: We flagged records that had counts of birds, chicks, fledglings, or any bird regardless of age class, but did not have any counts for the three Atlas metrics (Nests, Pairs, Adults). These do not appear in the Atlas but remain in the Registry, where they are flagged as “N” in column “HasAtlasMetric”. Therefore, although not displayed, these data remain available. 
 
-  **Unique code for sites**: To streamline computations and mapping, we created an Atlas-specific code used to identify individual sites. Individual sites are defined as having individual combinations of State, ProviderColonyName, coordinates, and DataProvider. For example, Pelican Island (Alabama; Pelican Island; 30.2414, -88.1241; Alabama Audubon) is coded  AL-0037 but Pelican Island (Louisiana; Pelican Island; 29.1437, -90.3475; DWH Regionwide TIG) is coded LA-1187.

-  **Survey methods**: If information on survey methods was not provided with the datasets, we specifically asked providers to describe their methodology or to choose from a list of typical methods ([Table 4](#table_methods)).

<br>

###### **Table 4. List of method descriptors used in the Atlas.** See [Registry attributes](#attributes) for more details. {#table_methods}

| Method                 | SurveyVantagePoint                           |
|------------------------|----------------------------------------------|
| Approximate count      | Adjacent                                     |
| Direct count           | Ground - Perimeter                           |
| Estimated count        | Ground - Unknown method                      |
| Maximum reported count | On-site visit                                |
| Minimum reported count | View from adjacent area by vehicle/boat/foot |
| NA \*\*\*              | NA \*\*\*                                    |

###### \* Method used by Data Provider to estimate the number of adults in observation. NA = no method was provided.

###### \*\* Method used by Data Provider to perform the survey of other metrics reported in observation. NA = no method was provided.

###### \*\*\* No method reported

<br>

#### d. Mapping the data {#mapping}

Following recommendations made during the Technical Advisory Team Meeting in Lafayette, Louisiana, in June 2022, we opted to use the ArcGIS Online (AGOL) environment for the Atlas platform. Unlike other online GIS platforms (e.g. Carto, MangoMap, custom Javascript), AGOL has the advantages of being already widely adopted by stakeholders (including by USFWS, FWCC, TWS, and the Water Institute), and provides an environment of nested applications allowing direct integration of spatial data into a user interface.

##### i. Spatial datasets{#spatial} 

Once the data were collated into a clean, coherent structure (the [Registry](#registry)), we then transformed data to fit AGOL requirements. Although it is possible to transform the datasets in AGOL using online coding ([data expressions]( https://doc.arcgis.com/en/dashboards/latest/get-started/create-data-expressions.htm)), we chose instead to do this in R because R is widely used, free software with open source scripts that allows ease of reproducibility (version control). R scripts created for the Atlas are available at this link: [2_6_Create_ArcGIS_datasets.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_6_Create_ArcGIS_datasets.R). 

We created three distinct versions of the main [Registry](#registry) dataset (Table 5). To preserve formatting, each dataset is imported in AGOL in GeoJSON format.

<br>

###### **Table 5. Spatial datasets created for the ArcGIS Online platform.**

| Dataset            | Output.file                      | AGOL.file.name                                                    | Atlas.usage                              |
|------------------|------------------|-------------------|------------------|
| Full dataset       | Atlas_GIS_full.GeoJSON           | GoM Waterbird Atlas_Full dataset_Selectable sites                 | Map, Category selectors, Species index   |
| Horizontal dataset | Atlas_GIS_horizontal.GeoJSON     | GoM Waterbird Atlas_Horizontal dataset_Tables                     | Tables                                   |
| Summary dataset    | Atlas_GIS_summary.GeoJSON        | GoM Waterbird Atlas_Summary dataset_Site list and Site cards      | Site list, Site summary card, Site index |
| Footprint          | ccap_estuarine_boundary_line.shp | GoM Waterbird Atlas_Atlas footprint_C-CAP estuarine boundary line | Map                                      |
| TIG flightlines    | TIG_flightpaths.shp              | GoM Waterbird Atlas_DWH Regionwide TIG flightpaths                | Map                                      |

<br>

-   **Full dataset**: This dataset only keeps records with Atlas metrics (i.e., with counts of Nests, Pairs, and Adults) and pivots the main dataset into a "long" format (based on Metrics; [Table 6](#table_full). The full dataset is used in the Atlas' category selectors, map, and species index.

<br>

###### **Table 6. Sample of "full" spatial dataset.** {#table_full}

| AtlasSite<br>Code | Data<br>Provider  | Provider<br>Colony<br>Name | Latitude | Longitude | State | Year | Identified<br>\_to_species | Species      | HasAtlas<br>Metric | ... | TIG<br>Display | Metric | Count | Metric<br>Code | Zero |
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| TX-1822           | [Data Provider 1] | [Site 1]                   | 27.xxxx  | -97.xxxx  | Texas | 2010 | yes                        | Caspian Tern | Y                  | ... | together       | Pairs  | 7     | 2              | N    |
| TX-1822           | [Data Provider 1] | [Site 1]                   | 27.xxxx  | -97.xxxx  | Texas | 2010 | yes                        | Caspian Tern | Y                  | ... | together       | Nests  | 3     | 1              | N    |
| TX-1822           | [Data Provider 1] | [Site 1]                   | 27.xxxx  | -97.xxxx  | Texas | 2010 | yes                        | Caspian Tern | Y                  | ... | together       | Adults | 7     | 3              | N    |
| TX-1822           | [Data Provider 1] | [Site 1]                   | 27.xxxx  | -97.xxxx  | Texas | 2011 | yes                        | Caspian Tern | Y                  | ... | together       | Pairs  | 4     | 2              | N    |
| TX-1822           | [Data Provider 1] | [Site 1]                   | 27.xxxx  | -97.xxxx  | Texas | 2011 | yes                        | Caspian Tern | Y                  | ... | together       | Adults | 5     | 3              | N    |

<br>

-   **Horizontal dataset**: This dataset only keeps records with Atlas metrics (i.e., with counts of Nests, Pairs, and Adults) and transforms the data to the "wide" format (based on Year; [Table 7](#table_horiz)). The horizontal dataset is used in the Atlas' tables.

<br>

###### **Table 7. Sample of "horizontal" spatial dataset.** {#table_horiz}

| AtlasSite<br>Code | Data<br>Provider  | Provider<br>Colony<br>Name | Latitude | Longitude | State   | Species       | TIG<br>Display | Metric | Metric<br>Code | Zero | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| AL-0001           | [Data Provider 1] | [Site 1]                   | 30.xxxx  | -87.xxxx  | Alabama | Black Skimmer | together       | Nests  | 1              | N    |      |      |      |      |      |      |      |      |      |      | 1    |      |      |
| AL-0001           | [Data Provider 1] | [Site 1]                   | 30.xxxx  | -87.xxxx  | Alabama | Black Skimmer | together       | Pairs  | 2              | N    |      |      |      |      |      |      |      |      |      |      | 1    |      |      |
| AL-0001           | [Data Provider 1] | [Site 1]                   | 30.xxxx  | -87.xxxx  | Alabama | Least Tern    | together       | Nests  | 1              | N    |      |      |      |      |      |      |      |      |      | 124  |      |      |      |
| AL-0001           | [Data Provider 1] | [Site 1]                   | 30.xxxx  | -87.xxxx  | Alabama | Least Tern    | together       | Nests  | 1              | N    |      |      |      |      |      |      |      |      |      |      | 8    |      |      |
| AL-0001           | [Data Provider 1] | [Site 1]                   | 30.xxxx  | -87.xxxx  | Alabama | Least Tern    | together       | Nests  | 1              | N    |      |      |      |      |      |      |      |      |      |      |      | 56   |      |

<br>

-   **Summary dataset**: This dataset only keeps information about sites (coordinates, name, state, data provider, other available metrics, etc.), and associated metadata (contact, reference) and collates them into site-specific summaries (based on unique AtlasSiteCode; [Table 8](#table_summary)). The summary dataset is used in the Atlas' site list, site summary card, and site index.

<br>

###### **Table 8. Sample of "summary" dataset.** {#table_summary}

| AtlasSite<br>Code | Provider<br>Colony<br>Name | State   | Latitude | Longitude | Number_of<br>\_species | Years            | Species                                                    | Providers         | Contacts                                                                          | Atlas<br>Metrics     | Other<br>Metrics | Methods<br>\_Nests     | Methods<br>\_Pairs     | Methods<br>\_Adults | Methods<br>\_Other | TIG      | Zero | Reference     |
|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
| TX-1338           | [Site 1]                   | Texas   | 28.xxxx  | -96.xxxx  | 6                      | 2010; 2013; 2022 | Black Skimmer; Caspian Tern; Forster's Tern; Laughing Gull | [Data provider 1] | Contact 1 ([Contact1\@email.com](mailto:Contact1@email.com){.email}, Institution) | Nests, Pairs, Adults |                  |                        | Maximum reported count |                     |                    | together | N,Y  | [Reference 1] |
| FL-0051           | [Site 2]                   | Florida | 25.xxxx  | -80.xxxx  | 11                     | 2016; 2017       | Roseate Spoonbill; Snowy Egret                             | [Data provider 2] | Contact 2 ([Contact2\@email.com](mailto:Contact2@email.com){.email}, Institution) | Nests                |                  | Maximum reported count |                        |                     |                    | together | N,Y  |               |

<br>

-  **Atlas footprint**: We computed the inland boundary of the Atlas by merging the three estuarine wetland classes (Estuarine Forested Wetland, Estuarine Scrub/Shrub Wetland, and Estuarine Emergent Wetland) from the C-CAP raster. In ArcGIS, we then used the [aggregate polygons](https://pro.arcgis.com/en/pro-app/latest/tool-reference/cartography/aggregate-polygons.htm) tool with an aggregation distance of 10 km to create the inland boundary. We cut off the boundary between the Gulf and Atlantic along U.S. Route 1 near Key Largo, FL. 

-  **DWH Regionwide TIG flightpaths**: DWH Regionwide TIG provided data collected during aerial surveys. The footprint of the dataset varied from year to year; therefore, we decided to show the flightpaths of the aerial surveys alongside the site locations. We received the tracklines as a collection of KMZ files (one file per surveyed year). We imported those in QGIS using "Import KML/KMZ" tool, and extracted the description using "Expand HTML description field" tool, both in the "[KML Tools](https://github.com/NationalSecurityAgency/qgis-kmltools-plugin)" plugin. We then exported the resulting layer as an SHP layer. In R, we merged all layers into a single file, with survey year as attribute. The R scrip may be found at this link: [1_Gulfwide_TIG_Flightpaths.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/tree/main/1_Prepare_original_datasets).

<br>

##### ii. User interface {#ui}

Atlas users can affect what data are displayed in the [Map](#map), [Tables](#tables), [Site List](#list), [Site Summary card](#card), [Indices](#indices), and [Registry](#indices). A tutorial on how to use the Atlas is available by clicking on the blue pin button in the Atlas’ left-hand bar ([<img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/location-dot.svg" width="20"weight="20"/>](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views= Welcome)). Here, we provide details on the underlying architecture of the user interface. 

The AGOL architecture builds upon geospatial files ([hosted feature layers](https://doc.arcgis.com/en/arcgis-online/reference/feature-layers.htm)) that are mapped into a [Web Map](https://doc.arcgis.com/en/arcgis-online/reference/what-is-web-map.htm). In the case of the Atlas, the web map is then called into a [Dashboard](https://doc.arcgis.com/en/dashboards/latest/get-started/what-is-a-dashboard.htm) element, where spatial data stored in the feature layers are accessed and manipulated through Category Selectors, Tables, Lists, and Indices to display the information requested by the user. 

The Dashboard itself is called into an [Experience Builder](https://doc.arcgis.com/en/experience-builder/latest/get-started/what-is-arcgis-experience-builder.htm) element that serves as the interactive wrapping for the user interface. All these nested elements form the Atlas platform.

Although it is possible to access and manipulate data in Experience Builder elements, we opted to use a Dashboard because it allowed for more flexibility and control over the type of data interactions needed for the Atlas. For example, Dashboard tools such as [Category Selectors](#selectors) are not readily available in Experience Builder. In contrast, Experience Builder is designed as a custom application design program and can accommodate several pages within the same application (e.g. the Atlas page, and this Methodology page).

Decisions about the Dashboard tools used in the Atlas are detailed below ([3. Using the Atlas](#using)).

<br>

### 3. Using the Atlas {#using}

Atlas users can affect what data are displayed in the [Map](#map), [Tables](#tables), [Site List](#list), [Site Summary card](#card), [Indices](#indices), and [Registry](#indices). A tutorial on how to use the Atlas is available by clicking on the blue pin button in the Atlas’ left-hand bar ([<img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/location-dot.svg" width="20"weight="20"/>](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views= Welcome)). Here we provide details on the decisions that we made when designing the Atlas user interface.

<br>

#### a. Category selectors {#selectors}

The primary objective of the Atlas is to provide a coherent structure to map sites used by breeding waterbirds in the northern Gulf of Mexico. We also designed the Atlas in such a way as to give users the opportunity to filter the data based on their own needs, preferences, or objectives. 

-  [**Category selectors**](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views=CategorySelectors) may be used to filter through waterbird species, survey years, State, or data providers. These selectors are inclusive and multiple selections may be made at once. The list of options within a selector is fixed and Category selectors do not affect each other: for example, choosing State = Texas in the *State* selector will still list Data Providers from other, unselected States in the *Data Provider* selector. Note that, for Florida, we list three independent datasets which were all provided by FWCC.

-  [**Overlapping TIG surveys**](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views=TIG): DWH Regionwide TIG aerial surveys may overlap with terrestrial surveys in space and time (same sites surveyed during the same years). To avoid double-counts, TIG surveys that overlap with terrestrial surveys are not shown in the Map by default.  Enabling *Overlapping TIG surveys* will overrule this and show **all** TIG surveys, as well as available flight paths, overlaid on other datasets. Note that *enabling TIG surveys will create double-counts in Nests Tables* (but not other tables, as DWH Regionwide TIG only provided data with the Nests metric ([Table 2] (#table_sum)). See [2.c. Combining and unifying the data](#combining) above for details on how we identified overlapping sites. 

-  [**Presence/Absence**](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views=PresenceAbsence): By default, both presence (counts ≠ 0) and absence data (counts = 0) are displayed in the Atlas. Using this selector, it is possible to select only one of these categories. This will affect the Map, Registry, and Tables. In Tables, empty cells represent years when **no data** (whether presence or absence) were collected. Note that presence-only (when a species was present but no population count was recorded) is displayed with a count of **-1** in the Tables. See [3.d. Tables](#tables) and [Table 9](#table_values) for additional details.

<br>

#### b. Map {#map}

The [Map](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views=Map_selection) serves as the spatial visualization for the Atlas. It displays the location of all Atlas sites and can be filtered through [Category Selectors](#selectors).

-  **Sites**: Sites are represented by filled color circles, with colors corresponding to Data Providers. Sites may overlap: when that is the case, only the site in the top layer will be visible on the Map but, when selected, any overlapping sites will be listed in the [Site List]{#list}. Upon filtering, selected sites will be visible and clickable on the map; for reference, the locations of all the other sites (that were filtered out) will remain as grey, un-clickable circles. 
-  **Selection**: Sites can be selected individually (by a simple click) or as a group (using rectangle or lasso selection tools). Once a selection is made: the *Map/Selection* Tables update with total counts for that selection (see [Tables](#tables) below for more information); the [Site List]{#list} updates with the names of sites in the selection; and the [Site and Species Indices](#indices) update with the number of individual sites and individual species surveyed in the selection.
-  **Tools**:  Tools may be used to enhance the map experience: 
    -   Search bar: can be used to search physical locations and addresses. Sites can be searched in the [Site List](#list);
    -   Bookmarks: switches the maps' extent;
    -   Legend: lists visible layers;
    -   Basemaps: provides a list of available basemaps.

<br>

#### c. Registry {#registry}

The [Registry](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views=Registry) stores all the data provided by data providers, including data not displayed in the Atlas (such as additional count units and methods, provider subcolony name and code, notes, breeding status, etc.). The Registry can be filtered using the same filters as used for the Atlas (Category Selectors, Map selection, Site List selection); reciprocally, selecting sites in the Registry affects the Map, Tables, and Site List.

<br>

#### d. Tables {#tables}

Two types of [Tables](https://experience.arcgis.com/experience/ec2a9f88f0154772aed8f249796dde0b/?dlg=Tour&views=Tables) (*Map/Selection* and *Site*) are available in three metrics (i.e. count units: number of nests, pairs, or adults). Metrics depend on data providers, as not all providers used the same metrics (see [1.e. Metrics](#metrics) for more details). Values in the Tables correspond to a species count, presence-only (-1), absence (0), or no data (empty cell): see [Table 9](#table_values) for details.

-   ***Map/Selection*** **tables**: These tables display the sums of counts across all sites in the Map (when no site is selected) or across all selected sites. These sums are rounded (see **Note** 1 above). By default, the *Map/Selection* tables display summed counts for the whole study area. By using Category Selectors, or selecting sites in the Map or Registry, these tables can be updated to display summed counts for those particular selections. Selecting a species in a *Map/Selection* table will display on the Map the sites that contributed to the summed counts in that table.

-   ***Site*** **tables**: These tables provide counts at a single site, and this only when a site is selected in the **Site List**. These count numbers have **not** been rounded. By default, *Site* tables do not show any data. They must be activated by selecting a site in the Site List. Metric-specific *Site* tables may not display any data if data providers did not collect data using that metric. Selecting a species in a *Site* table will display the other sites where that species was surveyed on the map.

**Note 1**: Count numbers in *Map/Selection* tables have been rounded as follows: Values $\lt$ 100 were not rounded; values $\geq$ 100 and $\lt$ 1000 were rounded to the nearest ten; and values $\geq$ 1000 were rounded to the nearest hundred. After discussion with the TAT, the decision was made to round values to discourage users from over-interpreting count data and performing analyses that may not be warranted given the unknown accuracy of much of the data (e.g., performing trend analyses). The original count data remain in the Registry.

**Note 2**: In Florida, data (i.e., counts) may include re-nesting if a colony moved sites during a given year: counts in these tables should be taken as an estimation of total numbers of nests, pairs, or adults across the area.
Before using the numbers provided in the Tables, users should read the Atlas methodology and contact data providers.

<br>

###### **Table 9. Type of values used in Tables.** {#table_values}

| Value        | Meaning                                  |
|:-------------|:-----------------------------------------|
| Count ≠ 0    | Species present (count provided)         |
| -1           | Species present only (no count provided) |
| 0            | Species absent                           |
| [empty cell] | No data provided                         |

<br>

#### e. Site list

The **Site List** displays the State, name, data provider, and Atlas Site Code of each individual site. It is ordered by alphabetical order of States, then site names, and it is searchable. When a site is selected, it flashes in pink on the Map, and the Site Tables and Site Summary Card are updated. The List can be filtered using Category Selectors, the Map, and the Registry.

<br>

#### f. Site summary card {#card}

**Site Summary Cards** display information about each individual site: e.g. site name, State, coordinates, data provider, number and list of species surveyed, years surveyed, available survey metrics, etc. Cards may be accessed directly by using the arrows to flip through the cards, by selecting sites in the Map or Registry, or by selecting a single site in the Site List.

<br>

#### g. Indices {#indices}

Two indices provide the number of sites and individual species surveyed in the Atlas (default: 1,747 sites, and 42 species) or in a Map selection. Note that, if a site is directly selected in the Site List, the indices do not update; however, the number of species surveyed at that site is available in the site's Summary Card.

<br>

### 4. Registry attributes {#attributes}

-   **AtlasIndex**: Atlas-defined index used to identify individual observations ( = rows). 

-   **AtlasSiteCode**: Atlas-defined code used to identify individual sites. Individual sites are defined as having individual combinations of State, ProviderColonyName, coordinates, and DataProvider. 

-   **DataProvider**: Name of data provider.

-   **ProviderColonyName**: Original name given by a Data Provider to a site. 

-   **Latitude**: (Decimal degrees) Latitude of site.

-   **Longitude **: (Decimal degrees) Longitude of site.

-   **State**: Name of State in which a site is located.

-   **Year**: Year of data collection.

-   **Identified_to_species**:  (yes/no) Whether the observation corresponds to a bird identified to the species level (‘yes’) or to a genus/multi-genus level (‘no’; see “Species”, e.g. Royal Tern/Sandwich Tern). 

-   **Species**: Name of species for which data were collected. Three genus/multi-genus groups were used when distinction between species was not feasible:  ‘Ibis, Glossy or White-faced’; ‘Tern, Royal or Sandwich’; ‘Tern, Sooty or Brown Noddy’. See full species list in [Table A1](#table_species).

-   **HasAtlasMetric**: (Y/N) Whether the data were provided using a metric from the Atlas  (‘Y’: numbers of nests, pairs, or adults) or using a different metric (‘N’: numbers of birds, chicks, or fledglings; or number of birds regardless of age class). 

-   **Nests**: Atlas-specific metric. Number of nests in observation. 0 = no nest was observed; -1 = nests were present but not counted; NA = this metric was not used. This number may have been modified to conform to Atlas methodologies; original data provided by Data Providers have been retained: see “OriginalNests”.

-   **Pairs**: Atlas-specific metric. Number of pairs in observation. 0 = no pair was observed; -1 = pairs were present but not counted; NA = this metric was not used. This number may have been modified to conform to Atlas methodologies; original data provided by Data Providers have been retained: see “OriginalPairs”.

-   **Adults**: Atlas-specific metric. Number of adults in observation. 0 = no adult was observed; -1 = adults were present but not counted; NA = this metric was not used. This number may have been modified to conform to Atlas methodologies; original data provided by Data Providers have been retained: see “OriginalAdults”.

-   **Birds**: Number of birds provided for this observation. 0 = no bird was observed; NA = this metric was not used.

-   **All.birds_ad_juv**: Total number of birds (regardless of age class) provided for this observation. 0 = no bird was observed; NA = this metric was not used.

-   **Chicks**: Number of chicks provided for this observation. 0 = no chick was observed; NA = this metric was not used.

-   **Fledglings**: Number of fledglings provided for this observation. 0 = no fledgling was observed; NA = this metric was not used.

-   **OriginalNests**: Original number of nests provided by the Data provider in observation. Present = nests were present but not counted; NA = this metric was not used.

-   **Method_Nests**: Method used by Data Provider to estimate the number of nests in observation. NA = no method was provided.

-   **SurveyVantagePoint_Nests**: Method used by Data Provider to perform the survey of nests in observation. NA = no method was provided.

-   **OriginalPairs**: Original number of pairs provided by the Data provider in observation. Present = pairs were present but not counted; NA = this metric was not used.

-   **Method_Pairs**: Method used by Data Provider to estimate the number of pairs in observation. NA = no method was provided.

-   **SurveyVantagePoint_Pairs**: Method used by Data Provider to perform the survey of pairs in observation. NA = no method was provided.

-   **OriginalAdults**: Original number of adults provided by the Data provider in observation. Present = adults were present but not counted; NA = this metric was not used.

-   **Method_Adults**: Method used by Data Provider to estimate the number of adults in observation. NA = no method was provided.

-   **SurveyVantagePoint_Adults**: Method used by Data Provider to perform the survey of adults in observation. NA = no method was provided.

-   **Method_Others**: Method used by Data Provider to estimate the number of other metrics reported in observation. NA = no method was provided.

-   **SurveyVantagePoint_Others**: Method used by Data Provider to perform the survey of metrics other than the three primary metrics of the Atlas. NA = no method was provided.

-   **SurveyDate**: Calendar date of survey. 

-   **ProviderColonyCode**: Provider-defined code used to identify survey sites. Used by Florida Rooftop Colony Database, and Texas Waterbird Society only.

-   **ProviderSubcolony**: (TRUE/FALSE) Provider-defined code used to identify the presence of subcolonies within a survey site. Used by Texas Waterbird Society only.

-   **ProviderAtlasNumber**: Provider-defined code used to identify survey sites. Used in Florida Wading Bird Colony Database only.

-   **ProviderNotes**: Survey notes provided by Data Providers. 

-   **ProviderColonyStatus**: Activity status of site surveyed in observation. Used by Texas Waterbird Society only.

-   **DateReceived**: Calendar date when data were received by Atlas compilers.

-   **AtlasFileName**: Name of file provided by Data Providers to Atlas compilers.

-   **DataContact1**: Name of first point of contact for data in observation.

-   **DataContact2**: Name of second point on contact for data in observation.

-   **DataContactEmail1**: Email of first point of contact for data in observation.

-   **DataContactEmail2**: Email of second point of contact for data in observation.

-   **DataContactAffiliation1**: Affiliation of first point of contact for data in observation.

-   **DataContactAffiliation2**: Affiliation of second point of contact for data in observation.

-   **TIGDisplay**: (separate/together) Atlas-specific categorizer used to display DWH Regionwide TIG data overlapping with other datasets.

<br>

### 5. References {#references}

Alabama Audubon. 2023. Alabama Coastal Bird Stewardship Program: Study Areas.

Alabama Audubon Coastal Bird Stewardship Program. 2023. <https://alaudubon.org/research>

Alabama Department of Conservation and Natural Resources. 2010-2022. Division of Wildlife and Freshwater Fisheries --- Nongame Wildlife Program. <https://www.outdooralabama.com/about-us/wildlife-and-freshwater-fisheries-division>

Audubon Delta. 2023. Final Programmatic Report Narrative. Prepared for National Fish and Wildlife Foundation.

Barnes, K.B., C. Lill, and E.I. Johnson. 2023. Louisiana's Coastal Bird Stewardship Program: 2022 Final Report. National Audubon Society, Baton Rouge, LA.

Barnes, K.B., C. Lill, and E.I. Johnson. 2022. Louisiana's Coastal Bird Stewardship Program: 2021 Final Report. National Audubon Society, Baton Rouge, LA.

Barnes, K.B. and E.I. Johnson. 2021. Louisiana's Coastal Bird Stewardship Program: 2019-2020 Final Report. National Audubon Society, Baton Rouge, LA.

Cobb, S. D., O. A. Morpeth, L. M. Koczur. 2020. Alabama Audubon Coastal Conservation Programs 2020 Report.

Cobb, S., O. Morpeth, F. Batchelor, and L. Koczur. 2021. Alabama Audubon Coastal Conservation Programs 2021 Report.

Darrah, A. 2017. Round Island Restoration Area -- Preliminary Bird Surveys. Mississippi Coastal Bird Stewardship Program. PowerPoint presentation.

Darrah, A. and T. Guida. 2021. Audubon Mississippi Coastal Program -- 2020 Breeding Season Summary. Prepared for Mississippi Department of Environmental Quality and National Fish and Wildlife Foundation.

Darrah, A. and T. Guida. 2022. Audubon Mississippi Coastal Program -- 2021 Breeding Season Summary. Prepared for Mississippi Department of Environmental Quality and National Fish and Wildlife Foundation.

Darrah, A., C. Stempien, and T. Guida. 2022. Audubon Delta: Mississippi Coastal Program -- 2022 Breeding Season Summary.

Deepwater Horizon Regionwide Trustee Implementation Group. 2023. Avian Data Monitoring Portal. <https://www.avianmonitoring.com>

Deepwater Horizon Louisiana Trustee Implementation Group. 2023. Guidance for Coastal Ecosystem Restoration and Monitoring to Create or Improve Bird-Nesting Habitat. Baton Rouge, Louisiana. Florida Fish and Wildlife Conservation Commission Research Institute. 2023. Wading Bird database. <https://myfwc.com/research/>

Florida Shorebird Database. 2023. Online tool for entering and exploring data on Florida's shorebirds and seabirds, developed and maintained by the Florida Fish and Wildlife Conservation Commission. <https://app.myfwc.com/crossdoi/shorebirds/>

Johnson, E.I. 2016. Louisiana's Coastal Bird Stewardship 2015 Annual Report: Beach-nesting Bird Protection, Monitoring, and Community Outreach. National Audubon Society, Baton Rouge, LA.

Johnson, E.I. 2017. Louisiana's Coastal Stewardship Program: 2017 Final Report to American Bird Conservancy. National Audubon Society, Baton Rouge, LA.

Johnson, E.I. 2019. Louisiana's Coastal Bird Stewardship Program: 2018 Final Report - Elmer's Island Wildlife Refuge. National Audubon Society, Baton Rouge, LA.

Johnson, E.I. 2019. Louisiana's Coastal Bird Stewardship Program: 2018 Final Internal Report to Rockefeller State Wildlife Refuge. National Audubon Society, Baton Rouge, LA.

Johnson, E.I., K. Ray, and S. Collins. 2017. Louisiana's Coastal Bird Stewardship Program: 2016 Final Report. National Audubon Society, Baton Rouge, LA.

Koczur, L. M. and E. Rhodes. 2019. Alabama Audubon Coastal Conservation Programs 2019 Report.

Koczur, L. M., S. D. Cobb, O. A. Morpeth, N. Love. 2020. Alabama Coastal Bird Stewardship Program: 2017-2020 Report.

Morpeth, O., R. Rolland, C. Weatherby, F. Batchelor, and L. Koczur. 2023. Alabama Coastal Bird Stewardship Program: 2022 Report.

Pacyna, S. and A. Darrah. 2017. Audubon Mississippi Coastal Bird Stewardship -- 2017 Colonial Breeding Birds Monitoring.

Pacyna, S. and A. Darrah. 2019. Audubon Mississippi Coastal Programs -- SRP-013-19 Summary. Prepared for the Mississippi Department of Marine Resources.

Texas Waterbird Society. 2023. Maps and Data Portal. <https://www.texaswaterbirds.org/data>

<br>

### 6. Appendix {#appendix}

#### a. Species list {#sp_list}

<br>

###### **Table A1. List of species and species groups included in the Atlas.** {#table_species}

| Common.name                 | Scientific.name                        | Comments                         |
|--------------------|----------------------------|------------------------|
| American white pelican      | *Pelecanus erythrorhynchos*            |                                  |
| Anhinga                     | *Anhinga anhinga*                      |                                  |
| Black skimmer               | *Rynchops niger*                       |                                  |
| Black-crowned night-heron   | *Nycticorax nycticorax*                |                                  |
| Bridled tern                | *Onychoprion anaethetus*               |                                  |
| Brown noddy                 | *Anous stolidus*                       |                                  |
| Brown pelican               | *Pelecanus occidentalis*               |                                  |
| Caspian tern                | *Hydroprogne caspia*                   |                                  |
| Cattle egret                | *Bubulcus ibis*                        |                                  |
| Chandeleur gull             | *Larus argentatus x Larus dominicanus* | Hybrid of Herring and Kelp gulls |
| Common tern                 | *Sterna hirundo*                       |                                  |
| Double-crested cormorant    | *Phalacrocorax auritus*                |                                  |
| Forster's tern              | *Sterna forsteri*                      |                                  |
| Glossy ibis                 | *Plegadis falcinellus*                 |                                  |
| Great blue heron            | *Ardea herodias*                       |                                  |
| Great white heron           | *Ardea herodias*                       | Form of Great blue heron        |
| Great egret                 | *Ardea alba*                           |                                  |
| Green heron                 | *Butorides virescens*                  |                                  |
| Gull-billed tern            | *Gelochelidon nilotica*                |                                  |
| Herring gull                | *Larus argentatus*                     |                                  |
| Ibis, Glossy or White-faced |                                        |                                  |
| Laughing gull               | *Leucophaeus atricilla*                |                                  |
| Least Bittern               | *Ixobrychus exilis*                    |                                  |
| Least tern                  | *Sternula antillarum*                  |                                  |
| Little blue heron           | *Egretta caerulea*                     |                                  |
| Magnificent frigatebird     | *Fregata magnificens*                  |                                  |
| Masked booby                | *Sula dactylatra*                      |                                  |
| Neotropic cormorant         | *Phalacrocorax brasilianus*            |                                  |
| Reddish Egret               | *Egretta rufescens*                    |                                  |
| Roseate spoonbill           | *Platalea ajaja*                       |                                  |
| Roseate tern                | *Sterna dougallii*                     |                                  |
| Royal tern                  | *Thalasseus maximus*                   |                                  |
| Sandwich tern               | *Thalasseus sandvicensis*              |                                  |
| Snowy egret                 | *Egretta thula*                        |                                  |
| Sooty tern                  | *Onychoprion fuscatus*                 |                                  |
| Tern, Royal or Sandwich     |                                        |                                  |
| Tern, Sooty or Brown Noddy  |                                        |                                  |
| Tricolored heron            | *Egretta tricolor*                     |                                  |
| White ibis                  | *Eudocimus albus*                      |                                  |
| White-faced ibis            | *Plegadis chihi*                       |                                  |
| Wood stork                  | *Mycteria americana*                   |                                  |
| Yellow-crowned night-heron  | *Nyctanassa violacea*                  |                                  |

<br>

#### b. R scripts {#scripts}

Annotated R scripts are available in the dedicated Github repository [GulfOfMexico_waterbird_atlas](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/tree/main).

<br>

##### i. 1_Prepare_original_datasets {#scripts_1}

This library can be found at <https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/tree/main/1_Prepare_original_datasets>. We created it to clean the original datasets. These scripts, which are specific to data providers and may be used on their own, were used for streamlining the data, to allow for a smooth inclusion into the coherent dataset structure.

<br>

##### ii. 2_Combine_all_data {#scripts_2}

This library can be found at <https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data>. We created it to combine cleaned datasets into a coherent structure. In addition to merging all the datasets, the main script ([2_1_Combine_all_data.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/1_Combine_all_data.R)) is also used for major edits across datasets. Most of these edits are part of the main script but we chose to keep some edits in their separate scripts because they required special attention:

-   [2_2_Match_colony_name_across_years.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_2_Match_colony_name_across_years.R): Modifies colony names so they match across years.

-   [2_3_Clean_ReddishEgret_morphs.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/3_Clean_ReddishEgret_morphs.R): Summarizes and cleans up data on Reddish Egret morphs.

-   [2_4_Fix_Double_counts.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_4_Fix_Double_counts.R): Fixes double-counting within datasets.

-   [2_5_Manage_TIG_overlap.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_5_Manage_TIG_overlap.R): Provides a framework for highlighting sites and years of overlap between terrestrial surveys and DWH Regionwide TIG surveys.

-   [2_6_Create_ArcGIS_datasets.R](https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/blob/main/2_Combine_all_data/2_6_Create_ArcGIS_datasets.R): Exports spatial datasets to the ArcGIS Online platform.

<br>

##### iii. 3_Prepare_data_summaries {#scripts_3}

We used this library to create ad-hoc data summaries during the building of the Atlas. This library can be found at <https://github.com/YvanSG/GulfOfMexico_waterbird_atlas/tree/main/3_Prepare_data_summaries>.

<br>

------------------------------------------------------------------------
END OF METHODS
July 2024