#' Aggregate values of multiple NetCDF Files
#'
#' @description
#' Aggregate spatio-temporal measurements of one raster stack with daily layers 
#' for multiple years to a raster stack with monthly layers
#' 
#' @param path \code{character}. Path of file to use.
#' @param mean \code{logical}.
#' @param error \code{logical}.
#' @param filename1 \code{character}. Filename for average monthly raster stack
#' @param filename2 \code{character}. Filename for monthly coefficient of variance raster stack
#' @param overwrite \code{logical}. Should file be overwritten or not.
#' @return A \code{numeric} raster stack with monthly layers of 
#' aggregated data over specificed time period.
#' 
#' @examples
#' \dontrun{
#' summariseRaster()
#' }
#' @export summariseRaster
#' @name summariseRaster
summariseRaster <- function(path=getwd(), mean=TRUE, error=TRUE, 
                            filename1=NA, filename2=NA, 
                            overwrite=FALSE){
  var <- strsplit(basename(path), split="_")[[1]][1]
  time <- strsplit(basename(path), split="_")[[1]][2]
  model <- strsplit(basename(path), split="_")[[1]][3]
  region <- strsplit(strsplit(basename(path), split="_")[[1]][4], split=".")[[1]][1]
  filename1 <- paste0("extdata/monthly_", var, "_", time, "_", model, "_", region, ".tif")
  filename2 <- paste0("extdata/monthly_cv_", var, "_", time, "_", model, "_", region, ".tif")

  if(overwrite==FALSE & file.exists(filename1)){
    avg <- raster::stack(filename1)
  } else{
    data <- raster::stack(path)
    
    # Get dates of file
    timeframes <- c("ref", "2050","2080","2100","2150")
    startyears <- c(1970,2036,2066,2086,2136)
    endyears <- c(1999,2065,2095,2115,2165)
    
    time <- grep(time, timeframes)
    startyear <- startyears[time]
    endyear <- endyears[time]
    
    # Convert start and endyear to dates
    startdate <- as.Date(paste0(startyear, "-01-01"))
    enddate <-  as.Date(paste0(endyear, "-12-31"))
    
    # Create list of dates and set dates of raster stack
    dates <- seq(startdate, enddate, by="day")
    data <- raster::setZ(data, dates, 'date')
    
    # Create function as.month
    as.month <- function(x) as.numeric(floor(lubridate::month(x)))
    
    requireNamespace("zoo")
    if(var %in% c("hurs", "huss", "tas", "sfcWind")){
      avg <- raster::zApply(data, by=as.yearmon, fun=mean, name='months', na.rm=TRUE)
    } else if(var == "pr"){
      avg <- raster::zApply(data, by=as.yearmon, fun=sum, name='months', na.rm=TRUE)
    } else if(var == "tasmax"){
      avg <- raster::zApply(data, by=as.yearmon, fun=max, name='months', na.rm=TRUE)
    } else if(var == "tasmin"){
      avg <- raster::zApply(data, by=as.yearmon, fun=min, name='months', na.rm=TRUE)
    }
    avg <- raster::zApply(avg, by=as.month, fun=mean, name='months', na.rm=TRUE)
    
    # Calculate mean per year and mean, sum, min, max per month
    if(mean==TRUE){
      raster::writeRaster(avg, filename=filename1, 
                  format="GTiff", overwrite=overwrite)
    }
    if(error==TRUE){
      cv <- raster::zApply(data, by=as.yearmon, fun=cv, name='months', na.rm=TRUE)
      cv <- raster::zApply(cv, by=as.month, fun=sum, name='months', na.rm=TRUE)
      raster::writeRaster(cv, filename=filename2, 
                  format="GTiff", overwrite=overwrite)
    }
  }; removeTmpFiles(h=0.01)
  return(avg)
}