---
title: "README - Code and Data Replication archive"
subtitle: "Paper: \"title\""
author: "Authors: "
date: MON/DD/YYYY
output:
  html_document: default
  pdf_document: default
knit: (function(inputFile, encoding) {
  rmarkdown::render(inputFile, encoding = encoding, output_format = "all") })
---

Overview
--------

Example: The code in this replication package constructs the analysis file from the three data sources (Ruggles et al, 2018; Inglehart et al, 2019; BEA, 2016) using Stata and Julia. Two master files run all of the code to generate the data for the 15 figures and 3 tables in the paper. The replicator should expect the code to run for about 14 hours.

Files Structure 
----------------------------

> INSTRUCTIONS: short description of folders and files in the replication archive

1. `"README.md"`: a markdown file used to generate `"README.pdf"` and `"README.html"`
 
2. `"README.pdf"`: This document. It provides the necessary information about the structure of the replication folder, data sources and access, computational requirements, and ultimately explains how to fully replicate the analysis presented in the paper. Also available in html format `"README.html"`
 
3. `"code`: folder containing all scripts to clean, build, merge, and analyze the data

    a. `"code/raw2clean"`: R scripts that clean the data on input and save on the output for each raw data
    b. `"code/samples"`: R scripts that select the information relevant for this project and creates the sample with necessary variables for analysis
    c. `"code/analysis"`: R scripts to generate the results
    d. `"code/_functions"`: auxiliary folder with custom R functions used in multiple R scripts 
  
4. `"data"`: folder containing the raw data, final datasets for analysis, analysis outputs, and other empty folder for intermediate data to be stored when running the codes 

    a. `"data/raw2clean"`: raw datasets (`"/input"`) and cleaned (`"/output"`) folder (empty) separated by theme/source/geographic scope and accompanied by a `"documentation"` folder containing at least a `"_metadata.txt"` file with some general information and instructions on how to obtain the data if a direct link is not available
    b. `"data/samples"`: datasets containing the relevant variables for this project 
    c. `"data/analysis"`: analysis outputs, including all figures and tables presented in the paper
    d. `"data/_temp"`: temporary files output (to be filled when running some .R scripts)

5. `".Rproj"`: R project to automatically adjust file path references. Always open RStudio from this file when running any R script.

7. `"renv"`: not present in the replication archive but will be automatically created and filled with all the necessary R packages when running any R script. It is an independent library to guarantee the use of the same versions of the packages and avoid changing personal libraries.
