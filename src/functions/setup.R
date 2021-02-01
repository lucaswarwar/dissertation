
# > PROJECT INFO
# NAME: DISSERTATION
# LEAD: LUCAS WARWAR
#
# > THIS SCRIPT
# AIM: LOAD LIBRARIES, OPTIONS AND CUSTOM FUNCTIONS
# AUTHOR: LUCAS WARWAR
#
# > NOTES
# 1: -

# SETUP -----------------------------------------------

# OPTIONS ---------------------------------------------

Sys.setenv(TZ = "UTC") # LOCAL TIME ZONE
options(scipen = 99999) # DISABLE SCIENTIFIC NOTATION

# FUNCTIONS -------------------------------------------

`%nin%` <- Negate(`%in%`)

`%nlike%` <- Negate(`%like%`)

# LIBRARIES -------------------------------------------

# DIRECTORY AND FILE MANAGEMENT
library(here)

# DATA IMPORTING AND MANIPULATION

library(readr) # LOAD AND WRITE FILES
library(tidyr) # WRANGLE DATA
library(dplyr) # MANIPULATE DATA
library(magrittr) # PIPES
library(stringr) # HANDLE STRINGS
library(lubridate) # MANAGE DATES AND TIMES
library(haven) # LOAD .DTA FILES
library(foreign) # LAOD FOREIGN OBJECTS
library(data.table) # FAST DATA MANIPULATION
library(collapse) # HANDLE BIG DATASETS
library(janitor) # DATA CLEANING
library(bit64) # HANDLE INTEGERS
library(forcats) # HANDLE FACTORS
library(utf8) # UTF-8 ENCODING
library(pbapply) # PROGRESS BAR

# SPATIAL
library(sf) # IMPORTING AND MANAGING SPATIAL DATA
library(sp) # SUPPORTING PACKAGE
library(geobr) # BRAZILIAN SPATIAL DATA
library(ggmap) # GOOGLE'S API
library(maptools) # TOOLS
library(mapview) # QUICK VISUALIZATION
library(osmdata) # OPEN STREET MAP
library(h3jsr) # HEXAGONS

# DATA ANALYSIS

library(Hmisc) # STATISTICAL TOOLS
library(fixest) # FAST FIXED EFFECTS
library(lfe) # FIXED EFFECTS
library(plm) # PANEL DATA AND MODELS
library(AER) # ECONOMETRIC TOOLS
library(sandwich) # FAST STANDARD ERRORS
library(did) # DIFF-IN-DIFF
library(DRDID) # DOUBLE ROBUST DID
library(estimatr) # RELIABLE ESTIMATORS
library(gsynth) # SYNTHETIC CONTROL
library(mfx) # MARGINAL EFFECTS
library(margins) # MARGINAL EFFECTS STATA-STYLE
library(ivreg) # IV
library(broom) # CLEAN RESULTS
library(skimr) # SUMMARY DATA
library(vtable) # SUMMARY TABLES
library(modelsummary) # FREQUENCY TABLES

# DATA VIZ

library(ggplot2) # PLOTS
library(ggthemes) # THEMES AND FUNCTIONS
library(hrbrthemes) # MORE THEMES
library(labels) # PERCENTAGE
library(patchwork) # PLOT COMPOSITION
library(paletteer) # COLORS
library(RColorBrewer) # EVEN MORE COLORS

# OUTPUT TABLES AND DOCUMENTS
library(stargazer) # LATEX TABLES
library(ggtext) # FONTS
library(kableExtra) # TABLES
library(knitr) # KNIT DOCUMENTS

# WEB SCRAPPING
library(ralger) # TIDY SCRAP
library(rvest) # SCRAP
library(xml2) # XML FORMATS

# PARALLEL COMPUTING
library(purrr) # FUNCIONAL PROGRAMING
library(furrr) # VECTORIZE OPERATIONS
library(parallel) # OPTIMIZE OPERATIONS
library(future) # MORE PARALLELIZATION

# END OF SCRIPT ------------------------------------------