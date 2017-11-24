processNC - R Package for processing and analysing (large) NetCDF files in R
================
Matthias Biber
2017-11-24

Overview
--------

`processNC` is an R package for processing and analysing NetCDF files in R. Small NetCDF files can easily be loaded into R using the `raster()` function from the `raster` package in R, given that the `ncdf4` package is installed. However, using this approach the entire file is read into memory and so memory limits are reached quickly when trying to load large NetCDF files.

The need for this package arised from the task to load large NetCDF files with global daily climate data to calculate monthly or yearly averages. With this package this task can be achieved without having to read the entire file into memory.

For this, the package mainly consists of two functions:

-   `subsetNC()` subsets one or multiple NetCDF files by space (x,y), time and/or variable
-   `summariseNC()` summarises one or multiple NetCDF files over time
-   `cellstatsNC()` calculates the spatial mean of one or multiple NetCDF files

In addition, there is also a function called `summariseRaster`, which allows a similar implementation to the `summariseNC` function, but using raster files rather than NetCDF files.

There are also two functions (`mergeNC` and `aggregateNC`), which together provide a much faster alternative to the `summariseNC` function, but those functions rely on the Climate Data Operators (CDO) software (<https://code.mpimet.mpg.de/projects/cdo>). This software needs to be installed to use those two functions in R.

<!-- You can learn more about the different functions in `vignette("processNC")`.-->
Installation
------------

To *use* the package, it can be installed directly from GitHub using the `devtools` package.

``` r
# If not yet installed, install the devtools package
#install.packages("devtools")

# Download the package from GitHub
devtools::install_github("RS-eco/processNC")
```

Usage
-----

Load processNC package

``` r
library(processNC)
```

List NetCDF data files

``` r
# List daily temperature files for Germany from 1979 till 2013 (EWEMBI ISIMIP2b data)
files <- list.files(paste0(system.file(package="processNC"), "/extdata"), full.names=T)

# Show files
basename(files)
```

    [1] "tas_ewembi_deu_1979_1980.nc" "tas_ewembi_deu_1981_1990.nc"
    [3] "tas_ewembi_deu_1991_2000.nc" "tas_ewembi_deu_2001_2010.nc"
    [5] "tas_ewembi_deu_2011_2013.nc"

Subset NetCDF file

``` r
# Subset NetCDF files by time and rough extent of Bavaria
subsetNC(files, ext=c(8.5, 14, 47, 51), startdate=1990, enddate=1999)
```

    class       : RasterStack 
    dimensions  : 10, 6, 60, 3288  (nrow, ncol, ncell, nlayers)
    resolution  : 0.9166667, 0.4  (x, y)
    extent      : 8.5, 14, 47, 51  (xmin, xmax, ymin, ymax)
    coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
    names       : X1990.01.01, X1990.01.02, X1990.01.03, X1990.01.04, X1990.01.05, X1990.01.06, X1990.01.07, X1990.01.08, X1990.01.09, X1990.01.10, X1990.01.11, X1990.01.12, X1990.01.13, X1990.01.14, X1990.01.15, ... 
    min values  :    268.2550,    269.4496,    269.9260,    268.7616,    269.0258,    269.5515,    266.3336,    266.5575,    267.9392,    268.0426,    268.6588,    267.2176,    268.5135,    268.0288,    269.4830, ... 
    max values  :    272.5554,    272.0455,    272.0891,    272.1550,    273.2923,    274.2967,    272.8197,    273.3356,    274.3950,    273.8759,    274.0204,    273.8117,    272.9468,    274.2203,    275.7679, ... 

``` r
# Get SpatialPolygonsDataFrame of Bavaria
data(bavaria)

# Subset NetCDF file by SpatialPolygonDataFrame
subsetNC(files, ext=bavaria)
```

    class       : RasterBrick 
    dimensions  : 9, 5, 45, 12784  (nrow, ncol, ncell, nlayers)
    resolution  : 0.9727318, 0.3660113  (x, y)
    extent      : 8.975925, 13.83958, 47.27012, 50.56422  (xmin, xmax, ymin, ymax)
    coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
    data source : in memory
    names       : X1979.01.01, X1979.01.02, X1979.01.03, X1979.01.04, X1979.01.05, X1979.01.06, X1979.01.07, X1979.01.08, X1979.01.09, X1979.01.10, X1979.01.11, X1979.01.12, X1979.01.13, X1979.01.14, X1979.01.15, ... 
    min values  :    258.5225,    259.2864,    262.5962,    261.2245,    259.8299,    261.2420,    262.6502,    266.7570,    269.9405,    269.7677,    270.7775,    269.8421,    268.8952,    267.8006,    265.1033, ... 
    max values  :    265.4785,    262.7227,    265.5797,    263.6797,    261.9867,    263.5001,    265.7485,    270.3293,    273.8665,    272.1921,    272.2344,    271.9499,    270.9982,    269.5755,    267.8779, ... 

``` r
# Subset NetCDF file just by time
subsetNC(files, startdate=1990, enddate=1999)
```

    class       : RasterStack 
    dimensions  : 17, 14, 238, 3288  (nrow, ncol, ncell, nlayers)
    resolution  : 0.6071429, 0.4117647  (x, y)
    extent      : 6.25, 14.75, 47.75, 54.75  (xmin, xmax, ymin, ymax)
    coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
    names       : X1990.01.01, X1990.01.02, X1990.01.03, X1990.01.04, X1990.01.05, X1990.01.06, X1990.01.07, X1990.01.08, X1990.01.09, X1990.01.10, X1990.01.11, X1990.01.12, X1990.01.13, X1990.01.14, X1990.01.15, ... 
    min values  :    268.2550,    268.8760,    269.7884,    268.2937,    267.8489,    268.2939,    265.9402,    265.4810,    267.7947,    268.0426,    268.6028,    267.2176,    267.4866,    267.7701,    268.2850, ... 
    max values  :    274.5740,    274.6320,    274.9313,    273.3459,    276.0111,    276.3013,    277.2385,    278.2452,    279.2395,    279.6846,    280.9291,    280.3109,    277.7491,    276.3155,    278.7222, ... 

Summarise NetCDF file

``` r
# Summarise daily NetCDF file for 10 years 
summariseNC(files, startdate=2000, enddate=2009, group_col=c("month", "year"))
```

    class       : RasterBrick 
    dimensions  : 18, 15, 270, 12  (nrow, ncol, ncell, nlayers)
    resolution  : 0.5, 0.5  (x, y)
    extent      : 47.5, 55, 6, 15  (xmin, xmax, ymin, ymax)
    coord. ref. : NA 
    data source : in memory
    names       : January, February,  March,  April,    May,   June,   July, August, September, October, November, December 
    min values  :  269.89,   271.47, 274.21, 278.55, 283.54, 286.53, 287.96, 287.80,    283.78,  280.54,   274.96,   271.06 
    max values  :  276.62,   277.55, 280.30, 284.65, 289.23, 292.27, 293.59, 293.19,    289.14,  284.96,   280.78,   277.04 

``` r
# Summarise daily NetCDF files for all years
yearly_tas <- summariseNC(files, group_col="year")

# Calculate mean annual temperature for Germany
yearmean_tas <- as.data.frame(raster::cellStats(yearly_tas, stat="mean"))
colnames(yearmean_tas) <- "mean"
yearmean_tas <- tibble::rownames_to_column(yearmean_tas, var="year")
yearmean_tas$year <- sub("X", "", yearmean_tas$year)
yearmean_tas$mean <- yearmean_tas$mean - 273.15
head(yearmean_tas)
```

      year     mean
    1 1979 8.002458
    2 1980 7.866304
    3 1981 8.495996
    4 1982 9.263755
    5 1983 9.418830
    6 1984 8.307544

Summarise NetCDF file using CDO commands

``` r
#?mergeNC()
#?aggregateNC()
```

CellStats NetCDF file

``` r
# Summarise daily NetCDF file for 10 years and show first 6 values
head(cellstatsNC(files, startdate=2000, enddate=2009))
```

          mean       date
    1 273.7878 2000-01-01
    2 274.9809 2000-01-02
    3 275.6813 2000-01-03
    4 276.3606 2000-01-04
    5 277.3515 2000-01-05
    6 277.0308 2000-01-06

``` r
# Summarise daily NetCDF files without time limit
mean_daily_temp <- cellstatsNC(files)

# Summarise annual mean temperature of Germany 
mean_daily_temp$year <- lubridate::year(mean_daily_temp$date)
mean_daily_temp$mean <- mean_daily_temp$mean - 273.15
mean_annual_temp <- aggregate(mean ~ year, mean_daily_temp, mean)
```

Summarise raster file

``` r
#?summariseRaster()
```
