#' R Package for processing large NetCDF files in R
#'
#' Analysis of large NetCDF files (Cropping, Summarising) for 
#' further use with R using the raster package.
#' 
#' @name processNC-package
#' @aliases processNCpackage
#' @docType package
#' @title R Package for processing large NetCDF files in R
#' @author Matthias Biber
#'
#' @import ncdf4 raster sp parallel
#' @importFrom tidyselect one_of
#' @importFrom magrittr %>%
#' @importFrom readr read_csv write_csv
#' @importFrom abind abind
#' @importFrom tidyr gather
#' @importFrom dplyr funs group_by_at group_by summarise_all vars
#' @importFrom lubridate year month
#' @importFrom zoo as.yearmon
#' 
#' @keywords package
#'
NULL
#'
#' @docType data
#' @name bavaria
#' @title Global Administrative Boundary of Bavaria
#' @description Global Administrative Boundary (GADM) of Bavaria
#' @details This dataset is a shapefile containing a single polygon 
#' of the administrative boundary of Bavaria.
#' @format \code{sp::SpatialPolygonsDataFrame}
#' 
NULL